//
//  TAXUser.h
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import <Parse/Parse.h>
#import "TAXTaskFamily.h"

@interface TAXUser : PFUser<PFSubclassing>

@property (strong, nonatomic) TAXTaskFamily *taskFamily;

@end
