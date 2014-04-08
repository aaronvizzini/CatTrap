//
//  SpriteRect.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/28/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCLayer (SpriteRect)

-(CGRect)rectForSprite:(CCSprite *)sprite;

@end
