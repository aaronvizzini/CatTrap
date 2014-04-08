//
//  CTChallengeIcon.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/24/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CTChallengeIcon : CCLayer 
{
    CCSprite *puzzelOne;
    CCSprite *puzzelTwo;
    CCSprite *puzzelThree;
    CCSprite *puzzelText;
    CCSprite *textBubble;
    
    id currentTarget;
    SEL currentSelector;
}

-(void)setTarget:(id)target andSelector:(SEL)selector;
-(void)animateIn;
-(void)animateOut;
-(void)performAction;

@end