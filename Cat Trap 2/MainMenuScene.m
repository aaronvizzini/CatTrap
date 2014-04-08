//
//  MainMenuScene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/22/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "MainMenuScene.h"

#import "MainMenuLayer.h"

@implementation MainMenuScene

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"mainMenuBG.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
		
		[self addChild: [MainMenuLayer node]];
    }
    
    return self;
}

@end
