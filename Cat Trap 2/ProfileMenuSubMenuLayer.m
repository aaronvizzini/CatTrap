//
//  ProfileMenuSubMenuLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/6/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "ProfileMenuSubMenuLayer.h"
#import "cocos2d.h"
#import "FileHelper.h"
#import "SimpleAudioEngine.h"
#import "CTProfile.h"

@implementation ProfileMenuSubMenuLayer
@synthesize delegate;

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        isCreateMenu = NO;
        
        currentProfileNumber = 1;
        
        difficultySelected = @"moderate";
        
        [self setPosition:ccp(0,380)];

        bg = [CCSprite spriteWithFile:@"profileSubmenuBg.png"];
        bg.position = ccp(160,275);
        [self addChild:bg];
        
        closeButton = [CCLabelTTF labelWithString:@"Close" fontName:@"WetPaint" fontSize:28.0f];
        closeButton.position = ccp(45,175);
        [self addChild:closeButton];

        deleteButton = [CCLabelTTF labelWithString:@"Delete" fontName:@"WetPaint" fontSize:28.0f];
        deleteButton.position = ccp(160,175);
        [self addChild:deleteButton];

        playCreateButton = [CCLabelTTF labelWithString:@"Play" fontName:@"WetPaint" fontSize:28.0f];
        playCreateButton.position = ccp(278,175);
        [self addChild:playCreateButton];
        
        nameLabel = [CCLabelTTF labelWithString:@"- Profile Name -" fontName:@"WetPaint" fontSize:28.0f];
        nameLabel.position = ccp(160,340);
        [self addChild:nameLabel];
        
        nameField = [[UITextField alloc]initWithFrame:CGRectMake(86, 70, 150, 25)];
		[nameField setDelegate:self];
        [nameField setPlaceholder:@"The name..."];
		[nameField setKeyboardType:UIKeyboardTypeDefault];
        [nameField setTextAlignment:UITextAlignmentCenter];
		nameField.textColor = [UIColor whiteColor];
		nameField.font = [UIFont fontWithName:@"WetPaint" size:25.0];
        
        difficultyLabel = [CCLabelTTF labelWithString:@"- Difficulty -" fontName:@"WetPaint" fontSize:28.0f];
        difficultyLabel.position = ccp(160,255);
        [self addChild:difficultyLabel];
        
        easyLabel = [CCLabelTTF labelWithString:@"easy" fontName:@"WetPaint" fontSize:24.0f];
        easyLabel.position = ccp(40,220);
        easyLabel.color = ccc3(255, 255, 255);
        [self addChild:easyLabel];
        [easyLabel setVisible:NO];

        moderateLabel = [CCLabelTTF labelWithString:@"moderate" fontName:@"WetPaint" fontSize:24.0f];
        moderateLabel.position = ccp(160,220);
        moderateLabel.color = ccc3(72, 175, 249);
        [self addChild:moderateLabel];
        [moderateLabel setVisible:NO];
        
        hardLabel = [CCLabelTTF labelWithString:@"hard" fontName:@"WetPaint" fontSize:24.0f];
        hardLabel.position = ccp(282,220);
        hardLabel.color = ccc3(255, 255, 255);
        [self addChild:hardLabel];
        [hardLabel setVisible:NO];
        
        currentDifficultyLabel = [CCLabelTTF labelWithString:@"" fontName:@"WetPaint" fontSize:24.0f];
        currentDifficultyLabel.position = ccp(160,220);
        currentDifficultyLabel.color = ccc3(72, 175, 249);
        [self addChild:currentDifficultyLabel];
        [currentDifficultyLabel setVisible:NO];
    }
    
    return self;
}

