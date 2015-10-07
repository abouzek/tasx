//
//  TAXLandingViewController.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXLandingViewController.h"
#import "TAXUser.h"

NSString *const TAXLandingToTasksSegueIdentifier = @"LandingToTasks";

@implementation TAXLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([TAXUser currentUser]) {
        [self performSegueWithIdentifier:TAXLandingToTasksSegueIdentifier sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
