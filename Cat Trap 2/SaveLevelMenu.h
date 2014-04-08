//
//  SaveLevelMenu.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/10/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "CTGridManager.h"

@class CTLevel;

@protocol SaveLevelMenuDelegate <NSObject>

-(NSMutableArray *)getAllElements;
-(CTBackgroundType)getBackground;
-(NSString *)getLevelString;
-(void)didSave;
-(void)didCancel;

@end

@interface SaveLevelMenu : CCLayer <UITextFieldDelegate>
{
    UITextField *levelName;
    UITextField *wavesBetweenIncreases;
    UITextField *totalNumberOfWaves;
    UITextField *firstWaveSize;
    UITextField *waveIntervals;
    UITextField *waveIncrementIncrease;
    
    CCLabelTTF *levelNameLabel;
    CCLabelTTF *wavesBetweenIncreasesLabel;
    CCLabelTTF *totalWavesLabel;
    CCLabelTTF *waveIntervalLabel;
    CCLabelTTF *waveIncrementLabel;
    CCLabelTTF *firstWaveSizeLabel;
    
    CCSprite *saveButton;
    CCSprite *quitButton;
    
    id delegate;
}
@property(assign)id <SaveLevelMenuDelegate> delegate;

-(void)setLevelToLoadWith:(NSString *)theLevelName;

-(void)show;
-(void)hide;
-(void)save;
-(void)close;

-(void)showUI;
-(void)hideUI;

@end
