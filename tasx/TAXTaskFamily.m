//
//  TAXTaskFamily.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXTaskFamily.h"
#import "PFObject+Subclass.h"

@implementation TAXTaskFamily

@dynamic code;

+(NSString *)parseClassName {
    return @"TaskFamily";
}

@end
