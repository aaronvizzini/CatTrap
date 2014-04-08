//
//  CTSettingsIcon.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/22/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTSettingsIcon.h"
#import "SimpleAudioEngine.h"

@implementation CTSettingsIcon

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil) 
    {
        self.isTouchEnabled = YES;
        
        gear = [CCSprite spriteWithFile:@"gear.png"];
        gear.position = ccp(0,0);
        [self addChild:gear];
    }
    
    return self;
}

#pragma mark -
#pragma mark target/action method

-(void)setTarget:(id)target andSelector:(SEL)selector
{
    currentTarget = target;
    currentSelector = selector;
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
	CGPoint local = [gear convertToNodeSpace:touchLocation];
	CGRect r = [gear textureRect];
    
    if(CGRectContainsPoint(r,local))
    {
        [self animate];
    }
}

#pragma mark -
#pragma mark animation method

-(void)animate
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Option_Button.wav"];
    id animOne = [CCRotateTo actionWithDuration:1.0f angle:900];
    id animTwo = [CCMoveTo actionWithDuration:1.0f position:ccp(0,-60)];
    [gear runAction:animOne];
    [gear runAction:animTwo];
    
    id callAction = [CCCallFunc actionWithTarget:self selector:@selector(performAction)];
    id callActionDelay = [CCDelayTime actionWithDuration:1.1f];
    
    [self runAction:[CCSequence actions:callActionDelay, callAction, nil]];
}

-(void)performAction
{
    [currentTarget performSelector:currentSelector];
}

-(void)reset
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Option_Button.wav"];
    id animOne = [CCRotateTo actionWithDuration:1.0f angle:-900];
    id animTwo = [CCMoveTo actionWithDuration:1.0f position:ccp(0,0)];
    [gear runAction:animOne];
    [gear runAction:animTwo];
}

#pragma mark -
#pragma mark clean up

-(void)dealloc
{
    [super dealloc];
}

@end
