//
//  SettingsMenuLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/20/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "SettingsMenuLayer.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "FileHelper.h"
#import "StatisticsMenuScene.h"
#import "CTGameCenterManager.h"
#import "CreditsMenuScene.h"

@implementation SettingsMenuLayer
@synthesize delegate;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {        
        [self setPosition:ccp(0, -480)];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"blankBackground.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
        
        settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
        
        self.isTouchEnabled = YES;
        
        controller = nil;
        
        audioSettingsLabel = [CCLabelTTF labelWithString:@"Audio Settings" fontName:@"WetPaint" fontSize:30.0f];
        audioSettingsLabel.position = ccp(160,440);
        audioSettingsLabel.color = ccc3(72, 175, 249);
        [self addChild:audioSettingsLabel];
        
        sfxVolume = [CCLabelTTF labelWithString:@"SFX Volume:" fontName:@"WetPaint" fontSize:21.0f];
        sfxVolume.position = ccp(75,380);
        [self addChild:sfxVolume];

        sfxSlider = [[UISlider alloc]initWithFrame:CGRectMake(135, 85, 160, 25)];
        [sfxSlider setValue:[[settingsDictionary objectForKey:@"SFXVolume"]floatValue]];
        [sfxSlider addTarget:self action:@selector(volumeSFXChange) forControlEvents:UIControlEventValueChanged];	
        [sfxSlider setMaximumValue:1.0f];
        [sfxSlider setMinimumValue:0.0f];
        
        infoLabel = [CCLabelTTF labelWithString:@"Data Management" fontName:@"WetPaint" fontSize:30.0f];
        infoLabel.position = ccp(160,290);
        infoLabel.color = ccc3(72, 175, 249);
        [self addChild:infoLabel];
        
        resetAch = [CCLabelTTF labelWithString:@"Reset Achievements" fontName:@"WetPaint" fontSize:25.0f];
        resetAch.position = ccp(160,245);
        [self addChild:resetAch];
        
        resetProfiles = [CCLabelTTF labelWithString:@"Reset Profiles" fontName:@"WetPaint" fontSize:25.0f];
        resetProfiles.position = ccp(160,205);
        [self addChild:resetProfiles];
        
        removeAllCustomLevels = [CCLabelTTF labelWithString:@"Remove Custom Levels" fontName:@"WetPaint" fontSize:25.0f];
        removeAllCustomLevels.position = ccp(160,165);
        [self addChild:removeAllCustomLevels];
        
        menuButton = [CCLabelTTF labelWithString:@"Back" fontName:@"WetPaint" fontSize:28.0f];
        menuButton.position = ccp(278,22);
        [self addChild:menuButton];
        
        creditsButton = [CCLabelTTF labelWithString:@"Credits" fontName:@"WetPaint" fontSize:28.0f];
        creditsButton.position = ccp(160,22);
        [self addChild:creditsButton];
        
        statsButton = [CCLabelTTF labelWithString:@"Stats" fontName:@"WetPaint" fontSize:28.0f];
        statsButton.position = ccp(50,22);
        [self addChild:statsButton];
        
        resetAchAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you wish to reset all your Game Center Achievements?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        resetProfileAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you wish to remove all profiles?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        removeLevelsAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you wish to remove all custom levels?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark Show/Hide Methods

-(void)hide
{
    [self hideUI];
    
    id move = [CCMoveTo actionWithDuration:.8f position:CGPointMake(self.position.x, -480)];
    [self runAction:[CCSequence actions:move, [CCCallFunc actionWithTarget:self.delegate selector:@selector(settingsMenuWillClose)], nil]];
    
    id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
    [menuButton runAction:[CCSequence actions:bounce, nil]];
    
}

-(void)show
{
    id move = [CCMoveTo actionWithDuration:.8f position:CGPointMake(self.position.x, 0)];
    [self runAction:[CCSequence actions:move, [CCCallFunc actionWithTarget:self selector:@selector(showUI)], nil]];
}

-(void)hideUI
{
    [sfxSlider removeFromSuperview];
}

-(void)showUI
{
    [[[CCDirector sharedDirector]openGLView]addSubview:sfxSlider];
}

#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
    CGPoint local2 = [resetAch convertToNodeSpace:touchLocation];
    CGPoint local3 = [resetProfiles convertToNodeSpace:touchLocation];
    CGPoint local4 = [removeAllCustomLevels convertToNodeSpace:touchLocation];
    CGPoint local5 = [menuButton convertToNodeSpace:touchLocation];
    CGPoint local6 = [statsButton convertToNodeSpace:touchLocation];
    CGPoint local7 = [creditsButton convertToNodeSpace:touchLocation];
    
    CGRect r2 = [resetAch textureRect];
    CGRect r3 = [resetProfiles textureRect];
    CGRect r4 = [removeAllCustomLevels textureRect];
    CGRect r5 = [menuButton textureRect];
    CGRect r6 = [statsButton textureRect];
    CGRect r7 = [statsButton textureRect];
    
    if(CGRectContainsPoint(r2, local2))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        
        [resetAchAlert show];
        
        [resetAch runAction:[CCSequence actions:bounce, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r3, local3))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        
        [resetProfileAlert show];
        
        [resetProfiles runAction:[CCSequence actions:bounce, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r4, local4))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];

        [removeLevelsAlert show];
        
        [removeAllCustomLevels runAction:[CCSequence actions:bounce, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r5, local5))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];      
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(leaveToMenu)];
        [menuButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r6, local6))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];      
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(leaveToStatsMenu)];
        [statsButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r7, local7))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];      
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(leaveToCredits)];
        [creditsButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
}

