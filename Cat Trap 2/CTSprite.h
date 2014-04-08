//
//  CTSprite.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CTPushable;
@class CTSprite;
@class CTGridManager;

typedef enum {CTNorth, CTSouth, CTEast, CTWest} CTDirection;
typedef enum {CTMouseTrapElement, CTStickyTrapElement, CTPortalElement, CTDogTriggerElement, CTCatPushable, CTDogPushable, CTBasicBlockPushable, CTSolidBlockPushable, CTLeadBlockPushable, CTFishBlockPushable, CTFireBlockPushable, CTTNTBlockPushable}CTSpriteType;

@interface CTSprite : CCSprite 
{    
    CGPoint location;
    CTGridManager *grid;
    CTSpriteType spriteType;
}
@property(readwrite)CGPoint location;
@property(readonly)CTGridManager *grid;
@property(readwrite)CTSpriteType spriteType;

-(id)initWithOwningGrid:(CTGridManager *)theGrid;

-(bool)isWallInDirection:(CTDirection)direction;
-(bool)move:(CTDirection)direction;
-(CTPushable *)getPushableInDirection:(CTDirection)direction;

@end
