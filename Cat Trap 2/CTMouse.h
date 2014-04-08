//
//  CTMouse.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSprite.h"

@class CTGridManager;

@interface CTMouse : CTSprite 
{
    int livesLeft;
    bool canMove;
    bool isInvincible;
    CCParticleFire *fire;
    
    int totalDeaths;
    int totalDistance;
    int trapDeaths;
    int catDeaths;
    int fireDeaths;
}

@property(readwrite)int livesLeft;
@property(readwrite)bool canMove;

-(void)assessLcoation;

-(void)needsToDie;
-(void)needsToBurn;
-(void)stickyTrapped;
-(void)untrap;
-(void)reset;

-(void)makeInvincible;
-(void)makeInvincibleForever;
-(void)makeUnInvincible;

@end
