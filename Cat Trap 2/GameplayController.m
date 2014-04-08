//
//  GameplayController.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "GameplayController.h"

#import "CTMouse.h"
#import "CTLevel.h"
#import "CTGridManager.h"
#import "CTGameDisplayController.h"
#import "MainMenuScene.h"
#import "SpriteRect.h"
#import "CTGameModeManager.h"
#import "SimpleAudioEngine.h"
#import "CustomLevelMenuScene.h"
#import "LevelSelectScene.h"
#import "CTManager.h"
#import "CTCheatMenu.h"
#import "GameplayControllerScene.h"

#define kSwipeDistance 45
#define kSwipeMarginOfError 75
#define kHoldMoveDelay .15

@implementation GameplayController

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self)
    {
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
        gameModeManager = [[CTGameModeManager alloc]init];
        
        touchStartPoint = CGPointZero;
        touchSingleSwipeStartPoint = CGPointZero;
        
        [self setIsTouchEnabled:YES];
        
        grid = [[CTGridManager alloc]init];
        grid.position = ccp(0,-23);
        grid.gameModeManager = gameModeManager;
        gameModeManager.gridToManage = grid;
        [self addChild:grid];
                
        gameDisplayController = [[CTGameDisplayController alloc]init];
        gameDisplayController.gameplayController = self;
        grid.gameDisplayController = gameDisplayController;
        [self addChild:gameDisplayController];
        
        wasHeld = NO;
        
        isPaused = NO;
        
        continueButton = [CCSprite spriteWithFile:@"continueButton.png"];
        continueButton.position = ccp(63,28);
        continueButton.scale = .0f;
        
        quitButton = [CCSprite spriteWithFile:@"quitButton.png"];
        quitButton.position = ccp(20,28);
        quitButton.scale = .0f;
        
        restartButton = [CCSprite spriteWithFile:@"restartButton.png"];
        restartButton.position = ccp(110,28);
        restartButton.scale = .0f;
        
        [self addChild:quitButton];
        [self addChild:continueButton];
        [self addChild:restartButton];

        pauseIcon = [CCSprite spriteWithFile:@"Pause.png"];
        pauseIcon.position = ccp(160,215);
        [pauseIcon setOpacity:0.0f];
        [self addChild:pauseIcon];
        
        cheatBox = [CTCheatMenu node];
        cheatBox.grid = grid;
        [self addChild:cheatBox];
        
        gameDecided = NO;
    }
    
    return self;
}

-(void)loadLevel:(CTLevel *)level
{
    [grid loadLevel:level];
    [gameDisplayController loadLevel:level];  
    [gameModeManager loadWithLevel:level];
}

#pragma mark -
#pragma mark touch methods 
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    touchStartPoint = point;
    touchSingleSwipeStartPoint = point;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y < touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];

        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveUp) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveUp) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
    
    else if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y > touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];

        
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveDown) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveDown) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x > touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];

        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveRight) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveRight) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x < touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
        
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveLeft) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveLeft) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
    
    if(abs(point.y - touchSingleSwipeStartPoint.y) >= kSwipeDistance && point.y < touchSingleSwipeStartPoint.y && abs(point.x - touchSingleSwipeStartPoint.x) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveUp];
    }
    
    else if(abs(point.y - touchSingleSwipeStartPoint.y) >= kSwipeDistance && point.y > touchSingleSwipeStartPoint.y && abs(point.x - touchSingleSwipeStartPoint.x) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveDown];
    }
    
    else if(abs(point.x - touchSingleSwipeStartPoint.x) >= kSwipeDistance && point.x > touchSingleSwipeStartPoint.x && abs(point.y - touchSingleSwipeStartPoint.y) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveRight];
    }
    
    else if(abs(point.x - touchSingleSwipeStartPoint.x) >= kSwipeDistance && point.x < touchSingleSwipeStartPoint.x && abs(point.y - touchSingleSwipeStartPoint.y) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveLeft];
    }
    
    wasHeld = NO;
    
    if(point.x >= 275 && point.y >= 430 && ((!isPaused && gameDisplayController.gameOver) || (!isPaused && !gameDisplayController.gameOver) || (isPaused &&  !gameDisplayController.gameOver)))
    {
        if(touchSingleSwipeStartPoint.x >= 275 && touchSingleSwipeStartPoint.y >= 430)
        {
            [self pauseGame];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        }
    }
    
    CGPoint convertedPoint = [self convertTouchToNodeSpace:[touches anyObject]];        
    CGRect continueRect = [self rectForSprite:continueButton];
    CGRect quitRect = [self rectForSprite:quitButton];
    CGRect restartRect = [self rectForSprite:restartButton];
    
    if(CGRectContainsPoint(continueRect,convertedPoint) && ((isPaused && !gameDisplayController.gameOver) || gameDecided))
    {
        [self continueClicked];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(quitRect,convertedPoint) && (isPaused || gameDecided))
    {
        [self quitClicked];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(restartRect, convertedPoint) && (isPaused || gameDecided))
    {
        [self restartClicked];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
}

