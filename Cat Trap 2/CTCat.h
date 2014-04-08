//
//  CTCat.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPushable.h"

@class CTGridManager;

typedef enum{CTTopRight, CTTopLeft, CTBottomRight, CTBottomLeft}CTDiagonolDirection;

@interface CTCat : CTPushable 
{    
    @private
    CTPushable *northEastPushable;
    CTPushable *northWestPushable;
    CTPushable *southEastPushable;
    CTPushable *southWestPushable;
}

-(void)startAI;
-(void)pauseAI;
-(void)makeDecision;
-(bool)canMove;
-(bool)diagonolDecision;

-(void)diagonolMove:(CTDiagonolDirection)direction;

-(bool)shouldBecomeCheese;
-(void)turnToCheese;

-(void)animateOut;
-(void)animateIn;

@end
