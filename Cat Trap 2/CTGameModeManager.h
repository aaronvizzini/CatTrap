//
//  CTGameModeManager.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/28/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CTLevel.h"

@class CTGridManager;

@interface CTGameModeManager : NSObject
{
    CTLevel *level;
    
    CTGridManager *gridToManage;
    
    int lastPhaseCount;
    
    CTLevelType levelType;
    
    int gameTimer;
    int waveTimer;
    int lastWaveSize;
    int totalWaves;
    int lastWaveIncrease;
    int catsRequired;
    
    int phaseToLoad;
    
    int tutorialStep;
    int tutorialTimer;
    CCLabelTTF *directions;
}
@property(nonatomic, retain)CTGridManager *gridToManage;

-(void)update: (ccTime) dt;
-(void)loadWithLevel:(CTLevel *)theLevel;

-(void)survivalCheck;
-(void)customCheck;
-(void)classicCheck;
-(void)tutorialUpdate: (ccTime) dt;

-(void)reset;

@end
