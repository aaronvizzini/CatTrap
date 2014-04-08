//
//  GameplayController.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTGridManager.h"
#import "cocos2d.h"

@interface GameplayController : CCLayer 
{
    CTGridManager *grid;
    CGPoint touchStartPoint;
    
    bool isTouchHeld;
}

-(void)moveUp;
-(void)moveDown;
-(void)moveRight;
-(void)moveLeft;

@end
