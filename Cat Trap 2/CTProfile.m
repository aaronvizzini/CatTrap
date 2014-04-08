//
//  CTProfile.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/17/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTProfile.h"
#import "FileHelper.h"

@implementation CTProfile

@synthesize difficulty, name, profileNumber, classicData, isNew, classicScores;

-(id)initFromFile:(NSString *)filePath
{
    if(![[NSFileManager defaultManager]fileExistsAtPath:filePath]) 
    {
        return nil;
    }
    
    NSDictionary *levelDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return [self initFromDictionary:levelDictionary];
}

-(id)initFromDictionary:(NSDictionary *)profileDictionary
{
    self = [super init];
    
    if(self != nil)
    {
        self.name = [profileDictionary objectForKey:@"Name"];
        self.classicData = [profileDictionary objectForKey:@"ClassicMode"];
        self.difficulty = [profileDictionary objectForKey:@"Difficulty"];
        self.profileNumber = [[profileDictionary objectForKey:@"ProfileNumber"]intValue];
        self.isNew = [[profileDictionary objectForKey:@"IsNew"]boolValue];
        self.classicScores = [profileDictionary objectForKey:@"ClassicScores"];
        
    }
    
    return self;
}

-(id)initWithProfileNumber:(int)theProfileNumber name:(NSString *)theName difficulty:(NSString *)theDifficulty
{
    self = [super init];
    
    if(self != nil)
    {
        self.name = theName;
        self.classicData = @"1000000000000000000000000000000000000000000000000";
        self.difficulty = theDifficulty;
        self.profileNumber = theProfileNumber;
        self.isNew = YES;
        
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for(int i = 0; i < 49; i++)[temp addObject:[NSNumber numberWithInt:0]];
        self.classicScores = temp;
        
        [temp release];
    }
    
    return self;
}

-(void)writeToFile:(NSString *)filePath
{
    NSMutableDictionary *profileToCreate = [[NSMutableDictionary alloc]init];
    
    [profileToCreate setObject:name forKey:@"Name"];
    [profileToCreate setObject:self.classicData forKey:@"ClassicMode"];
    [profileToCreate setObject:difficulty forKey:@"Difficulty"];
    [profileToCreate setObject:[NSNumber numberWithInt:self.profileNumber] forKey:@"ProfileNumber"];
    [profileToCreate setObject:[NSNumber numberWithBool:self.isNew] forKey:@"IsNew"];
    [profileToCreate setObject:self.classicScores forKey:@"ClassicScores"];
    
    [profileToCreate writeToFile:[FileHelper getProfilePathByNumber:profileNumber] atomically:YES];
    
    [profileToCreate release];
}

-(NSDictionary *)getArchivableDictionary
{
    NSMutableDictionary *profileToCreate = [[[NSMutableDictionary alloc]init]autorelease];
    
    [profileToCreate setObject:name forKey:@"Name"];
    [profileToCreate setObject:self.classicData forKey:@"ClassicMode"];
    [profileToCreate setObject:difficulty forKey:@"Difficulty"];
    [profileToCreate setObject:[NSNumber numberWithInt:self.profileNumber] forKey:@"ProfileNumber"];
    [profileToCreate setObject:[NSNumber numberWithBool:self.isNew] forKey:@"IsNew"];
    [profileToCreate setObject:self.classicScores forKey:@"ClassicScores"];
    
    [profileToCreate writeToFile:[FileHelper getProfilePathByNumber:profileNumber] atomically:YES];
    
    return profileToCreate;
}

-(void)dealloc
{
    [classicScores release];
    [name release];
    [classicData release];
    [difficulty release];
    [super dealloc];
}

@end
