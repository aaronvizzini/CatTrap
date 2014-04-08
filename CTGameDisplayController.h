//
//  CTGameDisplayController.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/24/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CTLevel;
@class GameplayController;

@interface CTGameDisplayController : CCLayer 
{
    GameplayController *gameplayController;
    
    int gameTimerSecs;
    int gameTimerMins;
    
    int mouseLives;
    int cheeseCount;
    int score;
    
    CCLabelTTF *newScoreLabel;
    CCLabelTTF *cheeseCountLabel;
    CCLabelTTF *scoreLabel;
    
    CCSprite *cheeseIcon;
    
    CCSprite *heart1;
    CCSprite *heart2;
    CCSprite *heart3;
    CCSprite *heart4;
    CCSprite *heart5;
    
    CTLevel *level;
    
    int totalTimeInSeconds;
    
    CCSprite *gameOverTitle;
    CCSprite *gameWinTitle;
    
    bool gameOver;
}
@property (readonly) int gameTimerSecs, gameTimerMins, mouseLives, cheeseCount, score;
@property (nonatomic, retain)CTLevel *level;
@property (readwrite)bool gameOver;
@property (assign) GameplayController *gameplayController;

-(void)loadLevel:(CTLevel *)theLevel;

-(void)timeElapse;
-(void)startTimer;
-(void)pauseTimer;

-(void)setScore:(int)theScore;
-(void)setGameTimer:(int)theGameTimer;
-(void)setMouseLives:(int)theMouseLives;
-(void)setCheeseCount:(int)theCheeseCount wasABloack:(bool)isBlock;

-(void)displayGameOver;
-(void)displayGameWin;

-(void)reset;

-(void)checkForAchievements;

@end
