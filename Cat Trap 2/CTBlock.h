//
//  CTBlock.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTElement.h"

@class CTGridManager;

@interface CTBlock : CTElement 
{
}
-(bool)pushableInDirection:(CTDirection)direction;

@end
