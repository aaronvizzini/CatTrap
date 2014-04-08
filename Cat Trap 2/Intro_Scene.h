//
//  Intro_Scene.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 10/16/09.
//  Modified by Aaron Vizzini on 6/1/11.
//  Copyright 2009 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Intro_Scene : CCScene 
{
	CCSprite *logo;
	CCLabelTTF *label;
}
-(void)changeScene;
@end
