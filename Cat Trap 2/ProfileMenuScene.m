//
//  ProfileMenuScene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/24/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "ProfileMenuScene.h"

#import "ProfileMenuLayer.h"

@implementation ProfileMenuScene

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"profileMenuBg.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
		
		[self addChild: [ProfileMenuLayer node]];
    }
    
    return self;
}

@end
