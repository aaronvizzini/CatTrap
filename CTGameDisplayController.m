//
//  CTGameDisplayController.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/24/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTGameDisplayController.h"

#import "FontLabel.h"
#import "CTLevel.h"
#import "FileHelper.h"
#import "CTGameCenterManager.h"
#import "SimpleAudioEngine.h"
#import "CTManager.h"
#import "CTProfile.h"
#import "GameplayController.h"

#define GAME_TIMER_SPEED 1
#define FONT @"WetPaint"
#define FONT_SIZE 32
#define kMaxLevel 48

#define BLOCK_CHEESE_VALUE 50
#define MOUSE_CHEESE_VALUE 100
#define DEATH_SCORE_REDUCTION_PCT .1

@implementation CTGameDisplayController
@synthesize gameTimerSecs, gameTimerMins, mouseLives, cheeseCount, score, level, gameOver, gameplayController;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        newScoreLabel = [[CCLabelTTF alloc]initWithString:@"" dimensions:CGSizeZero alignment:UITextAlignmentLeft fontName:FONT fontSize:FONT_SIZE];
        [newScoreLabel setColor:ccc3(0, 255, 0)];
        newScoreLabel.position = ccp(80,450);
        [newScoreLabel setString:@"00000000"];
        [self addChild:newScoreLabel];
        
        cheeseCountLabel = [[CCLabelTTF alloc]initWithString:@"" dimensions:CGSizeZero alignment:UITextAlignmentLeft fontName:FONT fontSize:FONT_SIZE];
        [cheeseCountLabel setColor:ccc3(255, 255, 15)];
        cheeseCountLabel.position = ccp(270,400);
        [cheeseCountLabel setString:@"000"];
        [self addChild:cheeseCountLabel];
        
        scoreLabel = [[CCLabelTTF alloc]initWithString:@"" dimensions:CGSizeZero alignment:UITextAlignmentLeft fontName:FONT fontSize:FONT_SIZE-4];
        [scoreLabel setColor:ccc3(0, 183, 254)];
        scoreLabel.position = ccp(81,400);
        [scoreLabel setString:@"00000000"];
        [self addChild:scoreLabel];
        
        cheeseIcon = [CCSprite spriteWithFile:@"menuCheese.png"];
        int spacer = (cheeseCountLabel.position.x - (cheeseCountLabel.textureRect.size.width/2));
        cheeseIcon.position = ccp(spacer-20,400);
        [self addChild:cheeseIcon];
        
        heart1 = [CCSprite spriteWithFile:@"heart.png"];
        heart1.position = ccp(175, 452);
        [self addChild:heart1];
        
        heart2 = [CCSprite spriteWithFile:@"heart.png"];
        heart2.position = ccp(205, 452);
        [self addChild:heart2];
        
        heart3 = [CCSprite spriteWithFile:@"heart.png"];
        heart3.position = ccp(235, 452);
        [self addChild:heart3];
        
        heart4 = [CCSprite spriteWithFile:@"heart.png"];
        heart4.position = ccp(265, 452);
        [self addChild:heart4];
        
        heart5 = [CCSprite spriteWithFile:@"heart.png"];
        heart5.position = ccp(295, 452);
        [self addChild:heart5];
        
        self.isTouchEnabled = YES;
        
        self.gameOver = NO;
        
        totalTimeInSeconds = 0;
        
        [self startTimer];
    }
    
    return self;
}

#pragma mark -
#pragma mark gameplay state ui methods

