//
//  LevelCreator.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/3/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "LevelCreatorScene.h"

#import "LevelCreatorLayer.h"

@implementation LevelCreatorScene

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"levelCreatorBG.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
		
        creatorLayer = [LevelCreatorLayer node];
        
		[self addChild: creatorLayer];
    }
    
    return self;
}

#pragma mark -
#pragma mark Edit Method

-(void)editLevelWithName:(NSString *)levelName
{
    [creatorLayer editLevelWithName:levelName];
}

@end
