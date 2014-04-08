//
//  GameplayControllerScene.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/10/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocos2d.h"

@class CTLevel;
@class GameplayController;

@interface GameplayControllerScene : CCScene 
{
    GameplayController *gameplayController;
}

-(void)loadLevel:(CTLevel *)level;

@end
