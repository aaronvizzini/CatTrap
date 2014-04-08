//
//  CTSprite.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CTElement;
@class CTSprite;
@class CTGridManager;

typedef enum {CTNorth, CTSouth, CTEast, CTWest} CTDirection;

@interface CTSprite : CCSprite 
{    
    CGPoint location;
    CTGridManager *grid;
}
@property(readwrite)CGPoint location;
@property(readonly)CTGridManager *grid;

-(id)initWithOwningGrid:(CTGridManager *)theGrid;

-(bool)isWallInDirection:(CTDirection)direction;
-(bool)move:(CTDirection)direction;
-(CTElement *)getElementInDirection:(CTDirection)direction;

@end
