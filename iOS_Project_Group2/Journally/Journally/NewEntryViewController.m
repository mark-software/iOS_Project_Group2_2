//
//  NewEntryViewController.m
//  Journally
//
//  Created by Harry Pho on 11/11/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import "NewEntryViewController.h"
#import "MMJournalEntry.h"
#import "MMDatabaseHelper.h"

@interface NewEntryViewController ()
{
    MMJournalEntry *newEntry;
    __weak IBOutlet UITextView *contentTextView;
    __weak IBOutlet UITextField *contentView;
    IBOutlet UITextField *tagsField;
}

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    contentTextView.delegate = self;
    
    contentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    contentTextView.layer.borderWidth = 1.0;
    contentTextView.layer.cornerRadius = 8;
    
    [self.view addSubview:contentTextView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)mapNamesToVirtual: (NSString *)entryContent
{
    NSString *contentWithVirtualNames;
    return contentWithVirtualNames;
}

- (IBAction)postButton:(id)sender {
    
    NSMutableArray *tag = [[NSMutableArray alloc] initWithObjects:@"tag1", @"tag2", nil];
    
    newEntry = [[MMJournalEntry alloc] init];
    
    newEntry.createdByUserId = [NSString stringWithFormat:@"12345"];
    
    NSString *temp = [NSString stringWithFormat:_contentTextView.text];
    
    newEntry.textContent = _contentTextView.text;
    newEntry.cityStateName = [NSString stringWithFormat:@"Houston TX"];
    newEntry.lattitude = [NSString stringWithFormat:@"95"];
    newEntry.longitude = [NSString stringWithFormat:@"32"];
    newEntry.numberOfHearts = [NSString stringWithFormat:@"0"];
    newEntry.tags = tag;
    
    [MMDatabaseHelper addJournalEntry:newEntry];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)cancelButton:(id)sender {
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:TRUE];
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
