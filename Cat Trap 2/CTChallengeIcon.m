//
//  CTChallengeIcon.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/24/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTChallengeIcon.h"
#import "SimpleAudioEngine.h"


@implementation CTChallengeIcon

#define kPuzzlePieceZ 2
#define kTextBubbleZ 1

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil) 
    {
        self.scale = .65f;
        self.isTouchEnabled = YES;
        
        puzzelOne= [CCSprite spriteWithFile:@"puzzleOne.png"];
        puzzelOne.position = ccp(-50,0);//-35,0
        [puzzelOne setOpacity:0];
        puzzelOne.scale = 2.0f;
        [self addChild:puzzelOne z:kPuzzlePieceZ];
        
        puzzelTwo = [CCSprite spriteWithFile:@"puzzleTwo.png"];
        puzzelTwo.position = ccp(50,0);//35,0
        [puzzelTwo setOpacity:0];
        puzzelTwo.scale = 2.0f;
        [self addChild:puzzelTwo z:kPuzzlePieceZ];
        
        puzzelThree = [CCSprite spriteWithFile:@"puzzleThree.png"];
        puzzelThree.position = ccp(-35,105);//-35, 70
        [puzzelThree setOpacity:0];
        puzzelThree.scale = 2.0f;
        [self addChild:puzzelThree z:kPuzzlePieceZ];
        
        puzzelText = [CCSprite spriteWithFile:@"puzzleText.png"];
        puzzelText.position = ccp(0,-75);
        [self addChild:puzzelText z:kPuzzlePieceZ];
        
        textBubble = [CCSprite spriteWithFile:@"menuTextBubble.png"];
        textBubble.scaleX = 1.2f;
        textBubble.scaleY = 1.1f;
        textBubble.position = ccp(0,-74);
        [self addChild:textBubble z:kTextBubbleZ];
        
        [self performSelector:@selector(animateIn) withObject:nil afterDelay:.5f];
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
	CGPoint local = [puzzelOne convertToNodeSpace:touchLocation];
    CGPoint local1 = [puzzelTwo convertToNodeSpace:touchLocation];
    CGPoint local2 = [puzzelThree convertToNodeSpace:touchLocation];
	CGRect r = [puzzelOne textureRect];
    CGRect r1 = [puzzelTwo textureRect];
    CGRect r2 = [puzzelThree textureRect];
    
    if(CGRectContainsPoint(r,local) || CGRectContainsPoint(r1,local1) || CGRectContainsPoint(r2,local2))
    {
        [self animateOut];
    }
}

#pragma mark -
#pragma mark animation methods

-(void)animateIn
{
    id puzzleOneScale = [CCScaleTo actionWithDuration:.8f scale:1.0f];
    id puzzleTwoScale = [CCScaleTo actionWithDuration:1.1f scale:1.0f];
    id puzzleThreeScale = [CCScaleTo actionWithDuration:1.4f scale:1.0f];
    
    id puzzleOneFade = [CCFadeIn actionWithDuration:.8f];
    id puzzleTwoFade = [CCFadeIn actionWithDuration:1.1f];
    id puzzleThreeFade = [CCFadeIn actionWithDuration:1.4f];
    
    [puzzelOne runAction:puzzleOneScale];
    [puzzelTwo runAction:puzzleTwoScale];
    [puzzelThree runAction:puzzleThreeScale];
    
    [puzzelOne runAction:puzzleOneFade];
    [puzzelTwo runAction:puzzleTwoFade];
    [puzzelThree runAction:puzzleThreeFade];
}

-(void)animateOut
{
    id puzzleOneMove = [CCMoveTo actionWithDuration:.5f position:ccp(-35,0)];
    id puzzleTwoMove = [CCMoveTo actionWithDuration:.5f position:ccp(35,0)];
    id puzzleThreeMove = [CCMoveTo actionWithDuration:.5f position:ccp(-35, 70)];
    
    [puzzelOne runAction:puzzleOneMove];
    [puzzelTwo runAction:puzzleTwoMove];
    [puzzelThree runAction:puzzleThreeMove];
    
    id callAction = [CCCallFunc actionWithTarget:self selector:@selector(performAction)];
    id callActionDelay = [CCDelayTime actionWithDuration:.6f];
    
    [self runAction:[CCSequence actions:callActionDelay, callAction, nil]];
    
    [self performSelector:@selector(_playSFX) withObject:nil afterDelay:.5f];
}

-(void)performAction
{
    [currentTarget performSelector:currentSelector];
}

#pragma mark -
#pragma mark Sound Method

-(void)_playSFX
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Challenge_Button.wav"];
}

#pragma mark -
#pragma mark clean up

-(void)dealloc
{
    [super dealloc];
}

@end

