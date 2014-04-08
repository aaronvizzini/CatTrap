//
//  CTSettingsIcon.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 5/22/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocos2d.h"

@interface CTSettingsIcon : CCLayer 
{
    CCSprite *gear;
    
    id currentTarget;
    SEL currentSelector;
}

-(void)setTarget:(id)target andSelector:(SEL)selector;
-(void)animate;
-(void)performAction;
-(void)reset;

@end
