//
//  DatabaseHelper.h
//  ProjectGroup2
//
//  Created by Mark Miller on 11/9/14.
//  Copyright (c) 2014 cpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MMJournalEntry.h"
#import "MMHelper.h"

@interface MMDatabaseHelper : NSObject

//TODO: organize this header file...

//Note to self: when a journal entry is deleted we will also
//need to delete all the comments associated with that journal entry.
+(void) addJournalEntry:(MMJournalEntry *)entry;
+(void) deleteJournalEntry:(NSString *)journalId;
+(void) getAllJournalEntries:(void(^)(NSMutableArray *journalEntries))callback;
+(void) getAllJournalEntriesForUser:(NSString *)userId callback:(void(^)(NSMutableArray *journalEntries))callback;

+(void) addCommentToJournalEntry:(NSString *)comment journalId:(NSString *)journalId userId:(NSString *)userId;
+(void) getAllCommentsForJournalEntry:(NSString *)journalId callback:(void(^)(NSMutableArray *comments))callback;

+(void) addUserToFollow:(NSString *)currentUserId userIdToFollow:(NSString *)userIdToFollow;
+(void) getFollowers:(NSString *)currentUserId callback:(void(^)(NSArray *ids))callback;
+(void) getUsersFollowed:(NSString *)currentUserId callback:(void(^)(NSArray *ids))callback;

+(void) getObject:(NSString *)tableName objectId:(NSString *)objectId callback:(void(^)(PFObject *o, NSError *error))callback;

+(void) getUserId:(NSString *)email callback:(void(^)(NSString *userId))callback;

+(void) searchForJournalsByTag:(NSString *)tag callback:(void(^)(NSArray *journalEntries))callback;



//test methods...
+(void) addImageToJournalEntry:(UIImage *)image journalId:(NSString *)journalId;
+(void) getAllImagesForJournalEntry:(NSString *)journalId callback:(void(^)(UIImage *image))callback;

+(void) addVideoToJournalEntry:(NSURL *)videoUrl journalId:(NSString *)journalId;
+(void) getAllVideosForJournalEntry:(NSString *)journalId callback:(void(^)(NSData *videoData))callback;

+(void) addTagToJournalEntry:(NSString *)tag journalId:(NSString *)journalId;
+(void) addHeartToJournalEntry:(NSString *)userId  journalId:(NSString *)journalId;
+(void) getNumHeartsForJournalEntry:(NSString *) journalId callback:(void(^)(int numHearts))callback;

+(void) logoutCurrentUser;

@end
