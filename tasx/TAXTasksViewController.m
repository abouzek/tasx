//
//  TAXTasksViewController.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXTasksViewController.h"
#import "TAXRecurringTask.h"
#import "TAXUpcomingTaskTableViewCell.h"
#import "TAXCompletedTaskTableViewCell.h"

const NSUInteger TAXUpcomingDaysThreshold = 3;
const NSUInteger SecondsPerDay = 60 * 60 * 24;

@interface TAXTasksViewController () <UITableViewDataSource, UITableViewDelegate, TAXUpcomingTaskTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *upcomingTasks;
@property (strong, nonatomic) NSMutableArray *recentlyCompletedTasks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation TAXTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self fetchTasks];
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? self.upcomingTasks.count : self.recentlyCompletedTasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *tasks = [self tasksForSection:indexPath.section];
    TAXRecurringTask *task = tasks[indexPath.row];
    
    if (indexPath.section == 0) {
        TAXUpcomingTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TAXUpcomingTaskTableViewCell class])];
        [cell styleForTask:task delegate:self];
        return cell;
    }
    else {
        TAXCompletedTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TAXCompletedTaskTableViewCell class])];
        [cell styleForTask:task];
        return cell;
    }
    
    // urine trouble
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *taskArray = [self tasksForSection:indexPath.section];
        [taskArray[indexPath.row] deleteInBackground];
        [taskArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Upcoming" : @"Completed Recently";
}


#pragma mark - TAXTaskTableViewCellDelegate

-(void)upcomingTaskTableViewCell:(TAXUpcomingTaskTableViewCell *)cell didPressCompleteButton:(UIButton *)button {
    [cell styleForLoading:YES];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TAXRecurringTask *task = [self tasksForSection:indexPath.section][indexPath.row];
    task.completingUser = [TAXUser currentUser];
    task.lastCompletedDate = [NSDate date];
    NSDate *nextDueDate = [task.dueDate dateByAddingTimeInterval:(task.repeatDays * SecondsPerDay)];
    task.dueDate = nextDueDate;
    [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [cell styleForLoading:NO];
        if (succeeded) {
            NSLog(@"success");
            [self.upcomingTasks removeObjectAtIndex:indexPath.row];
            [self.recentlyCompletedTasks addObject:task];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"failure");
        }
    }];
}


#pragma mark - utility

- (void)fetchTasks {
    PFQuery *taskQuery = [PFQuery queryWithClassName:[TAXRecurringTask parseClassName]];
    [taskQuery whereKey:@"taskFamily" equalTo:[TAXUser currentUser].taskFamily];
    [taskQuery includeKey:@"completingUser"];
    [taskQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self splitTasksFromTasks:objects];
        [self.tableView reloadData];
    }];
}

- (void)splitTasksFromTasks:(NSArray *)tasks {
    self.upcomingTasks = [NSMutableArray new];
    self.recentlyCompletedTasks = [NSMutableArray new];
    for (TAXRecurringTask *task in tasks) {
        if ([task daysUntilDue] < TAXUpcomingDaysThreshold) {
            [self.upcomingTasks addObject:task];
        }
        else {
            [self.recentlyCompletedTasks addObject:task];
        }
    }
}

- (NSMutableArray *)tasksForSection:(NSUInteger)section {
    return (section == 0) ? self.upcomingTasks : self.recentlyCompletedTasks;
}
@end
