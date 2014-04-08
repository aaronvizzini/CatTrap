//
//  CTGameModeManager.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/28/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTGameModeManager.h"
#import "CTGridManager.h"
#import "CTLevel.h"
#import "CTGameDisplayController.h"
#import "CTCat.h"
#import "GameplayController.h"

#define kWhiteoutTag 476

@implementation CTGameModeManager
@synthesize gridToManage;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) {
        level = nil;
        lastPhaseCount = 0;
        levelType = 0;
        
        gameTimer = 0;
        waveTimer = 0;
        lastWaveSize = 0;
        totalWaves = 1;
        lastWaveIncrease = 0;
        catsRequired = 0; 
        
        tutorialStep = 1;
        tutorialTimer = 0;
        
        directions = [CCLabelTTF labelWithString:@"Welcome! Lets briefly cover some of the basics of Cat Trap 2" dimensions:CGSizeMake(200,200) alignment:CCTextAlignmentCenter lineBreakMode:CCLineBreakModeWordWrap fontName:@"WetPaint" fontSize:24];
        directions.position = ccp(160,220);
    }
    
    return self;
}

#pragma mark -
#pragma mark Level Load Method

-(void)loadWithLevel:(CTLevel *)theLevel
{
    levelType = theLevel.levelType;
    [level release];
    level = [theLevel retain];
    lastWaveSize = level.firstWaveSize;
    catsRequired = lastWaveSize;
    
    if(theLevel.levelType == CTLevelTutorial)
    {
        [self.gridToManage addChild:directions z:5];
    }
}

#pragma mark -
#pragma mark Update Method

-(void) update: (ccTime) dt
{
    gameTimer++;
    waveTimer++;
    
    if(((waveTimer == level.waveInterval && totalWaves < level.waveCount) || ([self.gridToManage.cats count] == 0  && totalWaves < level.waveCount)) && level.levelType != CTLevelTutorial)
    {
        waveTimer = 0;
        totalWaves++;
        lastWaveIncrease++;
        
        if(lastWaveIncrease == level.wavesBetweenIncrease)
        {
            lastWaveSize += level.waveIncrementIncrease;
            lastWaveIncrease = 0;
        }
        
        [self.gridToManage createCatWaveOfSize:lastWaveSize];
        catsRequired+=lastWaveSize;
    }
    
    if (level.levelType == CTLevelSurival) 
    {
        [self survivalCheck];
    }
    
    else if(level.levelType == CTLevelCustom)
    {
        [self customCheck];
    }
    
    else if(level.levelType == CTLevelClassic)
    {
        [self classicCheck];
    }
    
    if(level.levelType == CTLevelTutorial)
    {
        [self tutorialUpdate:dt];
    }
}

#pragma mark -
#pragma mark Update Check Methods

-(void)survivalCheck
{
    int cheeseCount = self.gridToManage.gameDisplayController.cheeseCount;
    phaseToLoad = 0;
    
    if(cheeseCount == 30 && lastPhaseCount != 30)
        phaseToLoad = 2;
    
    if(cheeseCount == 65 && lastPhaseCount != 65)
        phaseToLoad = 3;
    
    if(cheeseCount == 100 && lastPhaseCount != 100)
        phaseToLoad = 4;
    
    if(cheeseCount == 170 && lastPhaseCount != 170)
        phaseToLoad = 5;
    
    if(cheeseCount == 265 && lastPhaseCount != 265)
        phaseToLoad = 6;
        
    if(phaseToLoad != 0)
    {
        [self.gridToManage.gameDisplayController pauseTimer];
        [self.gridToManage pauseGrid];
        
        [self loadWithLevel:[CTLevel survivalLevelForPhase:phaseToLoad]];
        waveTimer = 0;//
        totalWaves = 1;//
        lastWaveIncrease = 0;//
        
        lastPhaseCount = cheeseCount;
        
        //WhiteOut Animation
        CCSprite *whiteOut = [CCSprite spriteWithFile:@"white.png"];
        whiteOut.opacity = 0;
        whiteOut.position = ccp(160,240);
        [self.gridToManage.gameDisplayController addChild:whiteOut z:10 tag:kWhiteoutTag];
        [whiteOut runAction:[CCSequence actions:[CCFadeIn actionWithDuration:.5f], [CCFadeOut actionWithDuration:.5f], nil]];
        //end
        
        [self performSelector:@selector(unpause) withObject:nil afterDelay:.5f];
    }
}

