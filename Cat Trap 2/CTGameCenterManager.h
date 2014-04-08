//
//  CTGameCenterManager.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/26/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "CTGameCenterDefines.h"

@interface CTGameCenterManager : NSObject <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate>
{
    UIViewController *tempController;
    NSMutableDictionary* earnedAchievementCache;
}
@property (retain) NSMutableDictionary* earnedAchievementCache;

-(void)submitScore:(int)score forLeaderboard:(NSString *)leaderboardId displayMessage:(BOOL)messageWillShow;
-(void)submitAchievementId:(NSString *)ach fullName:(NSString *)name;

-(void)reloadHighScoresForCategory: (NSString*) category;

-(void)showLeaderBoardWithId:(NSString *)leaderboardId;
-(void)showAchievments;

-(void)resetAchievements;

@end
