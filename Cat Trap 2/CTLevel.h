//
//  CTLevel.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/12/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTGridManager.h"

typedef enum{CTLevelSurival, CTLevelCustom, CTLevelClassic, CTLevelTutorial} CTLevelType;

@interface CTLevel : NSObject 
{
    double version;
    
    NSString *name;
    NSString *data;
    int wavesBetweenIncrease;
    int waveCount;
    int waveInterval;
    int waveIncrementIncrease;
    int firstWaveSize;
    int suggestedTime;
    CTLevelType levelType;
    
    CTBackgroundType bg;
}
@property(nonatomic, retain)NSString *name, *data;
@property(readwrite)int wavesBetweenIncrease, waveCount, waveInterval, waveIncrementIncrease, suggestedTime, firstWaveSize;
@property(readwrite)CTLevelType levelType;
@property(readwrite)double version;
@property(readwrite)CTBackgroundType bg;

+(CTLevel *)survivalLevelForPhase:(int)phase;
+(CTLevel *)tutorial;

-(id)initFromFile:(NSString *)filePath;
-(id)initFromDictionary:(NSDictionary *)levelDictionary;
-(void)writeToFile:(NSString *)filePath;
-(NSDictionary *)getArchivableDictionary;

-(int)getTotalCatsRequired;

@end
