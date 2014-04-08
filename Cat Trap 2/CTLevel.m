//
//  CTLevel.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/12/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTLevel.h"

#define kLevelVersion 1.0

@implementation CTLevel
@synthesize name, data, wavesBetweenIncrease, waveCount, waveInterval, waveIncrementIncrease, suggestedTime, firstWaveSize, bg, version, levelType;

#pragma mark -
#pragma mark Init Method

-(id)initFromFile:(NSString *)filePath
{
    NSDictionary *levelDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
            
    return [self initFromDictionary:levelDictionary];
}

-(id)initFromDictionary:(NSDictionary *)levelDictionary
{
    self = [super init];
    
    if(self != nil)
    {
        self.name = [levelDictionary objectForKey:@"Name"];
        self.data = [levelDictionary objectForKey:@"Data"];
        self.levelType = [[levelDictionary objectForKey:@"LevelType"]intValue];
        self.wavesBetweenIncrease = [[levelDictionary objectForKey:@"WavesBetweenIncrease"]intValue];
        self.waveCount = [[levelDictionary objectForKey:@"WaveCount"]intValue];
        self.waveInterval = [[levelDictionary objectForKey:@"WaveInterval"]intValue];
        self.waveIncrementIncrease = [[levelDictionary objectForKey:@"WaveIncrementIncrease"]intValue];
        self.suggestedTime = [[levelDictionary objectForKey:@"SuggestedTime"]intValue];
        self.firstWaveSize = [[levelDictionary objectForKey:@"FirstWaveSize"]intValue];
        self.bg = [[levelDictionary objectForKey:@"Background"]intValue];//
        self.version = [[levelDictionary objectForKey:@"Version"]doubleValue];
    }
    
    return self;
}

#pragma mark -
#pragma mark File Writing Method

-(void)writeToFile:(NSString *)filePath
{
    NSMutableDictionary *levelDictionary = [[NSMutableDictionary alloc]init];
    
    if([self.name hasPrefix:@"c04_"])self.name = @"My Custom Level";
    
    [levelDictionary setObject:self.name forKey:@"Name"];
    [levelDictionary setObject:self.data forKey:@"Data"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.levelType] forKey:@"LevelType"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.wavesBetweenIncrease] forKey:@"WavesBetweenIncrease"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.waveCount] forKey:@"WaveCount"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.waveInterval] forKey:@"WaveInterval"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.waveIncrementIncrease] forKey:@"WaveIncrementIncrease"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.suggestedTime] forKey:@"SuggestedTime"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.firstWaveSize] forKey:@"FirstWaveSize"];
    [levelDictionary setObject:[NSNumber numberWithDouble:kLevelVersion] forKey:@"Version"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.bg] forKey:@"Background"];
    
    [levelDictionary writeToFile:filePath atomically:YES];
    
    [levelDictionary release];
}

#pragma mark -
#pragma mark Archiving Convience methods

-(NSDictionary *)getArchivableDictionary
{
    NSMutableDictionary *levelDictionary = [[[NSMutableDictionary alloc]init]autorelease];
    
    [levelDictionary setObject:self.name forKey:@"Name"];
    [levelDictionary setObject:self.data forKey:@"Data"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.levelType] forKey:@"LevelType"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.wavesBetweenIncrease] forKey:@"WavesBetweenIncrease"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.waveCount] forKey:@"WaveCount"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.waveInterval] forKey:@"WaveInterval"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.waveIncrementIncrease] forKey:@"WaveIncrementIncrease"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.suggestedTime] forKey:@"SuggestedTime"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.firstWaveSize] forKey:@"FirstWaveSize"];
    [levelDictionary setObject:[NSNumber numberWithDouble:kLevelVersion] forKey:@"Version"];
    [levelDictionary setObject:[NSNumber numberWithInt:self.bg] forKey:@"Background"];
    
    return levelDictionary;
}

#pragma mark -
#pragma mark Convient Level Creation Methods

