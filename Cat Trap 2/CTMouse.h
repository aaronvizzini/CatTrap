//
//  CTMouse.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSprite.h"
@class CTGridManager;

@interface CTMouse : CTSprite 
{
    int livesLeft;
}
@property(readwrite)int livesLeft;

-(void)needsToDie;
-(void)assessLcoation;

@end
