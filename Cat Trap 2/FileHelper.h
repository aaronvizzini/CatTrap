//
//  FileHelper.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/13/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+(NSString *)getCustomLevelsDirectory;
+(NSString *)getProfilePathByNumber:(int)number;
+(NSString *)getProfilesDirectory;
+(NSString *)getDefaultDirectory;
+(NSString *)getSettingsPath;

@end
