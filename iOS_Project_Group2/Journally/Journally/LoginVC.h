//
//  ViewController.h
//  Journally
//
//  Created by Harry Pho on 11/2/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MMHelper.h"

@interface LoginVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginErrorLabel;

@end

