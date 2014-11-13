//
//  EntryDetailViewController.h
//  Journally
//
//  Created by Harry Pho on 11/12/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMJournalEntry.h"

@interface EntryDetailViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>

@property (strong, nonatomic) MMJournalEntry *entry;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