#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nameField resignFirstResponder];
    
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
	CGPoint local1 = [closeButton convertToNodeSpace:touchLocation];
    CGPoint local2 = [deleteButton convertToNodeSpace:touchLocation];
    CGPoint local3 = [playCreateButton convertToNodeSpace:touchLocation];
    CGPoint local4 = [easyLabel convertToNodeSpace:touchLocation];
    CGPoint local5 = [moderateLabel convertToNodeSpace:touchLocation];
    CGPoint local6 = [hardLabel convertToNodeSpace:touchLocation];
    
	CGRect r1 = [closeButton textureRect];
    CGRect r2 = [deleteButton textureRect];
    CGRect r3 = [playCreateButton textureRect];
    CGRect r4 = [easyLabel textureRect];
    CGRect r5 = [moderateLabel textureRect];
    CGRect r6 = [hardLabel textureRect];
    
    if(CGRectContainsPoint(r1, local1))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(hide)];
        [closeButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    if(CGRectContainsPoint(r2, local2))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(hide)];
        [deleteButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure that you want to delete this profile?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];
    }
    
    if(CGRectContainsPoint(r3, local3))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(hide)];
        [playCreateButton runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        
        if(isCreateMenu && [nameField.text length] > 0)
        {
            if(self.delegate)[self.delegate shouldCreateProfile:currentProfileNumber name:nameField.text andDifficulty:difficultySelected];
        }
        
        else
        {
            if(self.delegate)[self.delegate shouldLoadProfile:currentProfileNumber];
        }
    }
    
    if(CGRectContainsPoint(r4, local4))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [easyLabel runAction:[CCSequence actions:bounce, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        
        difficultySelected = @"easy";
        
        easyLabel.color = ccc3(72, 175, 249);
        moderateLabel.color = ccc3(255, 255,255);
        hardLabel.color = ccc3(255,255, 255);
    }
    
    if(CGRectContainsPoint(r5, local5))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [moderateLabel runAction:[CCSequence actions:bounce, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        
        difficultySelected = @"moderate";
        
        easyLabel.color = ccc3(255, 255,255);
        moderateLabel.color = ccc3(72, 175, 249);
        hardLabel.color = ccc3(255, 255,255);
    }
    
    if(CGRectContainsPoint(r6, local6))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [hardLabel runAction:[CCSequence actions:bounce, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
        
        difficultySelected = @"hard";
        
        easyLabel.color = ccc3(255, 255,255);
        moderateLabel.color = ccc3(255, 255,255);
        hardLabel.color = ccc3(72, 175, 249);
    }
}

#pragma mark -
#pragma mark Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(self.delegate)[self.delegate shouldDeleteProfile:currentProfileNumber];
    }
}

#pragma mark -
#pragma mark Visibility Methods

-(void)showCreateForProfile:(int)profileNumber
{
    currentProfileNumber = profileNumber;
    isCreateMenu = YES;

    [currentDifficultyLabel setVisible:NO];
    [nameField setEnabled:YES];
    [easyLabel setVisible:YES];
    [moderateLabel setVisible:YES];
    [hardLabel setVisible:YES];
            
    [deleteButton setString:@""];
    [playCreateButton setString:@"Save"];
    
    CCLayer *layer = (CCLayer *)[self parent];
    layer.isTouchEnabled = NO;
    
    id move = [CCMoveTo actionWithDuration:.7f position:CGPointMake(self.position.x, 100)];
    [self runAction:[CCSequence actions:move, [CCCallFunc actionWithTarget:self selector:@selector(_showUI)], nil]];
}

-(void)_showUI
{
    [[[CCDirector sharedDirector]openGLView]addSubview:nameField];
}

-(void)showOpenForProfile:(int)profileNumber
{    
    currentProfileNumber = profileNumber;
    isCreateMenu = NO;

    [currentDifficultyLabel setVisible:YES];
    [nameField setEnabled:NO];
        
    [deleteButton setString:@"Delete"];
    [playCreateButton setString:@"Play"];
    
    CCLayer *layer = (CCLayer *)[self parent];
    layer.isTouchEnabled = NO;
    
    CTProfile *profile = [[CTProfile alloc]initFromFile:[FileHelper getProfilePathByNumber:profileNumber]];
    nameField.text = profile.name;
    currentDifficultyLabel.string = profile.difficulty;
    [profile release];
    
    id move = [CCMoveTo actionWithDuration:.7f position:CGPointMake(self.position.x, 100)];
    [self runAction:[CCSequence actions:move, [CCCallFunc actionWithTarget:self selector:@selector(_showUI)], nil]];
}

-(void)hide
{
    difficultySelected = @"moderate";
    isCreateMenu = NO;
    
    [nameField setText:@""];
    [nameField removeFromSuperview];
    [easyLabel setVisible:NO];
    [moderateLabel setVisible:NO];
    [hardLabel setVisible:NO];
    
    easyLabel.color = ccc3(255, 255,255);
    moderateLabel.color = ccc3(72, 175, 249);
    hardLabel.color = ccc3(255, 255,255);
    
    CCLayer *layer = (CCLayer *)[self parent];
    layer.isTouchEnabled = YES;
    
    id move = [CCMoveTo actionWithDuration:.7f position:CGPointMake(self.position.x, 380)];
    [self runAction:move];
}

#pragma mark -
#pragma mark - Textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Clean Up

-(void)dealloc
{
    [nameField removeFromSuperview];
    [nameField release];
    [super dealloc];
}

@end
