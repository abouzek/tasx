//
//  TAXCompletedTaskTableViewCell.h
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAXRecurringTask.h"

@interface TAXCompletedTaskTableViewCell : UITableViewCell

- (void)styleForTask:(TAXRecurringTask *)task;

@end
