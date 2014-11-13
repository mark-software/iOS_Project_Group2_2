//
//  DatabaseHelper.m
//  ProjectGroup2
//
//  Created by Mark Miller on 11/9/14.
//  Copyright (c) 2014 cpl. All rights reserved.
//

#import "MMDatabaseHelper.h"

NSString *const JournalTable = @"JournalEntries";
NSString *const CommentsTable = @"Comments";
NSString *const FollowersTable = @"Followers";
NSString *const ImagesTable = @"Images";
NSString *const VideoTable = @"Videos";
NSString *const HeartsTable = @"Hearts";

//Note: this implementation violates the Single Responsibility Principle
//for those who care about good design..

//Note: all of these calls are asynchronous

@implementation MMDatabaseHelper

+(void) addJournalEntry:(MMJournalEntry *)entry {
    PFObject *journalEntry = [PFObject objectWithClassName:JournalTable];
    
    journalEntry[@"createdByUserId"] = entry.createdByUserId;
    journalEntry[@"cityStateName"] = entry.cityStateName;
    journalEntry[@"lattitude"] = entry.lattitude;
    journalEntry[@"longitude"] = entry.longitude;
    journalEntry[@"textContent"] = entry.textContent;
    journalEntry[@"numberOfHearts"] = entry.numberOfHearts;
    if(entry.tags != nil)
        journalEntry[@"tags"] = [entry.tags componentsJoinedByString:@","];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    journalEntry[@"dateCreated"] = [dateFormatter stringFromDate:now];
    
    //save it
    [journalEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
            [MMHelper showAlert:@"Entry added!" title:@"Success!"];
        else
            [MMHelper showAlert:error title:@"Error"];
    }];
}

//============================Separator============================

