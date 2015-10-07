//
//  AppDelegate.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "TAXUser.h"
#import "TAXRecurringTask.h"
#import "TAXTaskFamily.h"
#import "TAXInstallation.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TAXUser registerSubclass];
    [TAXTaskFamily registerSubclass];
    [TAXRecurringTask registerSubclass];
    [TAXInstallation registerSubclass];
    
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:configPath];
    [Parse setApplicationId:config[@"ParseApplicationId"]
                  clientKey:config[@"ParseClientKey"]];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    TAXInstallation *currentInstallation = [TAXInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    NSLog(@"got push");
}

@end
