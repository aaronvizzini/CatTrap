//
//  BackgroundSelectMenu.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/9/11.
//  Copyright 2011 Alernative Visuals. All rights reserved.
//

#import "BackgroundSelectMenu.h"

#define kBgSize 40

@implementation BackgroundSelectMenu
@synthesize delegate;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        [self addChild:[CCSprite spriteWithFile:@"blankBackground.png"]];
        
        self.isTouchEnabled = YES;
        
        woodBg = [CCSprite spriteWithFile:@"BG_Wood.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];
        metalBg = [CCSprite spriteWithFile:@"BG_Metal.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];  
        discoBg = [CCSprite spriteWithFile:@"BG_Disco.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];
        grassBg = [CCSprite spriteWithFile:@"BG_Grass.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];
        
        ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        
        [woodBg.texture setTexParameters: &params];
        woodBg.position = ccp(-120, -213);
        [self addChild:woodBg];
        
        [metalBg.texture setTexParameters: &params];
        metalBg.position = ccp(-40, -213);
        [self addChild:metalBg];
        
        [discoBg.texture setTexParameters: &params];
        discoBg.position = ccp(40, -213);
        [self addChild:discoBg];
        
        [grassBg.texture setTexParameters: &params];
        grassBg.position = ccp(120, -213);
        [self addChild:grassBg];
        
        [self setPosition:ccp(160, 760)];
    }
    
    return self;
}

#pragma mark -
#pragma mark Touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
	CGPoint local1 = [woodBg convertToNodeSpace:touchLocation];
	CGRect r1 = [woodBg textureRect];
    
    CGPoint local2 = [metalBg convertToNodeSpace:touchLocation];
	CGRect r2 = [metalBg textureRect];
    
    CGPoint local3 = [discoBg convertToNodeSpace:touchLocation];
	CGRect r3 = [discoBg textureRect];
    
    CGPoint local4 = [grassBg convertToNodeSpace:touchLocation];
	CGRect r4 = [grassBg textureRect];
    
    if(CGRectContainsPoint(r1, local1))
    {
        if(self.delegate)[self.delegate didChooseBackground:CTWoodBackground];
    }
    
    else if(CGRectContainsPoint(r2, local2))
    {
        if(self.delegate)[self.delegate didChooseBackground:CTMetalBackground];
    }
    
    else if(CGRectContainsPoint(r3, local3))
    {
        if(self.delegate)[self.delegate didChooseBackground:CTDiscoBackground];
    }
    
    else if(CGRectContainsPoint(r4, local4))
    {
        if(self.delegate)[self.delegate didChooseBackground:CTGrassBackground];
    }
}

#pragma mark -
#pragma mark Display methods

-(void)show
{
    id move = [CCMoveTo actionWithDuration:.8f position:CGPointMake(self.position.x, 663)];
    [self runAction:move];
}

-(void)hide
{
    id move = [CCMoveTo actionWithDuration:.6f position:CGPointMake(self.position.x, 760)];
    [self runAction:move];
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [super dealloc];
}

@end
