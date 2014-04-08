//
//  LevelSelectLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/30/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "LevelSelectLayer.h"

#import "CTSettingsIcon.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "CTLevel.h"
#import "FileHelper.h"
#import "GameplayControllerScene.h"
#import "CTManager.h"
#import "CTProfile.h"
#import "ProfileMenuScene.h"

#define kFontSize 72
#define kFontSizeSmall 14
#define kFontColorLocked ccc3(205,201,201)
#define kFontColorUnlocked ccc3(72, 175, 249)
#define kFontColorSub ccc3(255, 215, 0)
#define kMaxPageCount 4
#define kScaleDownAnimationSpeed .3f
#define kScaleUpAnimationSpeed .5f

#define kSettingsMenuTag 1

@implementation LevelSelectLayer

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.isTouchEnabled = YES;
        
        currentPage = 1;

        settingsButton = [CTSettingsIcon node];
        settingsButton.position = ccp(160,0);
        [self addChild: settingsButton];
        [settingsButton setTarget:self andSelector:@selector(viewSettings)];
        
        labelA = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelA setColor:kFontColorLocked];
        labelA.position = ccp(49,430);
        [self addChild:labelA];
        
        labelB = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelB setColor:kFontColorLocked];
        labelB.position = ccp(161,430);
        [self addChild:labelB];
        
        labelC = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelC setColor:kFontColorLocked];
        labelC.position = ccp(273,430);
        [self addChild:labelC];
        
        labelD = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelD setColor:kFontColorLocked];
        labelD.position = ccp(49,330);
        [self addChild:labelD];
        
        labelE = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelE setColor:kFontColorLocked];
        labelE.position = ccp(161,330);
        [self addChild:labelE];
        
        labelF = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelF setColor:kFontColorLocked];
        labelF.position = ccp(273,330);
        [self addChild:labelF];
        
        labelG = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelG setColor:kFontColorLocked];
        labelG.position = ccp(49,230);
        [self addChild:labelG];
        
        labelH = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelH setColor:kFontColorLocked];
        labelH.position = ccp(161,230);
        [self addChild:labelH];
        
        labelI = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelI setColor:kFontColorLocked];
        labelI.position = ccp(273,230);
        [self addChild:labelI];
        
        labelJ = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelJ setColor:kFontColorLocked];
        labelJ.position = ccp(49,130);
        [self addChild:labelJ];
        
        labelK = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelK setColor:kFontColorLocked];
        labelK.position = ccp(161,130);
        [self addChild:labelK];
        
        labelL = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:kFontSize];
        [labelL setColor:kFontColorLocked];
        labelL.position = ccp(273,130);
        [self addChild:labelL];

        backButton = [CCSprite spriteWithFile:@"backIcon.png"];
        [self addChild:backButton];
        backButton.position = ccp(55,45);
        
        forwardButton = [CCSprite spriteWithFile:@"forwardIcon.png"];
        [self addChild:forwardButton];
        forwardButton.position = ccp(265,45);

        [self displayLevelsForPage:currentPage];
    }
    
    return self;
}

