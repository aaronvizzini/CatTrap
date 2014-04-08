//
//  CTSurvivalIcon.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/22/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTSurvivalIcon.h"
#import "SimpleAudioEngine.h"

#define kBoneOneZ 2
#define kBoneTwoZ 3
#define kSkullZ 4
#define kMouseHeadZ 5
#define kTextZ 2
#define kTextBubbleZ 1

@implementation CTSurvivalIcon

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.scale = .70;
        
        self.isTouchEnabled = YES;
                        
        mouseHead = [CCSprite spriteWithFile:@"mouseHead.png"];
        mouseHead.position = ccp(3,4);
        [self addChild:mouseHead z:kMouseHeadZ];
        
        survivalText= [CCSprite spriteWithFile:@"survivalText.png"];
        survivalText.position = ccp(0,-100);
        [self addChild:survivalText z:kTextZ];
        
        textBubble = [CCSprite spriteWithFile:@"menuTextBubble.png"];
        textBubble.scaleX = 0.75f;
        textBubble.scaleY = 1.0f;
        textBubble.position = ccp(0,-99);
        [self addChild:textBubble z:kTextBubbleZ];
        
        boneOne = [CCSprite spriteWithFile:@"boneTwo.png"];
        boneOne.position = ccp(-160,-120);
        [boneOne setOpacity:0.0f];
        [self addChild:boneOne z:kBoneOneZ];
        
        boneTwo = [CCSprite spriteWithFile:@"boneOne.png"];
        boneTwo.position = ccp(160,-120);
        [boneTwo setOpacity:0.0f];
        [self addChild:boneTwo z:kBoneTwoZ];
        
        skull = [CCSprite spriteWithFile:@"skull.png"];
        skull.position = ccp(0,0);
        [self addChild:skull z:kSkullZ];
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
	CGPoint local = [mouseHead convertToNodeSpace:touchLocation];
	CGRect r = [mouseHead textureRect];
    
    if(CGRectContainsPoint(r,local))
    {
        [self animateIn];
    }
}

#pragma mark -
#pragma mark animation methods

-(void)animateIn
{
    id headFadeOut = [CCFadeOut actionWithDuration:0.8f];
    id delay = [CCDelayTime actionWithDuration:.7f];
    id delay2 = [CCDelayTime actionWithDuration:.6f];
    id boneOneMove = [CCMoveTo actionWithDuration:0.5f position:ccp(0,0)];
    id boneTwoMove = [CCMoveTo actionWithDuration:0.5f position:ccp(0,0)];
    id boneFadeIn = [CCFadeIn actionWithDuration:.6f];
    id boneFadeIn2 = [CCFadeIn actionWithDuration:.6f];
    
    [mouseHead runAction:headFadeOut];
    
    [boneOne runAction:[CCSequence actions:delay, boneFadeIn, nil]];
    [boneTwo runAction:[CCSequence actions:delay2, boneFadeIn2, nil]];
    
    [boneOne runAction:[CCSequence actions:delay, boneOneMove, nil]];
    [boneTwo runAction:[CCSequence actions:delay2, boneTwoMove, nil]];
    
    id callAction = [CCCallFunc actionWithTarget:self selector:@selector(performAction)];
    id callActionDelay = [CCDelayTime actionWithDuration:1.2f];
    
    [self runAction:[CCSequence actions:callActionDelay, callAction, nil]];
    
    [self performSelector:@selector(_playSFX) withObject:nil afterDelay:1.1f];
}

-(void)performAction
{
    [currentTarget performSelector:currentSelector];
}

#pragma mark -
#pragma mark Audio SFX method

-(void)_playSFX
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Survival_Button.wav"];
}

#pragma mark -
#pragma mark clean up

-(void)dealloc
{
    [super dealloc];
}

@end
