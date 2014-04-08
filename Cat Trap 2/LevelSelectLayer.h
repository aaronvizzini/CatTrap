//
//  LevelSelectLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/30/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SettingsMenuLayer.h"

@class CTSettingsIcon;

@interface LevelSelectLayer : CCLayer 
{
    CCLabelTTF *labelA;
    CCLabelTTF *labelB;
    CCLabelTTF *labelC;
    CCLabelTTF *labelD;
    CCLabelTTF *labelE;
    CCLabelTTF *labelF;
    CCLabelTTF *labelG;
    CCLabelTTF *labelH;
    CCLabelTTF *labelI;
    CCLabelTTF *labelJ;
    CCLabelTTF *labelK;
    CCLabelTTF *labelL;
    
    int currentPage;
    
    CCSprite *backButton;
    CCSprite *forwardButton;
    
    CTSettingsIcon *settingsButton;
}

-(void)displayLevelsForPage:(int)page;
-(void)selectedLevel:(int)levelNumber;

-(void)viewSettings;
-(void)backButtonAction;
-(void)forwardButtonAction;
-(void)homeButtonAction;
@end
