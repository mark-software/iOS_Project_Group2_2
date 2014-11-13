//
//  NewEntryViewController.h
//  Journally
//
//  Created by Harry Pho on 11/11/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEntryViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSString *currentUserID;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end
