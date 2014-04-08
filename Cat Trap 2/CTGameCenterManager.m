//
//  CTGameCenterManager.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/26/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTGameCenterManager.h"
#import "cocos2d.h"

@implementation CTGameCenterManager
@synthesize  earnedAchievementCache;

#pragma mark - 
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        earnedAchievementCache= NULL;
        tempController = [[UIViewController alloc]init];
        [[[CCDirector sharedDirector]openGLView]addSubview:tempController.view];
    }
    
    return self;
}

#pragma mark -
#pragma mark Leaderboard Methods

-(void)submitScore:(int)score forLeaderboard:(NSString *)leaderboardId displayMessage:(BOOL)messageWillShow
{
    GKScore *scoreSubmitter = [[[GKScore alloc]initWithCategory:leaderboardId]autorelease];
    scoreSubmitter.value = score;
    [scoreSubmitter reportScoreWithCompletionHandler:^(NSError *error) 
    {
        if(error.code ==  GKErrorNotAuthenticated)
        {
            //Not Authenticated
        }
        
        else if(!error && messageWillShow)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Score Submitted!" message:@"Your score has been successfully submitted to Game Center." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    
    [self reloadHighScoresForCategory:leaderboardId];
}

-(void)showLeaderBoardWithId:(NSString *)leaderboardId
{        
    if(![[GKLocalPlayer localPlayer]isAuthenticated])
    {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            if(error == nil)
            {
                //Good
            }
            
            else
            {
                //bad
            }
        }];
        
        return;
    }
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc]init];
    leaderboardController.leaderboardDelegate = self;
    leaderboardController.category = leaderboardId;
    leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
    [tempController presentModalViewController:leaderboardController animated:YES];
}

-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [tempController dismissModalViewControllerAnimated:YES];
}

- (void) reloadHighScoresForCategory: (NSString*) category
{
	GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] init] autorelease];
	leaderBoard.category= category;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
     {
     }];
}

#pragma mark -
#pragma mark Acheivement Methods

-(void)submitAchievementId:(NSString *)ach fullName:(NSString *)name;
{
    double percentComplete = 100.0;
    
    if(self.earnedAchievementCache == NULL)
	{
		[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
         {
             if(error == NULL)
             {
                 NSMutableDictionary *tempCache= [NSMutableDictionary dictionaryWithCapacity: [scores count]];
                 for (GKAchievement *score in scores)
                 {
                     [tempCache setObject: score forKey: score.identifier];
                 }
                 self.earnedAchievementCache = tempCache;
                 [self submitAchievementId:ach fullName:name];
             }
             else
             {
      
             }
             
         }];
	}
    
	else
	{
		GKAchievement* achievement= [self.earnedAchievementCache objectForKey: ach];
        
		if(achievement != NULL)
		{
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete))
			{
				achievement= NULL;
			}
			achievement.percentComplete = percentComplete;
		}
        
		else
		{
			achievement= [[[GKAchievement alloc] initWithIdentifier: ach] autorelease];
			achievement.percentComplete = percentComplete;
			[self.earnedAchievementCache setObject: achievement forKey: achievement.identifier];
		}
        
		if(achievement!= NULL)
		{
			[achievement reportAchievementWithCompletionHandler: ^(NSError *error)
             {
                 if(!error)
                 {
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@ Achievement Completed!",name] message:@"Your achievement has been successfully submitted to Game Center." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                     [alert show];
                     [alert release];
                 }
                 
                 else if(error.code == GKErrorNotAuthenticated)
                 {
                     //not authenticated
                 }
             }];
		}
	}

}

-(void)showAchievments;
{
    if(![[GKLocalPlayer localPlayer]isAuthenticated])
    {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            if(error == nil)
            {            }
            
            else
            {            }
        }];
        
        return;
    }
    
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL)
	{
		achievements.achievementDelegate = self;
		[tempController presentModalViewController: achievements animated: YES];
	}
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{    
	[tempController dismissModalViewControllerAnimated: YES];
	[viewController release];
}

-(void)resetAchievements
{
    [GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) 
     {
         if(error)
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reset Error" message:@"There was a problem reseting your achievements, please try again." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
             [alert show];
             [alert release];
         }
         
         else
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reset Complete" message:@"All of your achievements have been reset." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
             [alert show];
             [alert release];
         }
     }];
}

#pragma mark -
#pragma mark Clean Up

-(void)dealloc
{
    self.earnedAchievementCache = NULL;
    [tempController.view removeFromSuperview];
    [tempController release];
    [super dealloc];
}

@end
