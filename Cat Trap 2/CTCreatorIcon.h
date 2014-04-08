//
//  CTCreatorIcon.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/25/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CTCreatorIcon : CCLayer 
{
    CCSprite *hammer;
    CCSprite *nail;
    CCSprite *text;
    CCSprite *textBubble;
    
    id currentTarget;
    SEL currentSelector;
}

-(void)setTarget:(id)target andSelector:(SEL)selector;
-(void)animateIn;
-(void)performAction;

@end