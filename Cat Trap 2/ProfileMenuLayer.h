//
//  ProfileMenuLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/24/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ProfileMenuSubMenuLayer.h"

@interface ProfileMenuLayer : CCLayer <ProfileSubMenuDelegate>
{
    CCLabelTTF *profile1Name;
    CCLabelTTF *profile2Name;
    CCLabelTTF *profile3Name;
    CCLabelTTF *profile4Name;
    
    CCLabelTTF *menuButton;
    
    bool profile1Used;
    bool profile2Used;
    bool profile3Used;
    bool profile4Used;
    
    ProfileMenuSubMenuLayer *subMenu;
}

-(void)loadProfileData;

-(void)didSelectProfile:(int)profileNumber;
-(void)createProfile:(int)profileNumber name:(NSString *)name difficulty:(NSString *)difficulty;
-(void)deleteProfile:(int)profileNumber;

-(void)showProfileMenuForProfile:(int)profileNumber;
-(void)showProfileCreateMenuForProfile:(int)profileNumber;

-(void)leaveToMenu;

@end