+(CTLevel *)survivalLevelForPhase:(int)phase
{
    CTLevel *survival = [[[CTLevel alloc]init]autorelease];
    survival.name = @"Survival";

    if(phase == 1)//30
    {
        survival.data = @"0000000000000000000000000000000000000000000000000000000000001111111111111000000111111111111100000011111111111110000001111111111111000000111111111111100000011111111111110000001111110111111000000111111111111100000011111111111110000001111111111111000000111111111111100000011111111111110000001111111111111000000000000000000000000000000000000000000000000000000000000";
        survival.wavesBetweenIncrease = 10;
        survival.waveCount = 20;
        survival.waveIncrementIncrease = 1;
        survival.suggestedTime = -1;
        survival.firstWaveSize = 1;
    }
    
    else if(phase == 2)//35 = 65
    {
        survival.data = @"0000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111000000001111111111100000000111111111110000000011111111111000000001111111111100000000111110111110000000011111111111000000001111111111100000000111111111110000000011111111111000000001111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000";
        survival.wavesBetweenIncrease = 10;
        survival.waveCount = 15;
        survival.waveIncrementIncrease = 1;
        survival.suggestedTime = -1;
        survival.firstWaveSize = 2;    }
    
    else if(phase == 3)//35 = 100
    {
        survival.data = @"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111000000000011111111100000000001111111110000000000111111111000000000011110111100000000001111111110000000000111111111000000000011111111100000000001111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        survival.wavesBetweenIncrease = 10;
        survival.waveCount = 15;
        survival.waveIncrementIncrease = 1;
        survival.suggestedTime = -1;
        survival.firstWaveSize = 2;
    }
    
    else if(phase == 4)//70 = 170
    {
        survival.data = @"0000000000000000000000000000000000000000000000000000000000001111111111111000000111111111111100000011111111111110000001111111111111000000111111111111100000011111111111110000001111110111111000000111111111111100000011111111111110000001111111111111000000111111111111100000011111111111110000001111111111111000000000000000000000000000000000000000000000000000000000000";
        survival.wavesBetweenIncrease = 10;
        survival.waveCount = 25;
        survival.waveIncrementIncrease = 1;
        survival.suggestedTime = -1;
        survival.firstWaveSize = 2;
    }
    
    else if(phase == 5)//95 = 265
    {
        survival.data = @"0000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111000000001111111111100000000111111111110000000011111111111000000001111111111100000000111110111110000000011111111111000000001111111111100000000111111111110000000011111111111000000001111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000";
        survival.wavesBetweenIncrease = 10;
        survival.waveCount = 25;
        survival.waveIncrementIncrease = 1;
        survival.suggestedTime = -1;
        survival.firstWaveSize = 3;    
    }
    
    else if(phase == 6)//120 = 385
    {
        survival.data = @"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111000000000011111111100000000001111111110000000000111111111000000000011110111100000000001111111110000000000111111111000000000011111111100000000001111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        survival.wavesBetweenIncrease = 10;
        survival.waveCount = 30;//30 40 50
        survival.waveIncrementIncrease = 1;
        survival.suggestedTime = -1;
        survival.firstWaveSize = 3;
    }
    
    
    survival.bg = CTWoodBackground;
    survival.levelType = CTLevelSurival;
    
    return survival;
}

+(CTLevel *)tutorial
{
    CTLevel *tutorial = [[[CTLevel alloc]init]autorelease];
    tutorial.name = @"Tutorial";
    
    tutorial.data = @"0000000000000000000000000000000000000000000000000000000000001111111111111000000111111111111100000011111111111110000001111111111111000000111111111111100000011111111111110000001111110111111000000111111111111100000011111111111110000001111111111111000000111111111111100000011111111111110000001111111111111000000000000000000000000000000000000000000000000000000000000";
    tutorial.wavesBetweenIncrease = 0;
    tutorial.waveCount = 0;
    tutorial.waveIncrementIncrease = 0;
    tutorial.suggestedTime = 0;
    tutorial.firstWaveSize = 0;
    
    tutorial.bg = CTWoodBackground;
    tutorial.levelType = CTLevelTutorial;
    
    return tutorial;
}

#pragma mark -
#pragma mark Utility Method

-(int)getTotalCatsRequired
{    
    int currentWaveSizeSim = self.firstWaveSize;
    int totalCheeseSim = 0;
    int waveCountSim = 0;
    
    for(int i = 0; i < self.waveCount; i++)
    {
        waveCountSim++;
        
        totalCheeseSim += currentWaveSizeSim;
        
        if(waveCountSim == self.wavesBetweenIncrease)
        {
            currentWaveSizeSim += self.waveIncrementIncrease;
            waveCountSim = 0;
        }
    }
    
    return totalCheeseSim;
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [name release];
    [data release];
    [super dealloc];
}

@end
