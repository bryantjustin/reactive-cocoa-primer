//
//  LoginViewController.m
//  Reactive Cocoa Primer
//
//  Created by Bryant Balatbat on 2014-04-22.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <RACEXTScope.h>

#import "SignInViewController.h"
#import "SuccessViewController.h"

#define BUTTON_ENABLED_COLOR    [UIColor colorWithRed:55./255. green:200./255. blue:55./255. alpha:1.]
#define BUTTON_DISABLED_COLOR   [UIColor colorWithRed:170./255. green:170./255. blue:170./255. alpha:1.]

@interface SignInViewController ()

@property (nonatomic,weak) IBOutlet UITextField *usernameField;
@property (nonatomic,weak) IBOutlet UITextField *passwordField;
@property (nonatomic,weak) IBOutlet UIButton *submitButton;

@property (nonatomic,weak) IBOutlet UILabel *hoursField;
@property (nonatomic,weak) IBOutlet UILabel *minutesField;
@property (nonatomic,weak) IBOutlet UILabel *secondsField;

@end

@implementation SignInViewController
{
    NSTimer *timer;
}

/******************************************************************************/

#pragma mark - Inherited methods

/******************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Sign In";
    
    [self updateFieldsWithCurrentTime];
    timer = [NSTimer
        scheduledTimerWithTimeInterval:1.
        target:self
        selector:@selector(onTimerInterval)
        userInfo:nil
        repeats:YES
    ];
    
    [self.submitButton
        addTarget:self
        action:@selector(didTapSubmitButton:)
        forControlEvents:UIControlEventTouchUpInside
    ];
}

/******************************************************************************/

#pragma mark - UITextFieldDelegate

/******************************************************************************/

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string
{
    BOOL isValid = self.isFormValid;
    
    self.submitButton.enabled = isValid;
    [self.submitButton setBackgroundColor:(isValid ? BUTTON_ENABLED_COLOR : BUTTON_DISABLED_COLOR)];
    
    return YES;
}

/******************************************************************************/

#pragma mark - UIControlEvent handler

/******************************************************************************/

- (void)didTapSubmitButton:(id)sender
{
    [self openSuccessView];
}

/******************************************************************************/

#pragma mark - Timer methods

/******************************************************************************/

- (void)onTimerInterval
{
    [self updateFieldsWithCurrentTime];
}

- (void)updateFieldsWithCurrentTime
{
    NSCalendar *calendar =[NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar
        components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
        fromDate:[NSDate date]
    ];
    self.hoursField.text    = [self formatTime:dateComponents.hour];
    self.minutesField.text  = [self formatTime:dateComponents.minute];
    self.secondsField.text  = [self formatTime:dateComponents.second];
}

- (NSString *)formatTime:(NSInteger)unit
{
    return [NSString stringWithFormat:@"%02ld", unit];
}

/******************************************************************************/

#pragma mark - Opens view methods

/******************************************************************************/

- (void)openSuccessView
{
    [self.navigationController
        pushViewController:[[SuccessViewController alloc]
            initWithNibName:SuccessViewController.class.description
            bundle:nil]
        animated:YES
    ];
}

/******************************************************************************/

#pragma mark - Form validation

/******************************************************************************/

- (BOOL)isFormValid
{
    return [self.usernameField.text length] > 0
    && [self.passwordField.text length] > 0;
}

@end
