//
//  StatisticsMenuScene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/26/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "StatisticsMenuScene.h"

#import "StatisticsMenuLayer.h"

@implementation StatisticsMenuScene

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"blankBackground.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
		
		[self addChild: [StatisticsMenuLayer node]];
    }
    
    return self;
}

@end
