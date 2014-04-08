//
//  CTGridManager.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCArray.h"
#import "CTSprite.h"
#import "CTMouse.h"
#import "CTElement.h"

#define kGridSize 17
#define kGridBlockSize 18.5

@interface CTGridManager : CCLayer 
{
    CGPoint mousePoint;
    CCArray *elements;
    CCArray *cats;
    
    CTMouse *mouse;
    
    int size;
    double blockSize;
}
@property(readonly)CGPoint mousePoint;
@property(readonly)CCArray *cats, *elements;
@property(readonly)CTMouse *mouse;
@property(readonly)int size;
@property(readonly)double blockSize;

-(id)initWithLevelString:(NSString *)levelString;

-(bool)isLocationOccupied:(CGPoint)location;

-(CTElement *)getElementForLocation:(CGPoint)location;

@end
