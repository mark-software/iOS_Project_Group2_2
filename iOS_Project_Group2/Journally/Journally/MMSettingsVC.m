//
//  MMSettingsVC.m
//  Journally
//
//  Created by Mark Miller on 11/11/14.
//  Copyright (c) 2014 Team 2. All rights reserved.
//

#import "MMSettingsVC.h"

@interface MMSettingsVC ()

@end

@implementation MMSettingsVC

NSMutableArray *array;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *settings = [MMHelper getStringFromUserDefaults:@"nameMap"];
    [self parseStringToArray:settings];
}

-(void)viewDidAppear:(BOOL)animated {
    //initialize the array here... from memory..

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *DetailCellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:DetailCellIdentifier forIndexPath:indexPath];
    
    UILabel *leftLabel = (UILabel*)[cell viewWithTag:753];
    UILabel *rightLabel = (UILabel*)[cell viewWithTag:754];
    
    NSArray *words = [array[indexPath.row] componentsSeparatedByString:@","];
    
    leftLabel.text = words[0];
    rightLabel.text = words[1];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifier];
    }
    
    // setup your cell
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addNameAction:(id)sender {
    if([MMHelper fieldIsEmpty:_realNameField] || [MMHelper fieldIsEmpty:_fakeNameField]) {
        [MMHelper showAlert:@"Please fill in all fields" title:@"Incomplete data"];
        return;
    }
    
    //otherwise add it to the array... and add it to the saved list..
    NSString *names = [NSString stringWithFormat:@"%@,%@", _realNameField.text, _fakeNameField.text];
    [array addObject:names];
    NSString *namesToSave = array[0];
    for(int i=0; i<array.count-1; i++)
        namesToSave = [NSString stringWithFormat:@"%@;%@",namesToSave,array[i]];
    
    if(array.count > 1)
        namesToSave = [NSString stringWithFormat:@"%@;%@",namesToSave,array[array.count-1]];
    
    [MMHelper saveStringToUserDefaults:namesToSave key:@"nameMap"];
    
    _realNameField.text = @"";
    _fakeNameField.text = @"";
    
    [_nameTable reloadData];
}

-(void) parseStringToArray:(NSString *)string {
    if(string == nil) {
        array = [[NSMutableArray alloc] init];
        return;
    }
    NSArray *pairs = [string componentsSeparatedByString:@";"];
    if(pairs != nil) {
        array = [pairs mutableCopy];
    }
}

@end
