//
//  SaveLevelMenu.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/10/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "SaveLevelMenu.h"

#import "CTLevel.h"
#import "SpriteRect.h"
#import "CTSprite.h"
#import "CTPushable.h"
#import "CTElement.h"
#import "FileHelper.h"
#import "SimpleAudioEngine.h"

#define kFontSize 25.0f

@implementation SaveLevelMenu
@synthesize delegate;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        [self addChild:[CCSprite spriteWithFile:@"blankBackground.png"]];

        saveButton = [CCSprite spriteWithFile:@"continueButton.png"];
        saveButton.position = ccp(135,-212);
        
        quitButton = [CCSprite spriteWithFile:@"quitButton.png"];
        quitButton.position = ccp(-140,-212);
        
        [self addChild:quitButton];
        [self addChild:saveButton];
                
        [self setPosition:ccp(160, 760)];
        
        levelName = [[UITextField alloc]initWithFrame:CGRectMake(154, 27, 150, 25)];
		[levelName setDelegate:self];
        [levelName setPlaceholder:@"My Level"];
		[levelName setKeyboardType:UIKeyboardTypeDefault];
		levelName.textColor = [UIColor whiteColor];
		levelName.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
        
        wavesBetweenIncreases = [[UITextField alloc]initWithFrame:CGRectMake(240, 87, 150, 25)];
		[wavesBetweenIncreases setDelegate:self];
        [wavesBetweenIncreases setPlaceholder:@"0"];
		[wavesBetweenIncreases setKeyboardType:UIKeyboardTypeNumberPad];
		wavesBetweenIncreases.textColor = [UIColor whiteColor];
		wavesBetweenIncreases.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
        
        totalNumberOfWaves = [[UITextField alloc]initWithFrame:CGRectMake(170, 147, 150, 25)];
		[totalNumberOfWaves setDelegate:self];
        [totalNumberOfWaves setPlaceholder:@"0"];
		[totalNumberOfWaves setKeyboardType:UIKeyboardTypeNumberPad];
		totalNumberOfWaves.textColor = [UIColor whiteColor];
		totalNumberOfWaves.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
        
        firstWaveSize = [[UITextField alloc]initWithFrame:CGRectMake(202, 207, 150, 25)];
		[firstWaveSize setDelegate:self];
        [firstWaveSize setPlaceholder:@"0"];
		[firstWaveSize setKeyboardType:UIKeyboardTypeNumberPad];
		firstWaveSize.textColor = [UIColor whiteColor];
		firstWaveSize.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
        
        waveIntervals = [[UITextField alloc]initWithFrame:CGRectMake(187, 267, 150, 25)];
		[waveIntervals setDelegate:self];
        [waveIntervals setPlaceholder:@"0"];
		[waveIntervals setKeyboardType:UIKeyboardTypeNumberPad];
		waveIntervals.textColor = [UIColor whiteColor];
		waveIntervals.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
        
        waveIncrementIncrease = [[UITextField alloc]initWithFrame:CGRectMake(252, 327, 150, 25)];
		[waveIncrementIncrease setDelegate:self];
        [waveIncrementIncrease setPlaceholder:@"0"];
		[waveIncrementIncrease setKeyboardType:UIKeyboardTypeNumberPad];
		waveIncrementIncrease.textColor = [UIColor whiteColor];
		waveIncrementIncrease.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
        
        levelNameLabel = [CCLabelTTF labelWithString:@"Level Name:" fontName:@"WetPaint" fontSize:kFontSize];
        levelNameLabel.anchorPoint = ccp(0,.5f);
        levelNameLabel.position = ccp(-140,200);
        [self addChild:levelNameLabel];
        
        wavesBetweenIncreasesLabel = [CCLabelTTF labelWithString:@"Waves Per Increase:" fontName:@"WetPaint" fontSize:kFontSize];
        wavesBetweenIncreasesLabel.anchorPoint = ccp(0,.5f);
        wavesBetweenIncreasesLabel.position = ccp(-140,140);
        [self addChild:wavesBetweenIncreasesLabel];
        
        totalWavesLabel = [CCLabelTTF labelWithString:@"Total Waves:" fontName:@"WetPaint" fontSize:kFontSize];
        totalWavesLabel.anchorPoint = ccp(0,.5f);
        totalWavesLabel.position = ccp(-140,80);
        [self addChild:totalWavesLabel];
        
        firstWaveSizeLabel = [CCLabelTTF labelWithString:@"First Wave Size:" fontName:@"WetPaint" fontSize:kFontSize];
        firstWaveSizeLabel.anchorPoint = ccp(0,.5f);
        firstWaveSizeLabel.position = ccp(-140,20);
        [self addChild:firstWaveSizeLabel];
        
        waveIntervalLabel = [CCLabelTTF labelWithString:@"Wave Interval:" fontName:@"WetPaint" fontSize:kFontSize];
        waveIntervalLabel.anchorPoint = ccp(0,.5f);
        waveIntervalLabel.position = ccp(-140,-40);
        [self addChild:waveIntervalLabel];
        
        waveIncrementLabel = [CCLabelTTF labelWithString:@"Wave Size Increment:" fontName:@"WetPaint" fontSize:kFontSize];
        waveIncrementLabel.anchorPoint = ccp(0,.5f);
        waveIncrementLabel.position = ccp(-140,-100);
        [self addChild:waveIncrementLabel];
    }
    
    return self;
}

