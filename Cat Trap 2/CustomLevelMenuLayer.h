//
//  CustomLevelMenuLayer.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/13/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface CustomLevelMenuLayer : CCLayer <UITableViewDelegate, UITableViewDataSource, GKSessionDelegate, GKPeerPickerControllerDelegate>
{
    UITableView *table;
    NSMutableArray *customLevels;
    
	GKSession *currentSession;
    GKPeerPickerController *thePicker;

    CCLabelTTF *newLevel;
    CCLabelTTF *share;
    CCLabelTTF *edit;
    CCLabelTTF *remove;
    CCLabelTTF *connection;
    CCLabelTTF *menu;
}
@property (nonatomic, retain) GKSession *currentSession;

-(void)loadCustomLevels;
-(void)playLevelAction:(id)sender forEvent:(UIEvent *)event;

-(void)newCustomLevel;
-(void)shareCustomLevel;
-(void)editCustomLevel;
-(void)deleteCustomLevel;
-(void)connectToBluetooth;

-(void) btnSend;
-(void) btnConnect;
-(void) btnDisconnect;

@end
