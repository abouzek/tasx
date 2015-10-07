//
//  TAXLoginViewController.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXLoginViewController.h"
#import <Parse/Parse.h>
#import "TAXTasksViewController.h"
#import "TAXInstallation.h"

NSString *const TAXLoginToTasksSegueIdentifier = @"LoginToTasks";

@interface TAXLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation TAXLoginViewController

#pragma mark - actions

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        NSLog(@"logged in");
        TAXInstallation *currentInstallation = [TAXInstallation currentInstallation];
        TAXUser *currentUser = [TAXUser currentUser];
        currentInstallation.user = currentUser;
        currentInstallation.taskFamily = currentUser.taskFamily;
        [currentInstallation saveInBackground];
        [self performSegueWithIdentifier:TAXLoginToTasksSegueIdentifier sender:self];
    }];;
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    self.doneButton.hidden = ![self isValid];
}

#pragma mark - utility

- (BOOL)isValid {
    return self.usernameField.text.length
        && self.passwordField.text.length;
}

@end
