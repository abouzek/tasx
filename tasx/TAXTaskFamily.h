//
//  TAXTaskFamily.h
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import <Parse/Parse.h>

@interface TAXTaskFamily : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *code;

+ (NSString *)parseClassName;

@end
