//
//  TAXRecurringTask.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXRecurringTask.h"
#import "PFObject+Subclass.h"

@implementation TAXRecurringTask

@dynamic name, subtitle, dueDate, lastCompletedDate, completingUser, taskFamily, repeatDays, reminderHour, reminderMinute;

+ (NSString *)parseClassName {
    return @"RecurringTask";
}

- (NSUInteger)daysUntilDue {
    NSDate *fromDate = [NSDate date];
    NSDate *toDate = self.dueDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:NSCalendarWrapComponents];
    return [difference day];
}
@end