#pragma mark -
#pragma mark button methods

-(void)continueClicked
{    
    id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
    [continueButton runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(continueOn)], nil]];
    
    if(gameDisplayController.level.levelType == CTLevelCustom && gameDisplayController.gameOver)
    {
        [[CCDirector sharedDirector]replaceScene:[MainMenuScene node]];
    }
    
    else if([[CTManager sharedInstance]currentProfile]==nil && gameDisplayController.level.levelType == CTLevelTutorial)
    {
        GameplayControllerScene *gameplayController = [GameplayControllerScene node];
        [gameplayController loadLevel:[CTLevel survivalLevelForPhase:1]]; 
        [[CCDirector sharedDirector] replaceScene:gameplayController];
 
    }
    
    else if((gameDisplayController.gameOver && gameDisplayController.level.levelType == CTLevelClassic) || gameDisplayController.level.levelType == CTLevelTutorial)
    {
        int levelToLoad = [gameDisplayController.level.name intValue]+1;
        if(gameDisplayController.level.levelType == CTLevelSurival) levelToLoad = 1;
        
        if(levelToLoad <= 48)
        {
            CTLevel *levelSelected = [[CTLevel alloc]initFromFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat: @"%i",levelToLoad] ofType:@""]];
            GameplayControllerScene *gameplayScene = [GameplayControllerScene node];
            [gameplayScene loadLevel:levelSelected];
            [[CCDirector sharedDirector] replaceScene:gameplayScene];
            [levelSelected release];
        }
        
        else [[CCDirector sharedDirector] replaceScene:[LevelSelectScene node]];
    }
}

-(void)continueOn
{
    [self pauseGame];
}

-(void)quitClicked
{    
    id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
    [quitButton runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(quit)], nil]];
}

-(void)quit
{
    if(gameDisplayController.level.levelType == CTLevelSurival)[[CCDirector sharedDirector] replaceScene:[MainMenuScene node]];
    
    else if(gameDisplayController.level.levelType == CTLevelCustom)[[CCDirector sharedDirector] replaceScene:[CustomLevelMenuScene node]];
    
    else if(gameDisplayController.level.levelType == CTLevelClassic)[[CCDirector sharedDirector] replaceScene:[LevelSelectScene node]];
    
    else if(gameDisplayController.level.levelType == CTLevelTutorial && [[CTManager sharedInstance]currentProfile]==nil)
    {
        GameplayControllerScene *gameplayController = [GameplayControllerScene node];
        [gameplayController loadLevel:[CTLevel survivalLevelForPhase:1]]; 
        [[CCDirector sharedDirector] replaceScene:gameplayController];
    }
    
    else
    {
        [[CCDirector sharedDirector] replaceScene:[LevelSelectScene node]];
    }
}

-(void)restartClicked
{
    id spinAction = [CCRotateBy actionWithDuration:.5f angle:720];
    id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(restartGame)];
    [restartButton runAction:[CCSequence actions:spinAction, callFunc, nil]];
}