+(void) getAllJournalEntries:(void(^)(NSMutableArray *journalEntries))callback {
    PFQuery *query = [PFQuery queryWithClassName:JournalTable];
    [query findObjectsInBackgroundWithBlock:^(NSArray *entries, NSError *error) {
        if(entries != nil && entries.count > 0) {
            NSMutableArray *mainEntries = [[NSMutableArray alloc] init];
            for (PFObject *entry in entries) {
                //convert to journal entry...
                MMJournalEntry *je = [[MMJournalEntry alloc] init];
                je.objId = entry.objectId;
                je.textContent = entry[@"textContent"];
                je.createdByUserId = entry[@"createdByUserId"];
                je.cityStateName = entry[@"cityStateName"];
                je.lattitude = entry[@"lattitude"];
                je.longitude = entry[@"longitude"];
                je.lattitude = entry[@"lattitude"];
                je.tags = [NSMutableArray arrayWithArray:[entry[@"tags"] componentsSeparatedByString:@","]];
                je.numberOfHearts = entry[@"numberOfHearts"];
                
                [mainEntries addObject:je];
            }
            callback(mainEntries);
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

+(void) getAllJournalEntriesForUser:(NSString *)userId callback:(void(^)(NSMutableArray *journalEntries))callback {
    PFQuery *query = [PFQuery queryWithClassName:JournalTable];
    [query whereKey:@"userId" equalTo:userId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *entries, NSError *error) {
        if(entries != nil && entries.count > 0) {
            NSMutableArray *mainEntries = [[NSMutableArray alloc] init];
            for (PFObject *entry in entries) {
                //convert to journal entry...
                MMJournalEntry *je = [[MMJournalEntry alloc] init];
                je.objId = entry.objectId;
                je.textContent = entry[@"textContent"];
                je.createdByUserId = entry[@"createdByUserId"];
                je.cityStateName = entry[@"cityStateName"];
                je.lattitude = entry[@"lattitude"];
                je.longitude = entry[@"longitude"];
                je.lattitude = entry[@"lattitude"];
                je.tags = [NSMutableArray arrayWithArray:[entry[@"tags"] componentsSeparatedByString:@","]];
                je.numberOfHearts = entry[@"numberOfHearts"];
                
                [mainEntries addObject:je];
            }
            callback(mainEntries);
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

+(void) deleteJournalEntry:(NSString *)journalId {
    //first delete any comments with this journalId
    PFQuery *commentQuery = [PFQuery queryWithClassName:CommentsTable];
    [commentQuery whereKey:@"journalId" equalTo:journalId];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) { //no error
            for (PFObject *obj in objects)
                [obj deleteInBackground];
        }
    }];
    
    //delete the journal entry
    [self getObject:JournalTable objectId:journalId callback:^(PFObject *journalEntry, NSError *error) {
        if(error == nil)
            [journalEntry deleteInBackground];
    }];
}

//============================Separator============================

+(void) addCommentToJournalEntry:(NSString *)comment journalId:(NSString *)journalId userId:(NSString *)userId {
    PFObject *commentEntry = [PFObject objectWithClassName:CommentsTable];
    commentEntry[@"journalId"] = journalId;
    commentEntry[@"comment"] = comment;
    commentEntry[@"userId"] = userId;
    
    //save it
    [commentEntry saveInBackground];
}

//============================Separator============================

//get all comments for journal as an array of strings
+(void) getAllCommentsForJournalEntry:(NSString *)journalId callback:(void(^)(NSMutableArray *comments))callback {
    PFQuery *query = [PFQuery queryWithClassName:CommentsTable];
    [query whereKey:@"journalId" equalTo:journalId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *commnts, NSError *error) {
        if(commnts != nil && commnts.count > 0) {
            NSMutableArray *mainComments = [[NSMutableArray alloc] init];
            for(PFObject *obj in commnts) {
                NSString *cmnt = obj[@"comment"];
                [mainComments addObject:cmnt];
            }
            callback(mainComments);
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

//Add someone that is following me
//This method should remain private. Only use the addUserFollowed method
+(void) addFollower:(NSString *)currentUserId userIdToFollow:(NSString *)userIdToFollow {
    [self getFollowers:currentUserId callback:^(NSArray *ids) {
        if(ids != nil && ids.count > 0) {
            NSArray *followerIds = [ids arrayByAddingObjectsFromArray:@[userIdToFollow]];
            [self setFollowers:currentUserId followers:followerIds];
        }
        else {
            //It needs to be created
            PFObject *followers = [PFObject objectWithClassName:FollowersTable];
            followers[@"userId"] = currentUserId;
            followers[@"followerIds"] = userIdToFollow;
            followers[@"userIdsFollowed"] = @"";
            
            //save it
            [followers saveInBackground];
        }
    }];
}

//============================Separator============================

//Add someone that I am following
+(void) addUserToFollow:(NSString *)currentUserId userIdToFollow:(NSString *)userIdToFollow {
    [self getUsersFollowed:currentUserId callback:^(NSArray *ids) {
        if(ids != nil && ids.count > 0) {
            NSArray *idsFollowed = [ids arrayByAddingObjectsFromArray:@[userIdToFollow]];
            [self setUsersFollowed:currentUserId followers:idsFollowed];
        }
        else {
            //It needs to be created
            PFObject *followers = [PFObject objectWithClassName:FollowersTable];
            followers[@"userId"] = currentUserId;
            followers[@"followerIds"] = @"";
            followers[@"userIdsFollowed"] = userIdToFollow;
            
            //save it
            [followers saveInBackground];
        }
    }];
    
    //here I need to add a follower when I say I am following a new user...
    [self addFollower:userIdToFollow userIdToFollow:currentUserId];
}

//============================Separator============================

//user must exist before this method is called
+(void) setFollowers:(NSString *)currentUserId followers:(NSArray *)followers {
    PFQuery *query = [PFQuery queryWithClassName:FollowersTable];
    [query whereKey:@"userId" equalTo:currentUserId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followee, NSError *error) {
        NSString *myFollowers = [followers componentsJoinedByString:@","];
        followee[0][@"followerIds"] = myFollowers;
        
        [followee[0] saveInBackground];
    }];
}

//============================Separator============================

//user must exist before this method is called
+(void) setUsersFollowed:(NSString *)currentUserId followers:(NSArray *)usersIdsFollowed {
    PFQuery *query = [PFQuery queryWithClassName:FollowersTable];
    [query whereKey:@"userId" equalTo:currentUserId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followee, NSError *error) {
        NSString *myFollowees = [usersIdsFollowed componentsJoinedByString:@","];
        followee[0][@"userIdsFollowed"] = myFollowees;
        
        [followee[0] saveInBackground];
    }];
}

//============================Separator============================

//and a generic method to get an object... the id must match the actual id.. not the id column added
+(void) getObject:(NSString *)tableName objectId:(NSString *)objectId callback:(void(^)(PFObject *o, NSError *error))callback {
    PFQuery *query = [PFQuery queryWithClassName:tableName];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *obj, NSError *error) {
        callback(obj, error); //I'm relying on the caller to check for nil
    }];
}

//============================Separator============================

+(void) getUserId:(NSString *)email callback:(void(^)(NSString *userId))callback {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects != nil && objects.count > 0) {
            PFUser *user = objects[0];
            callback(user.objectId);
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

//returns an array of user ids
+(void) getFollowers:(NSString *)currentUserId callback:(void(^)(NSArray *ids))callback {
    PFQuery *query = [PFQuery queryWithClassName:FollowersTable];
    [query whereKey:@"userId" equalTo:currentUserId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followee, NSError *error) {
        if(followee != nil && followee.count > 0) {
            NSString *followers = followee[0][@"followerIds"];
            NSArray *followerIds = [followers componentsSeparatedByString:@","];
            callback(followerIds);
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

//returns an array of user ids
+(void) getUsersFollowed:(NSString *)currentUserId callback:(void(^)(NSArray *ids))callback {
    PFQuery *query = [PFQuery queryWithClassName:FollowersTable];
    [query whereKey:@"userId" equalTo:currentUserId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followee, NSError *error) {
        if(followee != nil && followee.count > 0) {
            NSString *followees = followee[0][@"userIdsFollowed"];
            NSArray *followeeIds = [followees componentsSeparatedByString:@","];
            callback(followeeIds);
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

//returns an actual array of journal entries... or nil if not found
+(void) searchForJournalsByTag:(NSString *)tag callback:(void(^)(NSArray *journalEntries))callback {
    //Parse does not support regular expression clauses.. so this is done inefficiently...
    PFQuery *query = [PFQuery queryWithClassName:JournalTable];
    [query whereKeyExists:@"tags"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *entries, NSError *error) {
        if(entries != nil && entries.count > 0) { //no error
            NSMutableArray *mainEntries = [[NSMutableArray alloc] init];
            for (PFObject *entry in entries) {
                NSString *t = entry[@"tags"];
                if(![t containsString:tag])
                    continue;
                
                //convert to journal entry...
                MMJournalEntry *je = [[MMJournalEntry alloc] init];
                je.objId = entry.objectId;
                je.textContent = entry[@"textContent"];
                je.createdByUserId = entry[@"createdByUserId"];
                je.cityStateName = entry[@"cityStateName"];
                je.lattitude = entry[@"lattitude"];
                je.longitude = entry[@"longitude"];
                je.lattitude = entry[@"lattitude"];
                je.tags = [NSMutableArray arrayWithArray:[entry[@"tags"] componentsSeparatedByString:@","]];
                je.numberOfHearts = entry[@"numberOfHearts"];
                
                [mainEntries addObject:je];
            }
            
            if(mainEntries.count > 0) {
                NSArray *entryArray = [mainEntries copy];
                callback(entryArray);
            }
            else
                callback(nil);
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

//I assume that we can only add images and video to journal entries and not comments..
//Note: you can get the image back with: UIImage *img = [UIImage imageWithData:data];
+(void) addImageToJournalEntry:(UIImage *)image journalId:(NSString *)journalId {
    //compress the image
    NSData* data = UIImageJPEGRepresentation(image, 0.5f);
    PFObject *imageObj = [PFObject objectWithClassName:ImagesTable];
    imageObj[@"journalId"] = journalId;
    
    //maybe add a parameter for filename..
    PFFile *file = [PFFile fileWithName:@"image.jpg" data:data];
    imageObj[@"imageBlob"] = file;
    
    [imageObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
            [MMHelper showAlert:@"Entry added!" title:@"Success!"];
        else
            [MMHelper showAlert:error title:@"Error"];
    }];
}

//============================Separator============================

//Note: the callback for this method will be called once for each image
+(void) getAllImagesForJournalEntry:(NSString *)journalId callback:(void(^)(UIImage *image))callback {
    PFQuery *query = [PFQuery queryWithClassName:ImagesTable];
    [query whereKey:@"journalId" equalTo:journalId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *imgs, NSError *error) {
        if(imgs != nil && imgs.count > 0) {
            for(PFObject *obj in imgs) {
                PFFile *file = obj[@"imageBlob"];
                
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if(data != nil)
                        callback([UIImage imageWithData:data]);
                    else
                        callback(nil);
                }];
            }
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

//Video must be small! <=10MB
+(void) addVideoToJournalEntry:(NSURL *)videoUrl journalId:(NSString *)journalId {
    NSData *data = [NSData dataWithContentsOfURL:videoUrl];
    PFFile *videoFile = [PFFile fileWithName:@"video.mp4" data:data];
    
    PFObject *videoObj = [PFObject objectWithClassName:VideoTable];
    videoObj[@"journalId"] = journalId;
    videoObj[@"videoBlob"] = videoFile;
    
    [videoObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
            [MMHelper showAlert:@"Entry added!" title:@"Success!"];
        else
            [MMHelper showAlert:error title:@"Error"];
    }];
}

//============================Separator============================

//TODO: NSData can be used to play the videos but the return value should be more meaningful
//Note: the callback for this method will be called once for each video
+(void) getAllVideosForJournalEntry:(NSString *)journalId callback:(void(^)(NSData *videoData))callback {
    PFQuery *query = [PFQuery queryWithClassName:VideoTable];
    [query whereKey:@"journalId" equalTo:journalId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *vdeos, NSError *error) {
        if(vdeos != nil && vdeos.count > 0) {
            for(PFObject *obj in vdeos) {
                PFFile *file = obj[@"videoBlob"];
                
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if(data != nil)
                        callback(data);
                    else
                        callback(nil);
                }];
            }
        }
        else
            callback(nil);
    }];
}

//============================Separator============================

//the journal must obviously exist for this to work...
+(void) addTagToJournalEntry:(NSString *)tag journalId:(NSString *)journalId {
    //first get the journal
    [self getObject:JournalTable objectId:journalId callback:^(PFObject *o, NSError *error) {
        if(o != nil && error == nil) {
            //then we can add it..
            NSString *tags = o[@"tags"];
            if(tags == nil || [MMHelper stringIsEmpty:tags]) {
                //then just set it..
                o[@"tags"] = tag;
            }
            else {
                //add a comma and the word...
                NSString *newTagSet = [NSString stringWithFormat:@"%@,%@",tags, tag];
                o[@"tags"] = newTagSet;
            }
            
            [o saveInBackground];
        }
    }];
}

//============================Separator============================

//this method assumes that each unique user can only add one heart to each journal entry
+(void) addHeartToJournalEntry:(NSString *)userId  journalId:(NSString *)journalId {
    //first query for the object and if it is nil then go ahead and create it.. otherwise leave it alone..
    PFQuery *query = [PFQuery queryWithClassName:HeartsTable];
    [query whereKey:@"journalId" equalTo:journalId];
    [query whereKey:@"userId" equalTo:userId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objs, NSError *error) {
        if(objs == nil || objs.count == 0) {
            //then we can create it..
            PFObject *heart = [PFObject objectWithClassName:HeartsTable];
            heart[@"userId"] = userId;
            heart[@"journalId"] = journalId;
            
            [heart saveInBackground];
        }
    }];
}

//============================Separator============================

+(void) getNumHeartsForJournalEntry:(NSString *) journalId callback:(void(^)(int numHearts))callback {
    //first query for the object and if it is nil then go ahead and create it.. otherwise leave it alone..
    PFQuery *query = [PFQuery queryWithClassName:HeartsTable];
    [query whereKey:@"journalId" equalTo:journalId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objs, NSError *error) {
        if(objs == nil) callback(0);
        callback(objs.count);
    }];
}

+(void) logoutCurrentUser {
    [PFUser logOut];
}



@end
