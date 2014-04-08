//
//  CTElement.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSprite.h"

typedef enum {CTCatElement, CTBlockElement, CTObstacleElement} CTElementType;

@interface CTElement : CTSprite 
{
    CTElementType elementType;
}
@property(readwrite)CTElementType elementType;

-(bool)pushableInDirection:(CTDirection)direction;

@end
