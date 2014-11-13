//
//  MyJournalViewController.m
//  Journally
//
//  Created by Harry Pho on 11/11/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import "MyJournalViewController.h"
#import "MMDatabaseHelper.h"
#import "MMJournalEntry.h"
#import "EntryDetailViewController.h"

@interface MyJournalViewController ()

@property (strong, nonatomic) NSMutableArray *allEntries;

@end

@implementation MyJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allEntries = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    
    [MMDatabaseHelper getAllJournalEntries:^(NSMutableArray *journalEntries) {
        
        for (MMJournalEntry *entry in journalEntries)
             [_allEntries addObject:entry];
        
        [self.tableView reloadData];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _allEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //UIImageView *avatar = (UIImageView *)[cell viewWithTag:0];
    //avatar.image = [UIImage imageNamed:@"avatar.jpg"];
    
    MMJournalEntry *currentEntry = _allEntries[indexPath.row];
    
    UILabel *usernameLabel = (UILabel *)[cell viewWithTag:1];
    usernameLabel.text = currentEntry.createdByUserId;
    
    UITextView *contentText = (UITextView *)[cell viewWithTag:2];
    contentText.text = ((MMJournalEntry *) _allEntries[indexPath.row]).textContent;
    
    UILabel *locationLabel = (UILabel *)[cell viewWithTag:4];
    locationLabel.text = ((MMJournalEntry *) _allEntries[indexPath.row]).cityStateName;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EntryDetails"])
    {
        EntryDetailViewController *nextViewController = segue.destinationViewController;
        
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        MMJournalEntry *selectedEntry = self.allEntries[path.row];
        
        nextViewController.entry = selectedEntry;
    }
}

@end