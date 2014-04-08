//
//  CreditsMenuLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 8/6/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CreditsMenuLayer.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"

@implementation CreditsMenuLayer

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        back = [CCLabelTTF labelWithString:@"Back" fontName:@"WetPaint" fontSize:28.0f];
        back.position = ccp(280,17);
        [self addChild:back];
    }
    
    return self;
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
    
	CGPoint local1 = [back convertToNodeSpace:touchLocation];
	CGRect r1 = [back textureRect];
    
    if(CGRectContainsPoint(r1, local1))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];      
        id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(leaveToMenu)];
        [back runAction:[CCSequence actions:bounce, callFunc, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
}

-(void)leaveToMenu
{
    [[CCDirector sharedDirector]replaceScene:[MainMenuScene node]];
}

@end
