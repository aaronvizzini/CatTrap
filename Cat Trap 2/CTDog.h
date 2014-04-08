//
//  CTDog.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/20/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPushable.h"

@class CTGridManager;
@class CTCat;

@interface CTDog : CTPushable 
{
    
}

-(void)startAI;
-(void)pauseAI;
-(void)endExistance;
-(void)makeDecision;
-(void)animateOut;
-(void)animateIn;

-(CTCat *)getNearestCat;

@end
