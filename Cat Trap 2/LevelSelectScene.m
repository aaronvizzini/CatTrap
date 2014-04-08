//
//  LevelSelect.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/30/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "LevelSelectScene.h"

#import "LevelSelectLayer.h"

@implementation LevelSelectScene

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"levelSelectBG.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
		
		[self addChild: [LevelSelectLayer node]];
    }
    
    return self;
}

@end
