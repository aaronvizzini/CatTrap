//
//  CTCat.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTElement.h"

@class CTGridManager;

@interface CTCat : CTElement 
{
    bool isCheese;
}
@property(readwrite)bool isCheese;

-(void)makeDecision;

-(void)turnToCheese;
-(void)animateOut;
-(void)animateIn;

@end
