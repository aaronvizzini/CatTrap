//
//  CTGridManager.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CCArray;
@class CTSprite;
@class CTMouse;
@class CTPushable;
@class CTLevel;
@class CTGameDisplayController;
@class CTGameModeManager;

#define kGridSize 19
#define kGridBlockSize 16.5
#define kFooterHeaderSize 74
#define kMarginSize 5

typedef enum{CTWoodBackground, CTMetalBackground, CTGrassBackground, CTDiscoBackground}CTBackgroundType;
typedef enum{CTEmptySpace = '0', CTRegularBlockItem = '1', CTSolidBlockItem = '2', CTLeadBlockItem = '3', CTFireBlockItem = '4', CTFishBlockItem = '5', CTMouseTrapItem = '6', CTStickyTrapItem = '7', CTPortalItem = '8', CTDogTriggerItem = '9', CTTNTItem = 'a'} CTGridItems;

@class CTCheese;

@interface CTGridManager : CCLayer 
{
    CTGameModeManager *gameModeManager;
    
    CCSprite *bg;
    CCSprite *bg2;
    bool discoValue;

    CTLevel *level;
    
    CGPoint mousePoint;
    CCArray *pushables;
    CCArray *cats;
    CCArray *elements;
    CCArray *cheese;
    
    CTMouse *mouse;
    
    int size;
    double blockSize;
    
    CTGameDisplayController *gameDisplayController;
    
    int wavesRequired;
    int catsRequired;
}
@property(readonly)CGPoint mousePoint;
@property(readonly)CCArray *cats, *pushables, *elements, *cheese;
@property(readonly)CTMouse *mouse;
@property(readonly)int size;
@property(readonly)double blockSize;
@property(assign)CTGameDisplayController *gameDisplayController;
@property(nonatomic,retain)CTLevel *level;
@property(nonatomic, retain)CTGameModeManager *gameModeManager;

-(void)loadLevel:(CTLevel *)theLevel;
-(void)createBackgroundForType:(CTBackgroundType)backgroundType;
-(void)loadString:(NSString *)theString;

-(void)pauseGrid;
-(void)unpauseGrid;
-(void)reset;

-(bool)isLocationOccupied:(CGPoint)location;
-(CTPushable *)getPushableForLocation:(CGPoint)location;
-(CGPoint)positionForLocation:(CGPoint)location;

-(void)createCatWaveOfSize:(int)waveSize;

-(void)addCheese:(CTCheese *)theCheese;
-(void)collectedCheese:(CTCheese *)theCheese;
-(void)blockCollectedCheese:(CTCheese *)theCheese;

-(CGPoint)getRandomEmptyLocation;

-(void)gameOver;

-(void)gameWin;

@end
