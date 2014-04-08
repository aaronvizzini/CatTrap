//
//  FileHelper.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/13/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

#pragma mark -
#pragma mark File Path Helpers

+(NSString *)getSettingsPath
{
    return [[self getDefaultDirectory] stringByAppendingPathComponent:@"UserSettings"];
}

+(NSString *)getProfilePathByNumber:(int)number
{
    return [[self getProfilesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"Profile%i",number]];
}

+(NSString *)getProfilesDirectory
{
    NSString *documentsDirectory = [self getDefaultDirectory];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Profiles"]] isDirectory:nil])[fm createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]] withIntermediateDirectories:NO attributes:nil error:nil];
    
    return [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
}

+(NSString *)getCustomLevelsDirectory
{
    NSString *documentsDirectory = [self getDefaultDirectory];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"CustomLevels"]] isDirectory:nil])[fm createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]] withIntermediateDirectories:NO attributes:nil error:nil];

    return [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
}

+(NSString *)getDefaultDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

@end
