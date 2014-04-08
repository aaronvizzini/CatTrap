//
//  BackgroundSelectMenu.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "CTGridManager.h"

@protocol BackgroundSelectMenuDelegate <NSObject>

@required
-(void)didChooseBackground:(CTBackgroundType)bgSelected;

@end

@interface BackgroundSelectMenu : CCLayer
{
    CCSprite *woodBg;
    CCSprite *metalBg;
    CCSprite *discoBg;
    CCSprite *grassBg;
    
    id delegate;
}
@property(assign)id <BackgroundSelectMenuDelegate> delegate;

-(void)show;
-(void)hide;

@end