#pragma mark -
#pragma mark Action methods

-(void)leaveToMenu
{
    [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];

    [self hide];
}

-(void)leaveToStatsMenu
{
    [self hide];
    [[CCDirector sharedDirector]replaceScene:[StatisticsMenuScene node]];
}

-(void)leaveToCredits
{
    [self hide];
    [[CCDirector sharedDirector]replaceScene:[CreditsMenuScene node]];
}

-(void)newPlaylist
{
    if(controller == nil)
	{
		
		//Begin
		controller = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
		controller.delegate = self;
		controller.prompt = @"Select the music you wish to hear!";
		[controller setAllowsPickingMultipleItems: YES];  
		[controller.view setBackgroundColor:[UIColor blackColor]];
		controller.view.frame = CGRectMake(0, 525, 320, 480);
		[[[CCDirector sharedDirector]openGLView]addSubview:controller.view];
		
		//Animation of the Media Picker
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		controller.view.frame = CGRectMake(0, 0, 320, 480);
		[UIView commitAnimations];	
		//End
		
	}
}

-(void)resetProfiles
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for(NSString *path in [fm contentsOfDirectoryAtPath:[FileHelper getProfilesDirectory] error:nil])
        [fm removeItemAtPath:[[FileHelper getProfilesDirectory]stringByAppendingPathComponent:path] error:nil];
}

-(void)removeCustomLevels
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for(NSString *path in [fm contentsOfDirectoryAtPath:[FileHelper getCustomLevelsDirectory] error:nil])
    {
        [fm removeItemAtPath:[[FileHelper getCustomLevelsDirectory]stringByAppendingPathComponent:path] error:nil];
    }
}

-(void)resetAch
{
    CTGameCenterManager *gcm = [[CTGameCenterManager alloc]init];
    
    [gcm resetAchievements];
    
    [gcm release];
}


-(void)volumeSFXChange
{
	[[SimpleAudioEngine sharedEngine]setEffectsVolume:sfxSlider.value];
	[[SimpleAudioEngine sharedEngine]setBackgroundMusicVolume:sfxSlider.value];
    [settingsDictionary setObject:[NSNumber numberWithFloat:sfxSlider.value] forKey:@"SFXVolume"];
}

#pragma mark -
#pragma mark Alert Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == resetAchAlert && buttonIndex == 1)
    {
        [self resetAch];
    }
    
    else if(alertView == resetProfileAlert && buttonIndex == 1)
    {
        [self resetProfiles];
    }
    
    else if(alertView == removeLevelsAlert && buttonIndex == 1)
    {
        [self removeCustomLevels];
    }
}


#pragma mark -
#pragma mark Media Picker Delegate Methods

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
	myPlayer = [MPMusicPlayerController iPodMusicPlayer];
	[myPlayer setQueueWithItemCollection: mediaItemCollection];
	[myPlayer play];
    
	[UIView beginAnimations:@"MediaAnimate" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	controller.view.frame = CGRectMake(0, 525, 320, 480);
	[UIView commitAnimations];	
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
	[UIView beginAnimations:@"MediaAnimate" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	controller.view.frame = CGRectMake(0, 525, 320, 480);
	[UIView commitAnimations];	
	
}

- (void)animationDidStop
{
	[controller.view removeFromSuperview];
	[controller release];	
	controller = nil;
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [removeLevelsAlert release];
    [resetProfileAlert release];
    [resetAchAlert release];
    [settingsDictionary release];
    
    if(controller)[controller.view removeFromSuperview];
    [controller release];
    [myPlayer release];
    
    [sfxSlider release];
    [super dealloc];
}

@end