-(void)displayLevelsForPage:(int)page
{
    labelA.color = kFontColorLocked;
    labelB.color = kFontColorLocked;
    labelC.color = kFontColorLocked;
    labelD.color = kFontColorLocked;
    labelE.color = kFontColorLocked;
    labelF.color = kFontColorLocked;
    labelG.color = kFontColorLocked;
    labelH.color = kFontColorLocked;
    labelI.color = kFontColorLocked;
    labelJ.color = kFontColorLocked;
    labelK.color = kFontColorLocked;
    labelL.color = kFontColorLocked;
    
    currentPage = page;
    
    if(page == 1)
    {
        [labelA setString:@"1"];
        [labelB setString:@"2"];
        [labelC setString:@"3"];
        [labelD setString:@"4"];
        [labelE setString:@"5"];
        [labelF setString:@"6"];
        [labelG setString:@"7"];
        [labelH setString:@"8"];
        [labelI setString:@"9"];
        [labelJ setString:@"10"];
        [labelK setString:@"11"];
        [labelL setString:@"12"];
        
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:0] =='1')labelA.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:1] =='1')labelB.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:2] =='1')labelC.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:3] =='1')labelD.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:4] =='1')labelE.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:5] =='1')labelF.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:6] =='1')labelG.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:7] =='1')labelH.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:8] =='1')labelI.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:9] =='1')labelJ.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:10] =='1')labelK.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:11] =='1')labelL.color = kFontColorUnlocked;
    }
    
    else if(page >= 2)
    {
        int startLevel = ((page-1)*12);
        
        [labelA setString:[NSString stringWithFormat:@"%i",startLevel+1]];
        [labelB setString:[NSString stringWithFormat:@"%i",startLevel+2]];
        [labelC setString:[NSString stringWithFormat:@"%i",startLevel+3]];
        [labelD setString:[NSString stringWithFormat:@"%i",startLevel+4]];
        [labelE setString:[NSString stringWithFormat:@"%i",startLevel+5]];
        [labelF setString:[NSString stringWithFormat:@"%i",startLevel+6]];
        [labelG setString:[NSString stringWithFormat:@"%i",startLevel+7]];
        [labelH setString:[NSString stringWithFormat:@"%i",startLevel+8]];
        [labelI setString:[NSString stringWithFormat:@"%i",startLevel+9]];
        [labelJ setString:[NSString stringWithFormat:@"%i",startLevel+10]];
        [labelK setString:[NSString stringWithFormat:@"%i",startLevel+11]];
        [labelL setString:[NSString stringWithFormat:@"%i",startLevel+12]];
                        
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+1)-1] =='1')labelA.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+2)-1] =='1')labelB.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+3)-1] =='1')labelC.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+4)-1] =='1')labelD.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+5)-1] =='1')labelE.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+6)-1] =='1')labelF.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+7)-1] =='1')labelG.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+8)-1] =='1')labelH.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+9)-1] =='1')labelI.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+10)-1] =='1')labelJ.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+11)-1] =='1')labelK.color = kFontColorUnlocked;
        if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:(startLevel+12)-1] =='1')labelL.color = kFontColorUnlocked;
    }
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
	CGPoint local1 = [labelA convertToNodeSpace:touchLocation];
    CGPoint local2 = [labelB convertToNodeSpace:touchLocation];
    CGPoint local3 = [labelC convertToNodeSpace:touchLocation];
    CGPoint local4 = [labelD convertToNodeSpace:touchLocation];
    CGPoint local5 = [labelE convertToNodeSpace:touchLocation];
    CGPoint local6 = [labelF convertToNodeSpace:touchLocation];
    CGPoint local7 = [labelG convertToNodeSpace:touchLocation];
    CGPoint local8 = [labelH convertToNodeSpace:touchLocation];
    CGPoint local9 = [labelI convertToNodeSpace:touchLocation];
    CGPoint local10 = [labelJ convertToNodeSpace:touchLocation];
    CGPoint local11 =  [labelK convertToNodeSpace:touchLocation];
    CGPoint local12 = [labelL convertToNodeSpace:touchLocation];
    
	CGRect r1 = [labelA textureRect];
    CGRect r2 = [labelB textureRect];
    CGRect r3 = [labelC textureRect];
    CGRect r4 = [labelD textureRect];
    CGRect r5 = [labelE textureRect];
    CGRect r6 = [labelF textureRect];
    CGRect r7 = [labelG textureRect];
    CGRect r8 = [labelH textureRect];
    CGRect r9 = [labelI textureRect];
    CGRect r10 = [labelJ textureRect];
    CGRect r11 = [labelK textureRect];
    CGRect r12 = [labelL textureRect];
    
    if(CGRectContainsPoint(r1, local1))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelA runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r2, local2))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelB runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r3, local3))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelC runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r4, local4))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelD runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r5, local5))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelE runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r6, local6))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelF runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r7, local7))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelG runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r8, local8))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelH runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r9, local9))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelI runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r10, local10))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelJ runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r11, local11))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelK runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r12, local12))
    {
        id action = [CCScaleTo actionWithDuration:kScaleDownAnimationSpeed scale:.5f];
        [labelL runAction:action];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
}


