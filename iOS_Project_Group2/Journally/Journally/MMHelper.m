//
//  SettingsHelper.m
//  Homework2Group2
//
//  Created by Mark Miller on 9/29/14.
//  Copyright (c) 2014 cpl. All rights reserved.
//

#import "MMHelper.h"


MMHelper *helperInstance = nil;

@implementation MMHelper


-(id) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

//singleton constructon
+(MMHelper *) getInstance {
    if(helperInstance == nil)
        helperInstance = [[MMHelper alloc] init];
    
    return helperInstance;
}

//Use these methods to save the current city.. NSUserdefaults are meant for small amounts of data
+(void)saveStringToUserDefaults:(NSString *)s key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:s forKey:key];
    [defaults synchronize];
}

+(NSString *)getStringFromUserDefaults:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:key];
    return str;
}
//--------------------------------

//e.g., filename.txt
-(void)writeToFile:(NSString *)data fileName:(NSString *)fileName append:(BOOL)append {
    NSString *file = [NSString stringWithFormat:@"Documents/%@",fileName];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:file];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:docPath] || !append) {
        //create and write to file
        [data writeToFile:docPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    else {
        //append - (this does not create the file)
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:docPath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

//"(null)" if file does not exist
-(NSString *) readFromFile:(NSString *)fileName {
    NSString *file = [NSString stringWithFormat:@"Documents/%@",fileName];
    
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:file];
    NSString *data = [NSString stringWithContentsOfFile:docPath
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    return data;
}

+(void)showAlert:(NSString*)msg title:(NSString*)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

+(BOOL)fieldIsEmpty:(UITextField*)field {
    return [self stringIsEmpty:[field text]];
}

+(BOOL)stringIsEmpty:(NSString *)string {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [string stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        return YES;
    }
    return NO;
}

//*********************************************
//Call this method before posting a journal entry.
//It will remove words according to the settings
//*********************************************
+(NSString *)filterTextBySettings:(NSString *)textContent {
    NSString *settings = [self getStringFromUserDefaults:@"nameMap"];
    
    if(settings == nil)
        return textContent;
    
    NSArray *pairs = [settings componentsSeparatedByString:@";"];
    if(pairs != nil) {
        //now get an
        for(NSString *nameMap in pairs) {
            NSArray *words = [nameMap componentsSeparatedByString:@","];
            //first word is the real one... second word is the fake one...
            NSString *real = words[0];
            NSString *fake = words[1];
            textContent = [textContent stringByReplacingOccurrencesOfString:real withString:fake];
        }
    }
    
    return textContent;;
}

//+(Byte *) imageToByteArray:(UIImage *)image {
//    NSData *data = UIImagePNGRepresentation(image);
//
//    NSUInteger len = [data length];
//    Byte *byteData = (Byte*)malloc(len);
//    memcpy(byteData, [data bytes], len);
//    return byteData;
//}

@end
