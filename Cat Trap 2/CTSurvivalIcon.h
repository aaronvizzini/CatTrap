//
//  CTSurvivalIcon.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/22/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocos2d.h"

@interface CTSurvivalIcon : CCLayer 
{
    CCSprite *mouseHead;
    CCSprite *survivalText;
    CCSprite *boneOne;
    CCSprite *boneTwo;
    CCSprite *skull;
    CCSprite *textBubble;
    
    id currentTarget;
    SEL currentSelector;
}

-(void)setTarget:(id)target andSelector:(SEL)selector;
-(void)animateIn;
-(void)performAction;

@end
