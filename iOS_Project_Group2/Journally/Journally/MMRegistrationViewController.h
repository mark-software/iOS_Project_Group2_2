//
//  MMRegistrationViewController.h
//  Journally
//
//  Created by Mark Miller on 11/11/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MMHelper.h"

@interface MMRegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

- (IBAction)signupAction:(id)sender;

@end
