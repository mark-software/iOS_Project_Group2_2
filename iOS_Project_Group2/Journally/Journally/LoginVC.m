//
//  ViewController.m
//  Journally
//
//  Created by Harry Pho on 11/2/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)fieldsAreEmpty {
    return  [MMHelper fieldIsEmpty:_emailField] || [MMHelper fieldIsEmpty:_passwordField];
}

- (IBAction)loginAction:(id)sender {
    if([self fieldsAreEmpty]) {
        [MMHelper showAlert:@"Please complete all fields" title:@"Incomplete fields"];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:_emailField.text password:_passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [MMHelper showAlert:@"Logged In!" title:@"Success!"];
                                        } else {
                                            // The login failed. Check error to see why.
                                            
                                            [MMHelper showAlert:@"Username or password incorrect!" title:@"Invalid credentials"];
                                        }
                                    }];
}

@end
