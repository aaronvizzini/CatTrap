//
//  GameplayControllerScene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/10/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GameplayControllerScene.h"


@implementation GameplayControllerScene

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"conceptGameBG.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
		
		[self addChild: [GameplayController node]];
    }
    
    return self;
}

@end