-(void)loadLevel:(CTLevel *)theLevel
{
    self.level = theLevel;
    [self setCheeseCount:0 wasABloack:NO];
    
    if(self.level.levelType == CTLevelCustom)
    {
        [scoreLabel setVisible:NO];
        cheeseCountLabel.position = ccp(160,400);
        int spacer = (cheeseCountLabel.position.x - (cheeseCountLabel.textureRect.size.width/2));
        cheeseIcon.position = ccp(spacer-20,400);
    }
    
    if(self.level.levelType == CTLevelClassic)
    {
        int index = [level.name intValue];
        [scoreLabel setString:[NSString stringWithFormat:@"%08d",[[[[[CTManager sharedInstance]currentProfile]classicScores]objectAtIndex:index-1]intValue]]];
    }
    
    if(self.level.levelType == CTLevelSurival)
    {
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        int survivalScore = [[settings objectForKey:@"SurvivalScore"]intValue];
        [scoreLabel setString:[NSString stringWithFormat:@"%08d",survivalScore]];
    }
}

-(void)timeElapse
{
    [self setGameTimer:self.gameTimerSecs+GAME_TIMER_SPEED];
    totalTimeInSeconds += GAME_TIMER_SPEED;
}

-(void)startTimer
{
    [[CCScheduler sharedScheduler]scheduleSelector:@selector(timeElapse) forTarget:self interval:GAME_TIMER_SPEED paused:NO];
}

-(void)pauseTimer
{
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(timeElapse) forTarget:self];
}

-(void)setScore:(int)theScore
{
    score = theScore;
    [newScoreLabel setString:[NSString stringWithFormat:@"%08d",theScore]];
}
    
-(void)setGameTimer:(int)theGameTimer
{
    gameTimerSecs = theGameTimer;

    if(gameTimerSecs >= 59)
    {
        gameTimerSecs = 0;
        gameTimerMins += 1;
    }
    
    //if(gameTimerMins <= 99)[gameTimerLabel setString:[NSString stringWithFormat:@"%i:%02d",gameTimerMins, gameTimerSecs]];
}

-(void)setMouseLives:(int)theMouseLives
{    
    id scaleOut = [CCScaleTo actionWithDuration:1.0f scale:0.0f];
    id scaleIn = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
    id spin = [CCRotateTo actionWithDuration:1.0f angle:720];
    
    
    if(theMouseLives < mouseLives)
    {
        int newScore = self.score - (self.score * DEATH_SCORE_REDUCTION_PCT);
        [self setScore:newScore];
    }
    
    
    if(theMouseLives == 5)
    {
        if(theMouseLives > mouseLives)
        {
            [heart5 runAction:scaleIn];
            [heart5 runAction:spin];
        }
        
        else
        {
            heart1.scale = 1.0f;
            heart2.scale = 1.0f;
            heart3.scale = 1.0f;
            heart4.scale = 1.0f;
            heart5.scale = 1.0f;
        }
    }
    
    else if(theMouseLives == 4)
    {
        if(theMouseLives > mouseLives)
        {
            [heart4 runAction:scaleIn];
            [heart4 runAction:spin];
        }
        
        else
        {
            [heart5 runAction:scaleOut];
            [heart5 runAction:spin];
        }
    }
    
    else if(theMouseLives == 3)
    {   
        if(theMouseLives > mouseLives)
        {
            [heart3 runAction:scaleIn];
            [heart3 runAction:spin];
        }
        
        else
        {
            [heart4 runAction:scaleOut];
            [heart4 runAction:spin];
        }
    }
    
    else if(theMouseLives == 2)
    {        
        if(theMouseLives > mouseLives)
        {
            [heart2 runAction:scaleIn];
            [heart2 runAction:spin];
        }
        
        else
        {
            [heart3 runAction:scaleOut];
            [heart3 runAction:spin];
        }
    }
    
    else if(theMouseLives == 1)
    {        
        if(theMouseLives > mouseLives)
        {
            [heart1 runAction:scaleIn];
            [heart1 runAction:spin];
        }
        
        else
        {
            [heart2 runAction:scaleOut];
            [heart2 runAction:spin];
        }
    }
    
    else if(theMouseLives == 0)
    {    
        [heart1 runAction:scaleOut];
        [heart1 runAction:spin];
    }

    mouseLives = theMouseLives;
}

