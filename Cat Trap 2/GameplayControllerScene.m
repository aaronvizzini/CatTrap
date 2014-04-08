//
//  GameplayControllerScene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/10/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "GameplayControllerScene.h"

#import "GameplayController.h"

@implementation GameplayControllerScene

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"gameBG.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
        
        gameplayController = [GameplayController node];
		[self addChild:gameplayController];
    }
    
    return self;
}

#pragma mark -
#pragma mark Load Method

-(void)loadLevel:(CTLevel *)level
{
    [gameplayController loadLevel:level];
}

@end