-(void)displayOptions
{
    id quitButtonAction = [CCScaleTo actionWithDuration:.6f scale:1.0f];
    id continueButtonAction = [CCScaleTo actionWithDuration:.8f scale:1.0f];
    id restartButtonAction = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
    
    id bounce1 = [CCEaseBounceOut actionWithAction:quitButtonAction];
    id bounce2 = [CCEaseBounceOut actionWithAction:continueButtonAction];
    id bounce3 = [CCEaseBounceOut actionWithAction:restartButtonAction];
    
    [quitButton runAction:bounce1];
    if(!gameDisplayController.gameOver)[continueButton runAction:bounce2];
    [restartButton runAction:bounce3];
}

-(void)hideOptions
{
    id quitButtonAction = [CCScaleTo actionWithDuration:.3f scale:.0f];
    id continueButtonAction = [CCScaleTo actionWithDuration:.3f scale:.0f];
    id restartButtonAction = [CCScaleTo actionWithDuration:.3f scale:.0f];
    
    [quitButton runAction:quitButtonAction];
    [continueButton runAction:continueButtonAction];
    [restartButton runAction:restartButtonAction];
}

#pragma mark -
#pragma mark game state control methods
-(void)pauseGame
{
    if(!isPaused)
    {
        id fade = [CCFadeIn actionWithDuration:.5f];
        [pauseIcon runAction:fade];
        
        [self displayOptions];
        [grid pauseGrid];
        [gameDisplayController pauseTimer];
    }
    
    else
    {
        id fade = [CCFadeOut actionWithDuration:.5f];
        [pauseIcon runAction:fade];
        
        [self hideOptions];
        [grid unpauseGrid];
        [gameDisplayController startTimer];
    }
    
    isPaused = !isPaused;
}

#pragma mark -
#pragma mark gameplay control methods 

-(void)moveUp
{
    wasHeld = YES;
    [grid.mouse move:CTNorth];
}

-(void)moveDown
{
    wasHeld = YES;
    [grid.mouse move:CTSouth];
}

-(void)moveRight
{
    wasHeld = YES;
    [grid.mouse move:CTEast];
}

-(void)moveLeft
{
    wasHeld = YES;
    [grid.mouse move:CTWest];
}

#pragma mark -
#pragma mark restart method

-(void)restartGame
{
    if(isPaused)[self pauseGame];
    [self hideOptions];
    [gameModeManager reset];
    [gameDisplayController reset];
    [grid reset];
}

#pragma mark -
#pragma mark Game  Win/Loose methods

-(void)gameHasBeenWon
{
    id quitButtonAction = [CCScaleTo actionWithDuration:.6f scale:1.0f];
    id continueButtonAction = [CCScaleTo actionWithDuration:.8f scale:1.0f];
    id restartButtonAction = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
    
    id bounce1 = [CCEaseBounceOut actionWithAction:quitButtonAction];
    id bounce2 = [CCEaseBounceOut actionWithAction:continueButtonAction];
    id bounce3 = [CCEaseBounceOut actionWithAction:restartButtonAction];
    
    [quitButton runAction:bounce1];
    [continueButton runAction:bounce2];
    [restartButton runAction:bounce3];
    
    gameDecided = YES;
}

-(void)gameHasBeenLost
{
    id quitButtonAction = [CCScaleTo actionWithDuration:.6f scale:1.0f];
    id restartButtonAction = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
    
    id bounce1 = [CCEaseBounceOut actionWithAction:quitButtonAction];
    id bounce3 = [CCEaseBounceOut actionWithAction:restartButtonAction];
    
    [quitButton runAction:bounce1];
    [restartButton runAction:bounce3];
    
    gameDecided = YES;
}

#pragma mark -
#pragma makr Accelerometer Methods

#define kShakeCheat 1.5f

-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
 	if(acceleration.x > kShakeCheat && grid.level.levelType != CTLevelSurival)
    {
        [cheatBox show];
    }
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [gameDisplayController release];
    [grid release];
    [gameModeManager release];
    [super dealloc];
}

@end
