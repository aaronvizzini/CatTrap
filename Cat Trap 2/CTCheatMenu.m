//
//  CTCheatMenu.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/19/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTCheatMenu.h"
#import "CTGridManager.h"
#import "CTGameDisplayController.h"
#import "CTMouse.h"
#import "CTCat.h"
#import "CTDog.h"
#import "CTGameCenterManager.h"

#define kFontSize 25

@implementation CTCheatMenu
@synthesize grid;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        cheatBox = [[UITextField alloc]initWithFrame:CGRectMake(35, 240, 250, 25)];
		[cheatBox setDelegate:self];
        [cheatBox setPlaceholder:@"Deus ex machina..."];
		cheatBox.textColor = [UIColor blackColor];
        [cheatBox setBackgroundColor:[UIColor whiteColor]];
		cheatBox.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
    }
    
    return self;
}

#pragma mark -
#pragma mark Touch Method

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [cheatBox removeFromSuperview];
    [cheatBox resignFirstResponder];
}

#pragma mark -
#pragma mark Display Method

-(void)show
{
    [[[CCDirector sharedDirector]openGLView]addSubview:cheatBox];
}

#pragma mark -
#pragma mark Cheat Method

-(void)_didEnterCheat:(CTCheat)cheatType
{
    if(cheatType == CTHealth)
    {
        [self.grid.mouse setLivesLeft:1];
        [self.grid.mouse setLivesLeft:2];
        [self.grid.mouse setLivesLeft:3];
        [self.grid.mouse setLivesLeft:4];
        [self.grid.mouse setLivesLeft:5];
        //[self.grid.gameDisplayController setMouseLives:5];
    }
    
    else if(cheatType == CTDogCall)
    {
        CTDog *dog = [[CTDog alloc]initWithOwningGrid:self.grid];
        CGPoint randomLocation = [self.grid getRandomEmptyLocation];
        dog.location = randomLocation;
        dog.position = [self.grid positionForLocation:CGPointMake(randomLocation.y,randomLocation.x)];
        [self.grid addChild:dog z:10];
        [self.grid.pushables addObject:dog];
        dog.scale = 0.0f;
        
        id dogAppearAction = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
        [dog runAction:dogAppearAction];
        
        [dog startAI];
        [dog release];
    }
    
    else if(cheatType == CTInvisible)
    {
        [self.grid.mouse makeInvincibleForever];
    }
    
    else if(cheatType == CTAllToCheese)
    {
        for(CTCat *cat in self.grid.cats)
        {
            [cat turnToCheese];
        }
    }
    
    if(cheatType == CTHealth || cheatType == CTDogCall || cheatType == CTInvisible || cheatType == CTAllToCheese)
    {
        CTGameCenterManager *gcm = [[CTGameCenterManager alloc]init];
        [gcm submitAchievementId:kDeusExMachina fullName:@"Deus Ex Machina"];
        [gcm release];
    }
}

#pragma mark -
#pragma mark Textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	[textField resignFirstResponder];
    [textField setText:[textField.text capitalizedString]];
    
    if([textField.text isEqualToString:@"Calcium"])[self _didEnterCheat:CTHealth];
    if([textField.text isEqualToString:@"Spike"])[self _didEnterCheat:CTDogCall];
    if([textField.text isEqualToString:@"Stealth"])[self _didEnterCheat:CTInvisible];
    if([textField.text isEqualToString:@"Curdle"])[self _didEnterCheat:CTAllToCheese];
    
    [textField setText:@""];
    
    [cheatBox removeFromSuperview];
    
	return YES;
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [cheatBox removeFromSuperview];
    [cheatBox release];
    [super dealloc];
}

@end
