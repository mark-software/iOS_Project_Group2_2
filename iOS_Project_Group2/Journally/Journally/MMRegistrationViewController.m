//
//  MMRegistrationViewController.m
//  Journally
//
//  Created by Mark Miller on 11/11/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import "MMRegistrationViewController.h"

@interface MMRegistrationViewController ()

@end

@implementation MMRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _emailField.backgroundColor = [UIColor whiteColor];
    _passwordField.backgroundColor = [UIColor whiteColor];
    _confirmPasswordField.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerUser:(NSString*)email password:(NSString*)password {
    //The id/objectId column is automatically created
    PFUser *user = [PFUser user];
    user.username = email;
    //user.email = email;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [MMHelper showAlert:@"Login successful!" title:@"Success!"];
            
        } else {
//            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
//            [MMHelper showAlert:errorString title:@"Error"];
            _errorLabel.text = error.userInfo[@"error"];
        }
    }];
    
}

-(BOOL)passwordsMatch {
    return [_passwordField.text isEqualToString:_confirmPasswordField.text];
}

-(BOOL)fieldsAreEmpty {
    return  [MMHelper fieldIsEmpty:_emailField] || [MMHelper fieldIsEmpty:_passwordField]
    || [MMHelper fieldIsEmpty:_confirmPasswordField];
}



- (IBAction)signupAction:(id)sender {
    if(![self passwordsMatch]) {
        //[MMHelper showAlert:@"Passwords do not match" title:@"Retype password"];
        _errorLabel.text = @"Passwords do not match";
        return;
    }
    if([self fieldsAreEmpty]) {
//        [MMHelper showAlert:@"Please complete all fields" title:@"Incomplete fields"];
        _errorLabel.text = @"Please complete all fields";
        return;
    }
        [self registerUser:_emailField.text password:_passwordField.text];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
