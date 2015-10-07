//
//  TAXTaskCreateViewController.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXTaskCreateViewController.h"
#import "TAXRecurringTask.h"

@interface TAXTaskCreateViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *firstDueDateField;
@property (weak, nonatomic) IBOutlet UITextField *reminderTimeField;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIStepper *repeatDaysStepper;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIDatePicker *timePicker;

@property (strong, nonatomic) NSDate *dueDate;
@property (strong, nonatomic) NSDate *reminderTime;
@property (nonatomic) int repeatDays;

@end

@implementation TAXTaskCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.repeatDays = 7;
    self.repeatDaysStepper.value = self.repeatDays;
    
    [self setupPickers];
}


#pragma mark - setup

- (void)setupPickers {
    UIToolbar *doneButtonToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(pickerDoneButtonPressed:)];
    [doneButtonToolbar setItems:@[flexButton, doneButton]];
    
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate date];
    [self.datePicker addTarget:self
                        action:@selector(updateDueDateText)
              forControlEvents:UIControlEventValueChanged];
    self.firstDueDateField.inputView = self.datePicker;
    self.firstDueDateField.inputAccessoryView = doneButtonToolbar;
    
    self.timePicker = [UIDatePicker new];
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.minuteInterval = 30;
    [self.timePicker addTarget:self
                        action:@selector(updateReminderTimeText)
              forControlEvents:UIControlEventValueChanged];
    self.reminderTimeField.inputView = self.timePicker;
    self.reminderTimeField.inputAccessoryView = doneButtonToolbar;
}


#pragma mark - actions

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    TAXRecurringTask *task = [TAXRecurringTask object];
    task.name = self.nameField.text;
    task.subtitle = self.descriptionField.text;
    task.dueDate = self.dueDate;
    task.repeatDays = self.repeatDays;
    task.taskFamily = [TAXUser currentUser].taskFamily;
    
    if (self.reminderTime) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute)
                                                   fromDate:self.reminderTime];
        task.reminderHour = (int)[components hour];
        task.reminderMinute = (int)[components minute];
    }
    else {
        task.reminderHour = -1;
        task.reminderMinute = -1;
    }
    
    [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Success");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"Failure");
        }
    }];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    self.repeatDays = sender.value;
    NSString *repeatText = [NSString stringWithFormat:@"Repeat Every %@ Days", @(self.repeatDays)];
    self.repeatLabel.text = repeatText;
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    [self updateDoneButton];
}

- (IBAction)dueDateFieldEditingDidBegin:(UITextField *)sender {
    [self updateDueDateText];
}

- (void)updateDueDateText {
    self.dueDate = self.datePicker.date;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.firstDueDateField.text = [formatter stringFromDate:self.datePicker.date];
    
    [self updateDoneButton];
}

- (IBAction)reminderTimeFieldEditingDidBegin:(UITextField *)sender {
//    [self updateReminderTimeText];
}

- (void)updateReminderTimeText {
    self.reminderTime = self.timePicker.date;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    self.reminderTimeField.text = [formatter stringFromDate:self.timePicker.date];
    
    [self updateDoneButton];
}

- (void)pickerDoneButtonPressed:(UIButton *)button {
    [self.firstDueDateField resignFirstResponder];
    [self.reminderTimeField resignFirstResponder];
}


#pragma mark - utility

- (BOOL)isValid {
    return self.nameField.text.length
        && self.descriptionField.text.length
        && self.firstDueDateField.text.length
        && self.repeatLabel.text.length;
}

- (void)updateDoneButton {
    self.doneButton.hidden = ![self isValid];
}

@end
