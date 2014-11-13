//
//  MMSettingsVC.h
//  Journally
//
//  Created by Mark Miller on 11/11/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMHelper.h"

@interface MMSettingsVC : UIViewController
- (IBAction)addNameAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *realNameField;
@property (weak, nonatomic) IBOutlet UITextField *fakeNameField;


@property (weak, nonatomic) IBOutlet UITableView *nameTable;

@end
