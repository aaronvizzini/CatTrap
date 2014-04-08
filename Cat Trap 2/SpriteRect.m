//
//  SpriteRect.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/28/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "SpriteRect.h"

@implementation CCLayer (SpriteRect)

-(CGRect)rectForSprite:(CCSprite *)sprite
{
    return CGRectMake(sprite.position.x-sprite.contentSize.width/2, sprite.position.y-sprite.contentSize.height/2, sprite.contentSize.width, sprite.contentSize.height);
}

@end
