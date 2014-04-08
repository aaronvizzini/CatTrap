//
//  ProfileMenuLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/24/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "ProfileMenuLayer.h"
#import "FileHelper.h"
#import "MainMenuScene.h"
#import "ProfileMenuSubMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "CTProfile.h"
#import "CTManager.h"
#import "LevelSelectScene.h"

#define kProfileFontSize 24.0f
#define kProfileDetailsFontSize 24.0f

@implementation ProfileMenuLayer

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        subMenu = [ProfileMenuSubMenuLayer node];
        subMenu.delegate = self;
        [self addChild:subMenu z:5];
        
        profile1Name = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(130, 25) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeTailTruncation fontName:@"Times New Roman" fontSize:kProfileFontSize];
        profile1Name.position = ccp(107,417);
        profile1Name.color = ccc3(0, 0, 0);
        [self addChild:profile1Name];
        
        profile2Name = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(130, 25) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeTailTruncation fontName:@"Times New Roman" fontSize:kProfileFontSize];
        profile2Name.position = ccp(107,311);
        profile2Name.color = ccc3(0, 0, 0);
        [self addChild:profile2Name];
        
        profile3Name = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(130, 25) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeTailTruncation fontName:@"Times New Roman" fontSize:kProfileFontSize];
        profile3Name.position = ccp(107,206);
        profile3Name.color = ccc3(0, 0, 0);
        [self addChild:profile3Name];
        
        profile4Name = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(130, 25) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeTailTruncation fontName:@"Times New Roman" fontSize:kProfileFontSize];
        profile4Name.position = ccp(107,106);
        profile4Name.color = ccc3(0, 0, 0);
        [self addChild:profile4Name];
        
        menuButton = [CCLabelTTF labelWithString:@"Back" fontName:@"WetPaint" fontSize:28.0f];
        menuButton.position = ccp(280,17);
        [self addChild:menuButton];
        
        [self loadProfileData];
    }
    
    return self;
}

#pragma mark -
#pragma mark Profile Loading Method

-(void)loadProfileData
{
    CTProfile *profile1 = [[CTProfile alloc]initFromFile:[FileHelper getProfilePathByNumber:1]];
    CTProfile *profile2 = [[CTProfile alloc]initFromFile:[FileHelper getProfilePathByNumber:2]];
    CTProfile *profile3 = [[CTProfile alloc]initFromFile:[FileHelper getProfilePathByNumber:3]];
    CTProfile *profile4 = [[CTProfile alloc]initFromFile:[FileHelper getProfilePathByNumber:4]];
    
    if(profile1)
    {
        profile1Name.string = profile1.name;
        profile1Used = YES;
    }
    
    else 
    {
        profile1Name.string = @"New Profle";
        profile1Used = NO;
    }
    
    if(profile2)
    {
        profile2Name.string = profile2.name;
        profile2Used = YES;
    }
    
    else
    {
        profile2Name.string = @"New Profile";
        profile2Used = NO;
    }
    
    if(profile3)
    {
        profile3Name.string = profile3.name;
        profile3Used = YES;
    }
    
    else
    {
        profile3Name.string = @"New Profile";
        profile3Used = NO;
    }
    
    if(profile4)
    {
        profile4Name.string = profile4.name;
        profile4Used = YES;
    }
    
    else
    {
        profile4Name.string = @"New Profile";
        profile4Used = NO;
    }
    
    [profile1 release];
    [profile2 release];
    [profile3 release];
    [profile4 release];
}

#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
    CGPoint local1 = [menuButton convertToNodeSpace:touchLocation];
    
    CGPoint local2 = [profile1Name convertToNodeSpace:touchLocation];
    CGPoint local3 = [profile2Name convertToNodeSpace:touchLocation];
    CGPoint local4 = [profile3Name convertToNodeSpace:touchLocation];
    CGPoint local5 = [profile4Name convertToNodeSpace:touchLocation];
    
    CGRect r1 = [menuButton textureRect];
    
    CGRect r2 = [profile1Name textureRect];
    CGRect r3 = [profile2Name textureRect];
    CGRect r4 = [profile3Name textureRect];
    CGRect r5 = [profile4Name textureRect];
    
    if(CGRectContainsPoint(r1, local1))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];      
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(leaveToMenu)];
        [menuButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    if(CGRectContainsPoint(r2, local2))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        [self didSelectProfile:1];
    }
    
    if(CGRectContainsPoint(r3, local3))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        [self didSelectProfile:2];
    }
    
    if(CGRectContainsPoint(r4, local4))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        [self didSelectProfile:3];
    }
    
    if(CGRectContainsPoint(r5, local5))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        [self didSelectProfile:4];
    }
}

#pragma mark -
#pragma mark Action Methods

-(void)leaveToMenu
{
    [[CCDirector sharedDirector]replaceScene:[MainMenuScene node]];
}

-(void)didSelectProfile:(int)profileNumber
{
    if(profileNumber == 1 && profile1Used)
    {
        [self showProfileMenuForProfile:1];
    }
    
    else if(profileNumber == 1)
    {
        [self showProfileCreateMenuForProfile:1];
    }
    
    if(profileNumber == 2 && profile2Used)
    {
        [self showProfileMenuForProfile:2];
    }
    
    else if(profileNumber == 2)
    {
        [self showProfileCreateMenuForProfile:2];
    }
    
    if(profileNumber == 3 && profile3Used)
    {
        [self showProfileMenuForProfile:3];
    }
    
    else if(profileNumber == 3)
    {
        [self showProfileCreateMenuForProfile:3];
    }
    
    if(profileNumber == 4 && profile4Used)
    {
        [self showProfileMenuForProfile:4];
    }
    
    else if(profileNumber == 4)
    {
        [self showProfileCreateMenuForProfile:4];
    }
}

-(void)createProfile:(int)profileNumber name:(NSString *)name difficulty:(NSString *)difficulty
{
    CTProfile *profileToCreate = [[CTProfile alloc]initWithProfileNumber:profileNumber name:name difficulty:difficulty];
    [profileToCreate writeToFile:nil];
    [self loadProfileData];
    [profileToCreate release];
}

-(void)deleteProfile:(int)profileNumber
{
    [[NSFileManager defaultManager]removeItemAtPath:[FileHelper getProfilePathByNumber:profileNumber] error:nil];
    
    [self loadProfileData];
}

#pragma mark -
#pragma mark Profile Management Sub-Menus

-(void)showProfileMenuForProfile:(int)profileNumber
{
    [subMenu showOpenForProfile:profileNumber];
}

-(void)showProfileCreateMenuForProfile:(int)profileNumber
{
    [subMenu showCreateForProfile:profileNumber];
}

#pragma mark -
#pragma mark Sub Menu Delegate Methods

-(void)shouldLoadProfile:(int)profileNumber
{
    CTProfile *profileToLoad = [[CTProfile alloc]initFromFile:[FileHelper getProfilePathByNumber:profileNumber]];
    [[CTManager sharedInstance]setCurrentProfile:profileToLoad];
    [profileToLoad release];
    
    [[CCDirector sharedDirector]replaceScene:[LevelSelectScene node]];
}

-(void)shouldDeleteProfile:(int)profileNumber
{
    [self deleteProfile:profileNumber];
}

-(void)shouldCreateProfile:(int)profileNumber name:(NSString *)profileName andDifficulty:(NSString *)difficulty
{
    [self createProfile:profileNumber name:profileName difficulty:difficulty];
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [super dealloc];
}

@end