-(void)unpause
{
    [self.gridToManage loadLevel:[CTLevel survivalLevelForPhase:phaseToLoad]];
    [self.gridToManage.gameDisplayController setMouseLives:5];
    [self.gridToManage.gameDisplayController startTimer];
    
    //[self.gridToManage unpauseGrid];
    
    [self performSelector:@selector(removeWhiteOut) withObject:nil afterDelay:.5f];
}

-(void)removeWhiteOut
{
    [self.gridToManage.gameDisplayController removeChildByTag:kWhiteoutTag cleanup:YES];
}

-(void)customCheck
{
    if(totalWaves == level.waveCount && self.gridToManage.gameDisplayController.cheeseCount == catsRequired)
    {
        [self.gridToManage gameWin];
    }
}

-(void)classicCheck
{
    if(totalWaves == level.waveCount && self.gridToManage.gameDisplayController.cheeseCount == catsRequired)
    {
        [self.gridToManage gameWin];
    }
}

-(void)reset
{
    gameTimer = 0;
    waveTimer = 0;
    
    if(levelType != CTLevelSurival)lastWaveSize = level.firstWaveSize;
    else lastWaveSize = 1;//Survival level when reset always has an intial of 1
    
    catsRequired = lastWaveSize;
    totalWaves = 1;
    lastWaveIncrease = 0;
    lastPhaseCount = 0;
    
    if(levelType == CTLevelSurival)
    {
        self.gridToManage.level = [CTLevel survivalLevelForPhase:1];
    }
    
    if(level.levelType == CTLevelTutorial)
    {
        directions.string = @"Welcome! Lets briefly cover some of the basics of Cat Trap 2";
        tutorialStep = 1;
        tutorialTimer = 0;
    }
}

-(void)tutorialUpdate:(ccTime)dt
{
    tutorialTimer++;
    
    if(tutorialStep == 1)
    {
        directions.string = @"Welcome! Lets briefly cover some of the basics of Cat Trap 2";
                
        if(tutorialTimer == 6)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 2)
    {
        directions.string = @"First off, located at top is the game score, health meter, high score, and cheese count.";
        
        if(tutorialTimer == 6)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 3)
    {
        directions.string = @"At the bottom right you can see the pause button.";
        
        if(tutorialTimer == 6)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 4)
    {
        directions.string = @"It is up to you to control the mouse and trap the cats before they catch you.";
        
        if(tutorialTimer == 7)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 5)
    {
        directions.string = @"Simply swipe in the direction you wish to move and push the blocks around. Try it out!";
        
        if(tutorialTimer == 7)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 6)
    {
        directions.string = @"";
        
        if(tutorialTimer == 7)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 7)
    {
        directions.string = @"Cats will chase the mouse, you must surround the cat with blocks and turn it into cheese for the mouse.";
        
        if(tutorialTimer == 0)
        {
            [self.gridToManage createCatWaveOfSize:1];
            [[[self.gridToManage cats]objectAtIndex:0]pauseAI];
        }
        
        if(tutorialTimer == 7)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 8)
    {
        directions.string = @"";
        
        if(tutorialTimer == 0)
        {
            [[[self.gridToManage cats]objectAtIndex:0]startAI];
        }
        
        if([[self.gridToManage cats]count]==0)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 9)
    {
        directions.string = @"Great Job!";
        
        if(tutorialTimer == 3)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 10)
    {
        directions.string = @"Things wont always be this easy, as you progress new twists and obstacles will be introduced.";
        
        if(tutorialTimer == 7)
        {
            tutorialTimer = 0;
            tutorialStep ++;
            directions.string = 0;
        }
    }
    
    if(tutorialStep == 11)
    {
        directions.string = @"You are now ready to begin trapping cats and collecting cheese.";
        [self.gridToManage.gameDisplayController.gameplayController gameHasBeenWon];
    }
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [gridToManage release];
    [level release];
    [super dealloc];
}

@end
