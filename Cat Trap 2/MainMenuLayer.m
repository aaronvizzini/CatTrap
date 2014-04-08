//
//  MainMenuLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/22/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "MainMenuLayer.h"

#import "CTSettingsIcon.h"
#import "CTSurvivalIcon.h"
#import "CTChallengeIcon.h"
#import "CTCreatorIcon.h"
#import "GameplayControllerScene.h"
#import "ProfileMenuScene.h"
#import "CustomLevelMenuScene.h"
#import "CTLevel.h"
#import "StatisticsMenuScene.h"
#import "SimpleAudioEngine.h"
#import "FileHelper.h"

#define kSettingsMenuTag 1

@implementation MainMenuLayer

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.isTouchEnabled = YES;
        
        gcm = [[CTGameCenterManager alloc]init];
        
        catTitle = [CCSprite spriteWithFile:@"catTitle.png"];
        catTitle.position = ccp(76,550);
        [self addChild:catTitle];
        
        trapTitle = [CCSprite spriteWithFile:@"trapTitle.png"];
        trapTitle.position = ccp(222,550);
        [self addChild:trapTitle];

        twoTitle = [CCSprite spriteWithFile:@"twoTitle.png"];
        twoTitle.position = ccp(140,520);
        
        settingsButton = [CTSettingsIcon node];
        settingsButton.position = ccp(160,0);
        [self addChild: settingsButton];
        [settingsButton setTarget:self andSelector:@selector(settingsDisplay)];
        
        survivalButton = [CTSurvivalIcon node];
        survivalButton.position = ccp(190,95);
        [self addChild:survivalButton];
        [survivalButton setTarget:self andSelector:@selector(survivalDisplay)];
        
        challengeButton = [CTChallengeIcon node];
        challengeButton.position = ccp(110,225);
        [self addChild:challengeButton];
        [challengeButton setTarget:self andSelector:@selector(challengeDisplay)];
        
        creatorButton = [CTCreatorIcon node];
        creatorButton.position = ccp(50,103);
        [self addChild:creatorButton];
        [creatorButton setTarget:self andSelector:@selector(creatorDisplay)];

        [self performSelector:@selector(animateTitle) withObject:nil afterDelay:.5f];
        
        gameCenterIcon = [CCSprite spriteWithFile:@"gameCenterIcon.png"];
        gameCenterIcon.position = ccp(280,40);
        [self addChild:gameCenterIcon];
        
        gameCenterLeaderIcon = [CCSprite spriteWithFile:@"leaderboardIcon.png"];
        gameCenterLeaderIcon.position = ccp(40,70);
        gameCenterLeaderIcon.anchorPoint = ccp(.5,1);
        [self addChild:gameCenterLeaderIcon];
    }
    
    return self;
}

-(void)onEnter
{
    [super onEnter];
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
	CGPoint local1 = [gameCenterIcon convertToNodeSpace:touchLocation];
	CGRect r1 = [gameCenterIcon textureRect];
    
    CGPoint local2 = [gameCenterLeaderIcon convertToNodeSpace:touchLocation];
	CGRect r2 = [gameCenterLeaderIcon textureRect];
    
    if(CGRectContainsPoint(r1, local1))
    {
        id anim1 = [CCRotateTo actionWithDuration:.2f angle:25.0f];
        id anim2 = [CCRotateTo actionWithDuration:.2f angle:-25.0f];
        id repeat1 = [CCRepeat actionWithAction:[CCSequence actions:anim1, anim2, nil] times:2];
        id returnAnim = [CCRotateTo actionWithDuration:.2f angle:0];
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(gameCenterDisplay)];
        [gameCenterIcon runAction:[CCSequence actions:repeat1, returnAnim, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Game_Center.wav"];
    }
    
    if(CGRectContainsPoint(r2, local2))
    {
        id anim1 = [CCRotateTo actionWithDuration:.2f angle:25.0f];
        id anim2 = [CCRotateTo actionWithDuration:.2f angle:-25.0f];
        id repeat1 = [CCRepeat actionWithAction:[CCSequence actions:anim1, anim2, nil] times:2];
        id returnAnim = [CCRotateTo actionWithDuration:.2f angle:0];
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(gameCenterLeaderboardDisplay)];
        [gameCenterLeaderIcon runAction:[CCSequence actions:repeat1, returnAnim, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Game_Center.wav"];
    }
}

#pragma mark -
#pragma mark navigation methods

-(void)survivalDisplay
{
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
    bool isNew = [[settings objectForKey:@"IsNew"]boolValue];
    
    GameplayControllerScene *gameplayController = [GameplayControllerScene node];

    if(isNew) [gameplayController loadLevel:[CTLevel tutorial]];     
    else [gameplayController loadLevel:[CTLevel survivalLevelForPhase:1]]; 
    
    [settings setObject:[NSNumber numberWithBool:NO] forKey:@"IsNew"];
    [settings writeToFile:[FileHelper getSettingsPath] atomically:YES];
    
    [[CCDirector sharedDirector] replaceScene:gameplayController];
}

-(void)creatorDisplay
{
    [[CCDirector sharedDirector] replaceScene:[CustomLevelMenuScene node]];
}

-(void)challengeDisplay
{
    [[CCDirector sharedDirector] replaceScene:[ProfileMenuScene node]];
}

-(void)settingsDisplay
{    
    self.isTouchEnabled = NO;
    settingsButton.isTouchEnabled = NO;
    survivalButton.isTouchEnabled = NO;
    challengeButton.isTouchEnabled = NO;
    creatorButton.isTouchEnabled = NO;

    SettingsMenuLayer *settings = [SettingsMenuLayer node];
    [settings setDelegate:self];
    [self addChild:settings z:5 tag:kSettingsMenuTag];
    [settings show];
}

-(void)gameCenterDisplay
{
    //[gcm reloadHighScoresForCategory:kSurvivalModeLeader];
    //[gcm showLeaderBoardWithId:kSurvivalModeLeader];
    [gcm showAchievments];
}

-(void)gameCenterLeaderboardDisplay
{
    //[gcm reloadHighScoresForCategory:kSurvivalModeLeader];
    [gcm showLeaderBoardWithId:kSurvivalModeLeader];
}

#pragma mark -
#pragma mark animation method

-(void)animateTitle
{
    id catTitleAnim = [CCMoveTo actionWithDuration:1.0f position:ccp(76,435)];
    id action = [CCEaseBounceOut actionWithAction:catTitleAnim];
    id trapTitleAnim = [CCMoveTo actionWithDuration:1.2f position:ccp(222,435)];
    id action2 = [CCEaseBounceOut actionWithAction:trapTitleAnim];
    
    [catTitle runAction:action];
    [trapTitle runAction:action2];
}

#pragma mark -
#pragma mark Settings Menu Delegate

-(void)settingsMenuWillClose
{
    [self removeChildByTag:kSettingsMenuTag cleanup:YES];
    [settingsButton reset];
    self.isTouchEnabled = YES;
    settingsButton.isTouchEnabled = YES;
    survivalButton.isTouchEnabled = YES;
    challengeButton.isTouchEnabled = YES;
    creatorButton.isTouchEnabled = YES;
}

#pragma mark -
#pragma mark clean up


-(void)dealloc
{
    [gcm release];
    [super dealloc];
}

@end
