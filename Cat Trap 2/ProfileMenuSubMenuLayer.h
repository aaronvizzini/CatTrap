//
//  ProfileMenuSubMenuLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/6/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "cocos2d.h"

@protocol ProfileSubMenuDelegate <NSObject>

@optional
-(void)shouldLoadProfile:(int)profileNumber;
-(void)shouldDeleteProfile:(int)profileNumber;
-(void)shouldCreateProfile:(int)profileNumber name:(NSString *)profileName andDifficulty:(NSString *)difficulty;

@end

@interface ProfileMenuSubMenuLayer : CCLayer <UITextFieldDelegate, UIAlertViewDelegate>
{
    CCSprite *bg;
    
    CCLabelTTF *closeButton;
    CCLabelTTF *deleteButton;
    CCLabelTTF *playCreateButton;
    
    CCLabelTTF *nameLabel;
    UITextField *nameField;
    
    CCLabelTTF *difficultyLabel;
    CCLabelTTF *easyLabel;
    CCLabelTTF *moderateLabel;
    CCLabelTTF *hardLabel;
        
    CCLabelTTF *currentDifficultyLabel;

    NSString *difficultySelected;
    bool isCreateMenu;
    int currentProfileNumber; 
    
    id delegate;
}
@property(assign)id <ProfileSubMenuDelegate> delegate;

-(void)showCreateForProfile:(int)profileNumber;
-(void)showOpenForProfile:(int)profileNumber;
-(void)hide;

@end
