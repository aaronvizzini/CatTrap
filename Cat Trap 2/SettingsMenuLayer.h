//
//  SettingsMenuLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/20/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "cocos2d.h"

@protocol SettingsMenuDelegate <NSObject>

-(void)settingsMenuWillClose;

@end

@interface SettingsMenuLayer : CCLayer <MPMediaPickerControllerDelegate, UIAlertViewDelegate>
{
	MPMediaPickerController *controller;
	MPMusicPlayerController *myPlayer;
    
    CCLabelTTF *audioSettingsLabel;
    CCLabelTTF *sfxVolume;
    UISlider *sfxSlider;
    
    CCLabelTTF *statsProfileLabel;
    
    CCLabelTTF *resetProfiles;
    CCLabelTTF *removeAllCustomLevels;
    CCLabelTTF *resetAch;
    
    CCLabelTTF *infoLabel;
    
    CCLabelTTF *statsButton;
    CCLabelTTF *menuButton;
    CCLabelTTF *creditsButton;
    
    NSMutableDictionary *settingsDictionary;
    
    id <SettingsMenuDelegate> delegate;
    
    UIAlertView *resetAchAlert;
    UIAlertView *resetProfileAlert;
    UIAlertView *removeLevelsAlert;
}
@property(assign)id delegate;

-(void)show;
-(void)hide;
-(void)showUI;
-(void)hideUI;

-(void)newPlaylist;

-(void)resetProfiles;
-(void)removeCustomLevels;
-(void)resetAch;

-(void)leaveToMenu;

@end
