//
//  CustomLevelMenuScene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/13/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CustomLevelMenuScene.h"

#import "CustomLevelMenuLayer.h"

@implementation CustomLevelMenuScene

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"blankBackground.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
		
		[self addChild: [CustomLevelMenuLayer node]];
    }
    
    return self;
}

@end
