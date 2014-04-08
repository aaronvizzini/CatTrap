//
//  CTProfile.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/17/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTProfile : NSObject
{
    NSString *name;
    NSString *difficulty;
    NSString *classicData;
    NSMutableArray *classicScores;
    int profileNumber;
    bool isNew;
}
@property(nonatomic,retain)NSString *name, *difficulty, *classicData;
@property(nonatomic, retain)NSMutableArray *classicScores;
@property(readwrite) int profileNumber;
@property(readwrite) bool isNew;

-(id)initFromFile:(NSString *)filePath;
-(id)initFromDictionary:(NSDictionary *)profileDictionary;
-(id)initWithProfileNumber:(int)theProfileNumber name:(NSString *)theName difficulty:(NSString *)theDifficulty;

-(void)writeToFile:(NSString *)filePath;
-(NSDictionary *)getArchivableDictionary;

@end
