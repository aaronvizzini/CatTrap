//
//  MainMenuLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/22/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocos2d.h"
#import "SettingsMenuLayer.h"
#import "CTGameCenterManager.h"

@class CTSettingsIcon;
@class CTSurvivalIcon;
@class CTChallengeIcon;
@class CTCreatorIcon;

@interface MainMenuLayer : CCLayer <SettingsMenuDelegate>
{
    CCSprite *catTitle;
    CCSprite *trapTitle;
    CCSprite *twoTitle;
    
    CTSettingsIcon *settingsButton;
    CTSurvivalIcon *survivalButton;
    CTChallengeIcon *challengeButton;
    CTCreatorIcon *creatorButton;
    
    CCSprite *gameCenterIcon;
    CCSprite *gameCenterLeaderIcon;
    
    CTGameCenterManager *gcm;
}

-(void)animateTitle;

-(void)survivalDisplay;
-(void)creatorDisplay;
-(void)challengeDisplay;
-(void)settingsDisplay;
-(void)gameCenterDisplay;

@end
