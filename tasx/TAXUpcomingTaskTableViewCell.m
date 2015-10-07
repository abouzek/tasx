//
//  TAXTaskTableViewCell.m
//  tasx
//
//  Created by Alan Bouzek on 10/6/15.
//  Copyright © 2015 abouzek. All rights reserved.
//

#import "TAXUpcomingTaskTableViewCell.h"

@interface TAXUpcomingTaskTableViewCell ()

@property (weak, nonatomic) id<TAXUpcomingTaskTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end


@implementation TAXUpcomingTaskTableViewCell

- (void)styleForTask:(TAXRecurringTask *)task delegate:(id<TAXUpcomingTaskTableViewCellDelegate>)delegate {
    self.delegate = delegate;
    
    self.titleLabel.text = task.name;
    self.subtitleLabel.text = task.subtitle;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeButtonPressed:)];
    self.checkImageView.userInteractionEnabled = YES;
    [self.checkImageView addGestureRecognizer:tapGestureRecognizer];
    
    NSUInteger daysUntilDue = [task daysUntilDue];
    NSString *buttonText;
    if (daysUntilDue) {
        buttonText = [NSString stringWithFormat:@"Due in %ld days", [task daysUntilDue]];
    }
    else {
        buttonText = @"Due today";
    }
    
    [self.button setTitle:buttonText
                 forState:UIControlStateNormal];
}

- (void)styleForLoading:(BOOL)loading {
    self.checkImageView.hidden = loading;
    self.activityIndicatorView.hidden = !loading;
    [self.activityIndicatorView startAnimating];
}


#pragma mark - actions

- (IBAction)completeButtonPressed:(UIButton *)sender {
    [self.delegate upcomingTaskTableViewCell:self didPressCompleteButton:sender];
}

@end
