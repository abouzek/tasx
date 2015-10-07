//
//  TAXRegisterViewController.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXRegisterViewController.h"
#import <Parse/Parse.h>
#import "TAXUser.h"
#import "TAXTaskFamily.h"
#import "TAXTasksViewController.h"
#import "TAXInstallation.h"

NSString *const TAXRegisterToTasksSegueIdentifier = @"RegisterToTasks";

@interface TAXRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *groupCodeField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end


@implementation TAXRegisterViewController


#pragma mark - actions

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    TAXUser *user = [TAXUser object];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    PFQuery *familyQuery = [PFQuery queryWithClassName:[TAXTaskFamily parseClassName]];
    [familyQuery whereKey:@"code" equalTo:self.groupCodeField.text];
    [familyQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 1) {
            // Task family found, add user to it
            NSLog(@"task family found");
            TAXTaskFamily *taskFamily = (TAXTaskFamily *)[objects firstObject];
            user.taskFamily = taskFamily;
            [self createUser:user];
        }
        else {
            // Task family not found, create one
            TAXTaskFamily *taskFamily = [TAXTaskFamily object];
            taskFamily.code = self.groupCodeField.text;
            [taskFamily saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                NSLog(@"created task family: %@", taskFamily.objectId);
                user.taskFamily = taskFamily;
                [self createUser:user];
            }];
        }
    }];
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    self.doneButton.hidden = ![self isValid];
}


#pragma mark - utility

- (BOOL)isValid {
    return self.usernameField.text.length
        && self.passwordField.text.length
        && self.groupCodeField.text.length;
}

- (void)createUser:(TAXUser *)user {
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"success");
            TAXInstallation *currentInstallation = [TAXInstallation currentInstallation];
            currentInstallation.user = user;
            currentInstallation.taskFamily = user.taskFamily;
            [currentInstallation saveInBackground];
            [self performSegueWithIdentifier:TAXRegisterToTasksSegueIdentifier sender:self];
        }
        else {
            NSLog(@"failure");
        }
    }];
}

@end