-(void)setCheeseCount:(int)theCheeseCount wasABloack:(bool)isBlock
{
    //TO BE Changed//
    if(theCheeseCount > 0)
    {
        if(isBlock)[self setScore:score + BLOCK_CHEESE_VALUE];
        else [self setScore:score + MOUSE_CHEESE_VALUE];
    }
    //
    
    [cheeseIcon runAction:[CCSequence actions:[CCScaleTo actionWithDuration:.25f scale:1.5f],[CCScaleTo actionWithDuration:.25f scale:1.0f],nil]];
    cheeseCount = theCheeseCount;
    
    if(level.levelType != CTLevelSurival)[cheeseCountLabel setString:[NSString stringWithFormat:@"%i/%i",theCheeseCount,[level getTotalCatsRequired]]];
    else [cheeseCountLabel setString:[NSString stringWithFormat:@"%03d",theCheeseCount]];
    
    int spacer = (cheeseCountLabel.position.x - (cheeseCountLabel.textureRect.size.width/2));
    cheeseIcon.position = ccp(spacer-20,400);
}

-(void)displayGameOver
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Game_Over.wav"];
    
    self.gameOver = YES;
    
    [self pauseTimer];
    
    CTGameCenterManager *gcm = [[CTGameCenterManager alloc]init];
    if(self.level.levelType == CTLevelSurival)[gcm submitScore:self.score forLeaderboard:kSurvivalModeLeader displayMessage:YES];
    [gcm release];
    
    if(level.levelType == CTLevelSurival)
    {
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        if(score > [[settings objectForKey:@"SurvivalScore"]intValue])[settings setObject:[NSNumber numberWithInt:score] forKey:@"SurvivalScore"];
        [settings writeToFile:[FileHelper getSettingsPath] atomically:YES];
    }
    
    gameOverTitle = [CCSprite spriteWithFile:@"GameOver.png"];
    gameOverTitle.position = ccp(160, 550);
    [self addChild:gameOverTitle];
    
    id move = [CCMoveTo actionWithDuration:1.0f position:ccp(160,240)];
    
    [gameOverTitle runAction:[CCEaseBounceOut actionWithAction:move]];
    
    [self.gameplayController gameHasBeenLost];
}

-(void)displayGameWin
{        
    [[SimpleAudioEngine sharedEngine] playEffect:@"Game_Win.wav"];
    
    if(self.level.levelType == CTLevelClassic)
    {
        NSMutableString *classicData = [NSMutableString stringWithString:[[[CTManager sharedInstance]currentProfile]classicData]];
        int indexToUpdate = [level.name intValue];
        
        if(score >= [[[[[CTManager sharedInstance]currentProfile]classicScores]objectAtIndex:indexToUpdate-1]intValue])[[[[CTManager sharedInstance]currentProfile]classicScores]replaceObjectAtIndex:indexToUpdate - 1 withObject:[NSNumber numberWithInt:score]];
        
        if(indexToUpdate < kMaxLevel)[classicData replaceCharactersInRange:NSMakeRange(indexToUpdate, 1) withString:@"1"];
        [[[CTManager sharedInstance]currentProfile]setClassicData:classicData];
        [[[CTManager sharedInstance]currentProfile]writeToFile:nil];
    }
    
    
    self.gameOver = YES;
    
    [self pauseTimer];
    
    gameWinTitle = [CCSprite spriteWithFile:@"YouWin.png"];
    gameWinTitle.position = ccp(160, 550);
    [self addChild:gameWinTitle];
    
    id move = [CCMoveTo actionWithDuration:1.0f position:ccp(160,240)];
    
    [gameWinTitle runAction:[CCEaseBounceOut actionWithAction:move]];
    
    [self.gameplayController gameHasBeenWon];
}

#pragma mark -
#pragma mark reset method

