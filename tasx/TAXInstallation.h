//
//  TAXInstallation.h
//  tasx
//
//  Created by Alan Bouzek on 10/7/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "PFInstallation.h"
#import "TAXUser.h"

@interface TAXInstallation : PFInstallation

@property (strong, nonatomic) TAXUser *user;
@property (strong, nonatomic) TAXTaskFamily *taskFamily;

@end
