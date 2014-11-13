//
//  JournalEntry.h
//  ProjectGroup2
//
//  Created by Mark Miller on 11/9/14.
//  Copyright (c) 2014 cpl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMJournalEntry : NSObject

//Note: object id is automatically generated on the server side
@property (strong, nonatomic) NSString *objId;
@property (strong, nonatomic) NSString *textContent;
@property (strong, nonatomic) NSString *createdByUserId;
@property (strong, nonatomic) NSString *cityStateName;
@property (strong, nonatomic) NSString *lattitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSString* numberOfHearts;

@end
