//
//  TAXRecurringTask.h
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import <Parse/Parse.h>
#import "TAXUser.h"
#import "TAXTaskFamily.h"

@interface TAXRecurringTask : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSDate *dueDate;
@property (strong, nonatomic) NSDate *lastCompletedDate;
@property (strong, nonatomic) TAXUser *completingUser;
@property (strong, nonatomic) TAXTaskFamily *taskFamily;
@property (nonatomic) int repeatDays;
@property (nonatomic) int reminderHour;
@property (nonatomic) int reminderMinute;

+ (NSString *)parseClassName;
- (NSUInteger)daysUntilDue;

@end
