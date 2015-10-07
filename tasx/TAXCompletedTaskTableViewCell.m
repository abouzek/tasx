//
//  TAXCompletedTaskTableViewCell.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXCompletedTaskTableViewCell.h"

@interface TAXCompletedTaskTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCompletedLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatIntervalLabel;

@end


@implementation TAXCompletedTaskTableViewCell

- (void)styleForTask:(TAXRecurringTask *)task {
    self.titleLabel.text = task.name;
    self.subtitleLabel.text = task.subtitle;
    
    NSString *lastCompletedText;
    if (task.completingUser) {
        lastCompletedText = [NSString stringWithFormat:@"Last completed by %@", task.completingUser.username];
    }
    else {
        lastCompletedText = @"Not yet completed";
    }
    self.lastCompletedLabel.text = lastCompletedText;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [formatter stringFromDate:task.dueDate];
    NSString *repeatIntervalText = [NSString stringWithFormat:@"Every %@ days - Next due %@", @(task.repeatDays), dateString];
    self.repeatIntervalLabel.text = repeatIntervalText;
}

@end
