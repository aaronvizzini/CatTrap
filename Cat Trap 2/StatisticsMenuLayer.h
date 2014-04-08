//
//  StatisticsMenuLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/26/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CCLayer.h"
#import "Cocos2d.h"

@interface StatisticsMenuLayer : CCLayer <UIAlertViewDelegate>
{
    CCLabelTTF *title;
    CCLabelTTF *totalCheese;
    CCLabelTTF *totalDeaths;
    CCLabelTTF *totalDistance;
    CCLabelTTF *deathsByTrap;
    CCLabelTTF *deathsByFire;
    CCLabelTTF *deathsByCat;
    CCLabelTTF *totalTime;
    CCLabelTTF *cheesePerMin;
    CCLabelTTF *distancePerMin;
    CCLabelTTF *deathsPerMin;
    
    CCLabelTTF *menuButton;
    CCLabelTTF *resetStatsButton;
    
    UIAlertView *resetAlert;
}

-(void)resetStatistics;

@end
