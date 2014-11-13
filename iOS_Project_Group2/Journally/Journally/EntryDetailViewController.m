//
//  EntryDetailViewController.m
//  Journally
//
//  Created by Harry Pho on 11/12/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import "EntryDetailViewController.h"
#import "MMDatabaseHelper.h"

@interface EntryDetailViewController ()

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) NSMutableArray *allComments;

@end

@implementation EntryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentTextView.text = _entry.textContent;
    
    [MMDatabaseHelper getAllCommentsForJournalEntry:_entry.objId callback:^(NSMutableArray *comments) {
        _allComments = [[NSMutableArray alloc] initWithArray:comments];
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
    return _allComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //UIImageView *avatar = (UIImageView *)[cell viewWithTag:0];
    //avatar.image = [UIImage imageNamed:@"avatar.jpg"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Username"];
    cell.detailTextLabel.text = _allComments[indexPath.row];
    
    return cell;
}
- (IBAction)commentButton:(id)sender {

    NSString *comment = _commentTextField.text;
    NSString *journalID = _entry.objId;
    NSString *userID = _entry.createdByUserId;
    
    [MMDatabaseHelper addCommentToJournalEntry:comment journalId:journalID userId:userID];
    
    [self.tableView reloadData];
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
