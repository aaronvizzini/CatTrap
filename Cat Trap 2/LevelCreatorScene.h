//
//  LevelCreator.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/3/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class LevelCreatorLayer;

@interface LevelCreatorScene : CCScene 
{
    LevelCreatorLayer *creatorLayer;
}

-(void)editLevelWithName:(NSString *)levelName;

@end
