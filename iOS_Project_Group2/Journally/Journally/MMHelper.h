//
//  SettingsHelper.h
//  Homework2Group2
//
//  Created by Mark Miller on 9/29/14.
//  Copyright (c) 2014 cpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMHelper : NSObject


+(MMHelper *) getInstance;

+(void)saveStringToUserDefaults:(NSString *)s key:(NSString *)key;
+(NSString *)getStringFromUserDefaults:(NSString *)key;

+(void)writeToFile:(NSString *)data fileName:(NSString *)fileName append:(BOOL)append;
+(NSString *) readFromFile:(NSString *)fileName;

+(void)showAlert:(NSString*)msg title:(NSString*)title;

+(BOOL)fieldIsEmpty:(UITextField*)field;
+(BOOL)stringIsEmpty:(NSString *)string;

+(NSString *)filterTextBySettings:(NSString *)textContent;

//+(Byte *) imageToByteArray:(UIImage *)image;

@end
