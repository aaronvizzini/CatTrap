//
//  GameplayController.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CTLevel;
@class CTGridManager;
@class CTGameDisplayController;
@class CTGameModeManager;
@class CTCheatMenu;

@interface GameplayController : CCLayer <UIAccelerometerDelegate>
{
    CTGridManager *grid;
    CTGameDisplayController *gameDisplayController;
    
    CGPoint touchStartPoint;
    CGPoint touchSingleSwipeStartPoint;
    
    bool wasHeld;
    bool isPaused;
    
    CCSprite *continueButton;
    CCSprite *quitButton;
    CCSprite *restartButton;
    
    CCSprite *pauseIcon;
    
    CTGameModeManager *gameModeManager;
    
    CTCheatMenu *cheatBox;
    
    bool gameDecided;
}
-(void)loadLevel:(CTLevel *)level;

-(void)pauseGame;
-(void)displayOptions;
-(void)hideOptions;

-(void)continueClicked;
-(void)quitClicked;
-(void)restartClicked;

-(void)moveUp;
-(void)moveDown;
-(void)moveRight;
-(void)moveLeft;

-(void)restartGame;

-(void)gameHasBeenWon;
-(void)gameHasBeenLost;

@end