-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
        
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];

	CGPoint local13 = [forwardButton convertToNodeSpace:touchLocation];
    CGPoint local14 = [backButton convertToNodeSpace:touchLocation];
	CGRect r13 = [forwardButton textureRect];
    CGRect r14 = [backButton textureRect];
    
    CGPoint local1 = [labelA convertToNodeSpace:touchLocation];
    CGPoint local2 = [labelB convertToNodeSpace:touchLocation];
    CGPoint local3 = [labelC convertToNodeSpace:touchLocation];
    CGPoint local4 = [labelD convertToNodeSpace:touchLocation];
    CGPoint local5 = [labelE convertToNodeSpace:touchLocation];
    CGPoint local6 = [labelF convertToNodeSpace:touchLocation];
    CGPoint local7 = [labelG convertToNodeSpace:touchLocation];
    CGPoint local8 = [labelH convertToNodeSpace:touchLocation];
    CGPoint local9 = [labelI convertToNodeSpace:touchLocation];
    CGPoint local10 = [labelJ convertToNodeSpace:touchLocation];
    CGPoint local11 =  [labelK convertToNodeSpace:touchLocation];
    CGPoint local12 = [labelL convertToNodeSpace:touchLocation];
    
	CGRect r1 = [labelA textureRect];
    CGRect r2 = [labelB textureRect];
    CGRect r3 = [labelC textureRect];
    CGRect r4 = [labelD textureRect];
    CGRect r5 = [labelE textureRect];
    CGRect r6 = [labelF textureRect];
    CGRect r7 = [labelG textureRect];
    CGRect r8 = [labelH textureRect];
    CGRect r9 = [labelI textureRect];
    CGRect r10 = [labelJ textureRect];
    CGRect r11 = [labelK textureRect];
    CGRect r12 = [labelL textureRect];
    
    if(CGRectContainsPoint(r1, local1))[self selectedLevel:[[labelA string]intValue]];
    
    else if(CGRectContainsPoint(r2, local2))[self selectedLevel:[[labelB string]intValue]];
    
    else if(CGRectContainsPoint(r3, local3))[self selectedLevel:[[labelC string]intValue]];
    
    else if(CGRectContainsPoint(r4, local4))[self selectedLevel:[[labelD string]intValue]];
    
    else if(CGRectContainsPoint(r5, local5))[self selectedLevel:[[labelE string]intValue]];
    
    else if(CGRectContainsPoint(r6, local6))[self selectedLevel:[[labelF string]intValue]];
    
    else if(CGRectContainsPoint(r7, local7))[self selectedLevel:[[labelG string]intValue]];
    
    else if(CGRectContainsPoint(r8, local8))[self selectedLevel:[[labelH string]intValue]];
    
    else if(CGRectContainsPoint(r9, local9))[self selectedLevel:[[labelI string]intValue]];
    
    else if(CGRectContainsPoint(r10, local10))[self selectedLevel:[[labelJ string]intValue]];
    
    else if(CGRectContainsPoint(r11, local11))[self selectedLevel:[[labelK string]intValue]];
    
    else if(CGRectContainsPoint(r12, local12))[self selectedLevel:[[labelL string]intValue]];

    else if(CGRectContainsPoint(r13,local13))
    {
        [self forwardButtonAction];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(r14, local14))
    {
        if(currentPage >= 2)[self backButtonAction];
        else [self homeButtonAction];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    id action1 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelA runAction:action1];
    
    id action2 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelB runAction:action2];

    id action3 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelC runAction:action3];
  
    id action4 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelD runAction:action4];
    
    id action5 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelE runAction:action5];
    
    id action6 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelF runAction:action6];
   
    id action7 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelG runAction:action7];
   
    id action8 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelH runAction:action8];

    id action9 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelI runAction:action9];
  
    id action10 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelJ runAction:action10];
 
    id action11 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelK runAction:action11];

    id action12 = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:kScaleUpAnimationSpeed scale:1.0f]];
    [labelL runAction:action12];
}

#pragma mark - 
#pragma mark action methods

-(void)viewSettings
{
    SettingsMenuLayer *settings = [SettingsMenuLayer node];
    [settings setDelegate:self];
    [self addChild:settings z:5 tag:kSettingsMenuTag];
    [settings show];
    self.isTouchEnabled = NO;
}

-(void)backButtonAction
{
    if(currentPage >= 1)currentPage--;
    [self displayLevelsForPage:currentPage];
}

-(void)forwardButtonAction
{
    if(currentPage < kMaxPageCount)
    {
        currentPage++;
        
        if(currentPage == kMaxPageCount)[forwardButton setVisible:NO];
    }
    
    [self displayLevelsForPage:currentPage];
}

-(void)homeButtonAction
{
    [[CCDirector sharedDirector] replaceScene:[ProfileMenuScene node]];
    [[CTManager sharedInstance]setCurrentProfile:nil];
}

-(void)selectedLevel:(int)levelNumber
{
    if([[[[CTManager sharedInstance]currentProfile]classicData]characterAtIndex:levelNumber-1] =='0')return;
    
    if([[[CTManager sharedInstance]currentProfile]isNew])
    {
        GameplayControllerScene *gameplayScene = [GameplayControllerScene node];
        [gameplayScene loadLevel:[CTLevel tutorial]];
        [[[CTManager sharedInstance]currentProfile]setIsNew:NO];
        [[[CTManager sharedInstance]currentProfile]writeToFile:[FileHelper getProfilePathByNumber:[[[CTManager sharedInstance]currentProfile]profileNumber]]];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }
    
    else
    {
        CTLevel *levelSelected = [[CTLevel alloc]initFromFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat: @"%i",levelNumber] ofType:@""]];
    
        GameplayControllerScene *gameplayScene = [GameplayControllerScene node];
        [gameplayScene loadLevel:levelSelected];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
        
        [levelSelected release];
    }
}

#pragma mark -
#pragma mark Settings Menu Delegate

-(void)settingsMenuWillClose
{
    [self removeChildByTag:kSettingsMenuTag cleanup:YES];
    [settingsButton reset];
    self.isTouchEnabled = YES;
}

#pragma mark -
#pragma mark clean up

-(void)dealloc
{
    [super dealloc];
}

@end
