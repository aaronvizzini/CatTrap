//
//  StatisticsMenuLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/26/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "StatisticsMenuLayer.h"

#import "FileHelper.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"

#define kStatFontSize 20.0f

@implementation StatisticsMenuLayer

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        
        int totalCheeseStat = [[settingsDictionary objectForKey:@"TotalCheese"]intValue];
        int totalDeathsStat = [[settingsDictionary objectForKey:@"TotalDeaths"]intValue];
        int totalDistanceStat = [[settingsDictionary objectForKey:@"TotalDistance"]intValue];
        int deathsByTrapStat = [[settingsDictionary objectForKey:@"DeathsByTrap"]intValue];
        int deathsByFireStat = [[settingsDictionary objectForKey:@"DeathsByFire"]intValue];
        int deathsByCatStat = [[settingsDictionary objectForKey:@"DeathsByCat"]intValue];
        int totalTimeStat = [[settingsDictionary objectForKey:@"TotalTime"]intValue];
        
        int hours = (totalTimeStat/60)/60;
        int mins = (totalTimeStat - (hours*60*60))/60;
        int secs = (totalTimeStat - (hours*60*60) - (mins * 60));
        
        title = [CCLabelTTF labelWithString:@"Statistics" fontName:@"WetPaint" fontSize:30.0f];
        title.position = ccp(160,440);
        title.color = ccc3(72, 175, 249);
        [self addChild:title];
        
        totalCheese = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total Cheese: %i", totalCheeseStat] fontName:@"WetPaint" fontSize:kStatFontSize];
        totalCheese.position = ccp(160,400);
        totalCheese.color = ccc3(255, 255, 15);
        [self addChild:totalCheese];
        
        totalDeaths = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total Deaths: %i", totalDeathsStat] fontName:@"WetPaint" fontSize:kStatFontSize];
        totalDeaths.position = ccp(160,370);
        totalDeaths.color = ccc3(255, 255, 15);
        [self addChild:totalDeaths];
        
        totalDistance = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total Distance: %i", totalDistanceStat] fontName:@"WetPaint" fontSize:kStatFontSize];
        totalDistance.position = ccp(160,340);
        totalDistance.color = ccc3(255, 255, 15);
        [self addChild:totalDistance];
        
        deathsByTrap = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Injuries By Traps: %i", deathsByTrapStat] fontName:@"WetPaint" fontSize:kStatFontSize];
        deathsByTrap.position = ccp(160,310);
        deathsByTrap.color = ccc3(255, 255, 15);
        [self addChild:deathsByTrap];
        
        deathsByFire = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Injuries By Fire: %i", deathsByFireStat] fontName:@"WetPaint" fontSize:kStatFontSize];
        deathsByFire.position = ccp(160,280);
        deathsByFire.color = ccc3(255, 255, 15);
        [self addChild:deathsByFire];
        
        deathsByCat = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Injuries By Cat: %i", deathsByCatStat] fontName:@"WetPaint" fontSize:kStatFontSize];
        deathsByCat.position = ccp(160,250);
        deathsByCat.color = ccc3(255, 255, 15);
        [self addChild:deathsByCat];
        
        totalTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total Time: %02D:%02D:%02D", hours, mins, secs] fontName:@"WetPaint" fontSize:kStatFontSize];
        totalTime.position = ccp(160,220);
        totalTime.color = ccc3(255, 255, 15);
        [self addChild:totalTime];
        
        cheesePerMin = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Cheese Per Min: %.2f", (float)(totalCheeseStat/(float)(totalTimeStat/60.0))] fontName:@"WetPaint" fontSize:kStatFontSize];
        cheesePerMin.position = ccp(160,190);
        cheesePerMin.color = ccc3(255, 255, 15);
        [self addChild:cheesePerMin];
        if(totalCheeseStat == 0)[cheesePerMin setString:@"Cheese Per Min: 0"];
        
        distancePerMin = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Distance Per Min: %.2f", (float)(totalDistanceStat/(float)(totalTimeStat/60.0))] fontName:@"WetPaint" fontSize:kStatFontSize];
        distancePerMin.position = ccp(160,160);
        distancePerMin.color = ccc3(255, 255, 15);
        [self addChild:distancePerMin];
        if(totalDistanceStat == 0)[distancePerMin setString:@"Distance Per Min: 0"];
        
        deathsPerMin = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Injuries Per Min: %.2f", (float)(totalDeathsStat/(float)(totalTimeStat/60.0))] fontName:@"WetPaint" fontSize:kStatFontSize];
        deathsPerMin.position = ccp(160,130);
        deathsPerMin.color = ccc3(255, 255, 15);
        [self addChild:deathsPerMin];
        if(totalDeathsStat == 0)[deathsPerMin setString:@"Injuries Per Min: 0"];
        
        menuButton = [CCLabelTTF labelWithString:@"Back" fontName:@"WetPaint" fontSize:28.0f];
        menuButton.position = ccp(278,22);
        [self addChild:menuButton];
        
        resetStatsButton = [CCLabelTTF labelWithString:@"Reset Stats" fontName:@"WetPaint" fontSize:28.0f];
        resetStatsButton.position = ccp(90,22);
        [self addChild:resetStatsButton];
        
        resetAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to reset all statistics?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark Touch Method

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
    CGPoint local1 = [menuButton convertToNodeSpace:touchLocation];
    CGPoint local2 = [resetStatsButton convertToNodeSpace:touchLocation];
    
    CGRect r1 = [menuButton textureRect];
    CGRect r2 = [resetStatsButton textureRect];
    
    if(CGRectContainsPoint(r1, local1))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];      
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(leaveToMenu)];
        [menuButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    if(CGRectContainsPoint(r2, local2))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];      
        [resetAlert show];    
        [resetStatsButton runAction:[CCSequence actions:bounce, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
}

#pragma mark -
#pragma mark Alert View Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self resetStatistics];
    }
}

#pragma mark -
#pragma mark Action Methods

-(void)leaveToMenu
{
    [[CCDirector sharedDirector]replaceScene:[MainMenuScene node]];
}

-(void)resetStatistics
{
    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
    [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"TotalCheese"];
    [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"TotalDeaths"];
    [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"TotalDistance"];
    [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"DeathsByTrap"];
    [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"DeathsByCat"];
    [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"DeathsByFire"];
    [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"TotalTime"];
    [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
    [settingsDictionary release];
    
    totalCheese.string = @"Total Cheese: 0";
    totalDeaths.string  = @"Total Deaths: 0";
    totalDistance.string  = @"Total Distance: 0";    
    deathsByTrap.string  = @"Deaths By Traps: 0";    
    deathsByFire.string  = @"Deaths By Fire: 0";
    deathsByCat.string  = @"Deaths By Cat: 0";    
    totalTime.string  = @"Total Time: 00:00:00";    
    cheesePerMin.string  = @"Cheese Per Min: 0.00";
    distancePerMin.string  = @"Distance Per Min: 0.00";    
    deathsPerMin.string  = @"Deaths Per Min: 0.00";
}

#pragma mark -
#pragma mark Clean Up

-(void)dealloc
{
    [resetAlert release];
    [super dealloc];
}

@end
