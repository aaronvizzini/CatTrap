//
//  LevelCreatorLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/3/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocos2d.h"
#import "CTGridManager.h"
#import "BackgroundSelectMenu.h"
#import "SaveLevelMenu.h"
#import "CTSprite.h"

@class CTSprite;

@interface LevelCreatorLayer : CCLayer <BackgroundSelectMenuDelegate, SaveLevelMenuDelegate, UIAccelerometerDelegate>
{    
    CTGridItems selectedItemType;
    CTGridItems lastItemType;
    
    NSMutableArray *allItems;
    CTSprite *selectedSprite;
    
    CCSprite *saveButton;
    CCSprite *quitButton;
    CCSprite *restartButton;
    CCSprite *paintBrush;
    
    CCSprite *bg;
    CCSprite *bg2;
    bool discoValue;
    CTBackgroundType currentBg;
    
    BackgroundSelectMenu *bgMenu;
    SaveLevelMenu *saveMenu;
    
    NSString *levelNameCurrentlyEditing;
    
    NSMutableArray *undoStack;
    NSMutableArray *redoStack;
    
    CGPoint touchStartPoint;
}
@property(nonatomic, retain)CTSprite *selectedSprite;

-(void)editLevelWithName:(NSString *)levelName;
-(void)loadString:(NSString *)theString;
-(void)createBackgroundForType:(CTBackgroundType)backgroundType;

-(void)placeSelectedBlock;
-(CGPoint)positionForLocation:(CGPoint)location;
-(CTSprite *)getSpriteForLocation:(CGPoint)location;

-(void)saveClicked;
-(void)quitClicked;
-(void)restartClicked;

-(void)resetCreator;

-(void)undo;
-(void)redo;

@end