-(void)reset
{
    if([gameWinTitle parent] == self)[self removeChild:gameWinTitle cleanup:YES];
    if([gameOverTitle parent] == self)[self removeChild:gameOverTitle cleanup:YES];
    
    if(self.level.levelType != CTLevelCustom)
    {
        NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        [settingsDictionary setObject:[NSNumber numberWithInt:cheeseCount + [[settingsDictionary objectForKey:@"TotalCheese"]intValue]] forKey:@"TotalCheese"];
        [settingsDictionary setObject:[NSNumber numberWithInt:totalTimeInSeconds + [[settingsDictionary objectForKey:@"TotalTime"]intValue]] forKey:@"TotalTime"];
        [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
    }
    
    [self setScore:0];
    [newScoreLabel setString:@"00000000"];
    gameTimerMins = 0;
    gameTimerSecs = 0;
    totalTimeInSeconds = 0;
    [self setMouseLives:5];
    [self setCheeseCount:0 wasABloack:NO];
    self.gameOver = NO;
    
    [self checkForAchievements];
    
    if(self.level.levelType == CTLevelClassic)
    {
        int index = [level.name intValue];
        [scoreLabel setString:[NSString stringWithFormat:@"%08d",[[[[[CTManager sharedInstance]currentProfile]classicScores]objectAtIndex:index-1]intValue]]];
    }
    
    if(self.level.levelType == CTLevelSurival)
    {
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        int survivalScore = [[settings objectForKey:@"SurvivalScore"]intValue];
        [scoreLabel setString:[NSString stringWithFormat:@"%08d",survivalScore]];
    }
}

#pragma mark -
#pragma mark OnExit Method

-(void)onExit
{
    if(self.level.levelType != CTLevelCustom)
    {
        NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        [settingsDictionary setObject:[NSNumber numberWithInt:cheeseCount + [[settingsDictionary objectForKey:@"TotalCheese"]intValue]] forKey:@"TotalCheese"];
        [settingsDictionary setObject:[NSNumber numberWithInt:totalTimeInSeconds + [[settingsDictionary objectForKey:@"TotalTime"]intValue]] forKey:@"TotalTime"];
        [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
    
        CTGameCenterManager *gcm = [[CTGameCenterManager alloc]init];
        [gcm submitScore:[[settingsDictionary objectForKey:@"TotalCheese"]intValue] forLeaderboard:kMostCheeseLeader displayMessage:NO];
        [gcm release];
    }
    
    [self checkForAchievements];
}

#pragma mark -
#pragma mark Achievement Check

-(void)checkForAchievements
{
    if(self.level.levelType != CTLevelCustom)
    {
        NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        CTGameCenterManager *gcm = [[CTGameCenterManager alloc]init];

        int totalCheeseCount = [[settingsDictionary objectForKey:@"TotalCheese"]intValue];
        int totalTime = [[settingsDictionary objectForKey:@"TotalTime"]intValue];
    
        if(totalCheeseCount >= 5)
            [gcm submitAchievementId:kVelveeta fullName:@"Velveeta"];

        if(totalCheeseCount >= 25)
            [gcm submitAchievementId:kCheddar fullName:@"Cheddar"];

        if(totalCheeseCount >= 50)
            [gcm submitAchievementId:kMozzarella fullName:@"Mozzarella"];
           
        if(totalCheeseCount >= 100)
            [gcm submitAchievementId:kProvolone fullName:@"Provolone"];
            
        if(totalCheeseCount >= 500)
            [gcm submitAchievementId:kSwiss fullName:@"Swiss"];
            
        if(totalCheeseCount >= 1000)
            [gcm submitAchievementId:kBrie fullName:@"Brie"];
            
        if(totalCheeseCount >= 2000)
            [gcm submitAchievementId:kLimburger fullName:@"Limburger"];
           
        if(totalCheeseCount >= 5000)
            [gcm submitAchievementId:kGouda fullName:@"Gruda"];
        
        if((float)(totalCheeseCount/(float)totalTime) >= kCheesePerMinRequirement)
            [gcm submitAchievementId:kTimeManagement fullName:@"Time Management"];
             
        [gcm release];
    }
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [level release];
    [newScoreLabel release];
    [cheeseCountLabel release];
    [scoreLabel release];
    [super dealloc];
}

@end
