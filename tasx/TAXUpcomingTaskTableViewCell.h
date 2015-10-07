//
//  TAXTaskTableViewCell.h
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAXRecurringTask.h"

@protocol TAXUpcomingTaskTableViewCellDelegate;


@interface TAXUpcomingTaskTableViewCell : UITableViewCell

- (void)styleForTask:(TAXRecurringTask *)task delegate:(id<TAXUpcomingTaskTableViewCellDelegate>)delegate;
- (void)styleForLoading:(BOOL)loading;

@end


@protocol TAXUpcomingTaskTableViewCellDelegate <NSObject>

- (void)upcomingTaskTableViewCell:(TAXUpcomingTaskTableViewCell *)cell didPressCompleteButton:(UIButton *)button;

@end