#pragma mark -
#pragma mark Touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   // UITouch *touch = [touches anyObject];
//	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint convertedPoint = [self convertTouchToNodeSpace:[touches anyObject]];        
    CGRect saveRect = [self rectForSprite:saveButton];
    CGRect quitRect = [self rectForSprite:quitButton];
    
    if(CGRectContainsPoint(quitRect,convertedPoint))
    {
        [self close];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(saveRect,convertedPoint))
    {
        [self save];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
     [levelName resignFirstResponder];
     [wavesBetweenIncreases resignFirstResponder];
     [totalNumberOfWaves resignFirstResponder];
     [firstWaveSize resignFirstResponder];
     [waveIntervals resignFirstResponder];
     [waveIncrementIncrease resignFirstResponder];
}

#pragma mark -
#pragma mark Custom level mangement methods

-(void)setLevelToLoadWith:(NSString *)theLevelName
{
    CTLevel *levelToLoad = [[CTLevel alloc]initFromFile:[[FileHelper getCustomLevelsDirectory]stringByAppendingPathComponent:theLevelName]];
        
    [levelName setText:levelToLoad.name];
    [wavesBetweenIncreases setText:[NSString stringWithFormat:@"%i",levelToLoad.wavesBetweenIncrease]];
    [totalNumberOfWaves setText:[NSString stringWithFormat:@"%i",levelToLoad.waveCount]];
    [waveIntervals setText:[NSString stringWithFormat:@"%i",levelToLoad.waveInterval]];
    [waveIncrementIncrease setText:[NSString stringWithFormat:@"%i",levelToLoad.waveIncrementIncrease]];
    [firstWaveSize setText:[NSString stringWithFormat:@"%i",levelToLoad.firstWaveSize]];
    
    [levelToLoad release];
}

-(void)save
{
    if([[levelName text]length]==0 || [[totalNumberOfWaves text]intValue] <=0 || [[waveIntervals text]intValue] <= 0 || [[firstWaveSize text]intValue] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Missing Value(s)" message:@"You must enter a name, total wave count, first wave size, and wave interval value larger than zero." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
    [saveButton runAction:[CCSequence actions:bounce, nil]];
    
    CTLevel *customLevel = [[CTLevel alloc]init];
    
    customLevel.name = [levelName text];
    customLevel.wavesBetweenIncrease = [[wavesBetweenIncreases text]intValue];
    customLevel.waveCount = [[totalNumberOfWaves text]intValue];
    customLevel.waveInterval = [[waveIntervals text]intValue];
    customLevel.waveIncrementIncrease = [[waveIncrementIncrease text]intValue];
    customLevel.firstWaveSize = [[firstWaveSize text]intValue];
    customLevel.bg = [self.delegate getBackground];
    customLevel.data = [self.delegate getLevelString];
    customLevel.levelType = CTLevelCustom;
        
    [customLevel writeToFile:[[FileHelper getCustomLevelsDirectory]stringByAppendingPathComponent:customLevel.name]];

    [customLevel release];
        
    if(self.delegate)[self.delegate didSave];
}

#pragma mark -
#pragma mark display methods

-(void)close
{
    [self hideUI];
    
    id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
    [quitButton runAction:[CCSequence actions:bounce, nil]];
    
    if(self.delegate)[self.delegate didCancel];
}

-(void)show
{
    id move = [CCMoveTo actionWithDuration:.8f position:CGPointMake(self.position.x, 240)];
    [self runAction:[CCSequence actions:move, [CCCallFunc actionWithTarget:self selector:@selector(showUI)], nil]];
}

-(void)hide
{
    [self hideUI];
    
    id move = [CCMoveTo actionWithDuration:.6f position:CGPointMake(self.position.x, 760)];
    [self runAction:move];
}

#pragma mark -
#pragma mark Textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	[textField resignFirstResponder];
	return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark -
#pragma mark UI Visibility Methods

-(void)showUI
{
    [[[CCDirector sharedDirector] openGLView]addSubview:levelName];
    [[[CCDirector sharedDirector] openGLView]addSubview:wavesBetweenIncreases];
    [[[CCDirector sharedDirector] openGLView]addSubview:totalNumberOfWaves];
    [[[CCDirector sharedDirector] openGLView]addSubview:waveIntervals];
    [[[CCDirector sharedDirector] openGLView]addSubview:waveIncrementIncrease];
    [[[CCDirector sharedDirector] openGLView]addSubview:firstWaveSize];
}

-(void)hideUI
{
    [levelName removeFromSuperview];
    [wavesBetweenIncreases removeFromSuperview];
    [totalNumberOfWaves removeFromSuperview];
    [waveIntervals removeFromSuperview];
    [waveIncrementIncrease removeFromSuperview];
    [firstWaveSize removeFromSuperview];
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [firstWaveSize release];
    [levelName release];
    [wavesBetweenIncreases release];
    [totalNumberOfWaves release];
    [waveIntervals release];
    [waveIncrementIncrease release];
    [super dealloc];
}

@end
