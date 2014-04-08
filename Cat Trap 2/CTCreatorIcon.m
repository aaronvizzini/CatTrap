//
//  CTCreatorIcon.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/25/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTCreatorIcon.h"
#import "SimpleAudioEngine.h"

#define kStandardZ 2
#define kTextBubbleZ 1

@implementation CTCreatorIcon

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.isTouchEnabled = YES;
        self.scale = .75f;
        
        hammer = [CCSprite spriteWithFile:@"hammer.png"];
        hammer.position = ccp(4,-13);
        hammer.rotation = -45;
        [self addChild:hammer z:kStandardZ];
        
        nail = [CCSprite spriteWithFile:@"nail.png"];
        nail.position = ccp(-70,-45);
        [self addChild:nail z:kStandardZ];
        
        text = [CCSprite spriteWithFile:@"creatorText.png"];
        text.position = ccp(0,-85);
        [self addChild:text z:kStandardZ];
        
        textBubble = [CCSprite spriteWithFile:@"menuTextBubble.png"];
        textBubble.scaleX = 1.0f;
        textBubble.scaleY = .9f;
        textBubble.position = ccp(0,-86);
        [self addChild:textBubble z:kTextBubbleZ];
    }
    
    return self;
}

#pragma mark -
#pragma mark Target/Action method

-(void)setTarget:(id)target andSelector:(SEL)selector
{
    currentTarget = target;
    currentSelector = selector;
}

#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
	CGPoint local = [hammer convertToNodeSpace:touchLocation];
	CGRect r = [hammer textureRect];
    CGRect r1 = [nail textureRect];
    
    if(CGRectContainsPoint(r,local) || CGRectContainsPoint(r1,local))
    {
        [self animateIn];
    }
}

#pragma mark -
#pragma mark animation methods

-(void)animateIn
{
    id hammerAnim = [CCRotateTo actionWithDuration:.5f angle:-90];
    id hammerBounceAnim = [CCEaseBounceOut actionWithAction:hammerAnim];
    
    id nailDelay = [CCDelayTime actionWithDuration:.1f];
    id nailDelay2 = [CCDelayTime actionWithDuration:.1f];
    id moveNail = [CCMoveTo actionWithDuration:.1f position:ccp(-70,-61)];
    id nailAnim = [CCScaleTo actionWithDuration:.1f scaleX:1.0f scaleY:.2f];
    
    [hammer runAction:hammerBounceAnim];
    [nail runAction:[CCSequence actions:nailDelay2, moveNail, nil]];
    [nail runAction:[CCSequence actions:nailDelay, nailAnim, nil]];
    
    id callAction = [CCCallFunc actionWithTarget:self selector:@selector(performAction)];
    id callActionDelay = [CCDelayTime actionWithDuration:.6f];
    
    [self runAction:[CCSequence actions:callActionDelay, callAction, nil]];
    
    [self performSelector:@selector(_playSFX) withObject:nil afterDelay:.2f];
}

-(void)performAction
{
    [currentTarget performSelector:currentSelector];
}

#pragma mark -
#pragma mark Sound Method

-(void)_playSFX
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Creator_Button.wav"];
}

#pragma mark -
#pragma mark clean up

-(void)dealloc
{
    [super dealloc];
}

@end
