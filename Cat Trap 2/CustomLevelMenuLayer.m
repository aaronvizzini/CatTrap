//
//  CustomLevelMenuLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/13/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CustomLevelMenuLayer.h"
#import "FileHelper.h"
#import "CTLevel.h"
#import "SpriteRect.h"
#import "MainMenuScene.h"
#import "LevelCreatorScene.h"
#import "GameplayControllerScene.h"
#import "CTGameCenterManager.h"
#import "SimpleAudioEngine.h"

#define kKeyCountVerification 11
#define kFontSize 28

@implementation CustomLevelMenuLayer
@synthesize currentSession;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        newLevel = [CCLabelTTF labelWithString:@"New" fontName:@"WetPaint" fontSize:kFontSize];
        newLevel.position = ccp(40,440);
        newLevel.color = ccc3(72, 175, 249);
        [self addChild:newLevel];
        
        share = [CCLabelTTF labelWithString:@"Share" fontName:@"WetPaint" fontSize:kFontSize];
        share.position = ccp(117,440);
        share.color = ccc3(72, 175, 249);
        share.opacity = 50;
        [self addChild:share];
        
        edit = [CCLabelTTF labelWithString:@"Edit" fontName:@"WetPaint" fontSize:kFontSize];
        edit.position = ccp(191,440);
        edit.color = ccc3(72, 175, 249);
        edit.opacity = 50;
        [self addChild:edit];
        
        remove = [CCLabelTTF labelWithString:@"Delete" fontName:@"WetPaint" fontSize:kFontSize];
        remove.position = ccp(268,440);
        remove.color = ccc3(72, 175, 249);
        remove.opacity = 50;
        [self addChild:remove];
        
        connection = [CCLabelTTF labelWithString:@"Connect" fontName:@"WetPaint" fontSize:kFontSize];
        connection.position = ccp(77,20);
        connection.color = ccc3(72, 175, 249);
        [self addChild:connection];
        
        menu = [CCLabelTTF labelWithString:@"Back" fontName:@"WetPaint" fontSize:kFontSize];
        menu.position = ccp(285,20);
        menu.color = ccc3(72, 175, 249);
        [self addChild:menu];
        
        customLevels = [[NSMutableArray alloc]init];
        
		table = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, 320, 365) style:UITableViewStylePlain];
		[table setDelegate:self];
		[table setDataSource:self];
		table.backgroundColor = [UIColor clearColor];
        [[[CCDirector sharedDirector] openGLView] addSubview:table];
        
        [self loadCustomLevels];
    }
    
    return self;
}

-(void)loadCustomLevels
{
    [customLevels removeAllObjects];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *allCustomLevelPaths = [fm contentsOfDirectoryAtPath:[FileHelper getCustomLevelsDirectory] error:nil];
    
    for(NSString *path in allCustomLevelPaths)
    {
        CTLevel *customLevel = [[CTLevel alloc]initFromFile:[[FileHelper getCustomLevelsDirectory]stringByAppendingPathComponent:path]];
        [customLevels addObject:customLevel];
        [customLevel release];
    }
    
    if([customLevels count]>=5)
    {
        CTGameCenterManager *gcm = [[CTGameCenterManager alloc]init];
        [gcm submitAchievementId:kTheInventor fullName:@"The Inventor"];
        [gcm release];
    }
}

#pragma mark -
#pragma mark Touch Methods

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
	//UITouch *touch = [touches anyObject];
	//CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint convertedPoint = [self convertTouchToNodeSpace:[touches anyObject]];        
    CGRect newRect = [self rectForSprite:newLevel];
    CGRect shareRect = [self rectForSprite:share];
    CGRect editRect = [self rectForSprite:edit];
    CGRect deleteRect = [self rectForSprite:remove];
    CGRect backRect = [self rectForSprite:menu];
    CGRect connectRect = [self rectForSprite:connection];
    
    if(CGRectContainsPoint(newRect,convertedPoint))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [newLevel runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(newCustomLevel)], nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(shareRect,convertedPoint) && share.opacity == 255)
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [share runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(btnSend)], nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(editRect,convertedPoint) && edit.opacity == 255)
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [edit runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(editCustomLevel)], nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(deleteRect,convertedPoint) && remove.opacity == 255)
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [remove runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(deleteCustomLevel)], nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(backRect,convertedPoint))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [menu runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(quit)], nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(connectRect,convertedPoint))
    {
        id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
        [connection runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(connectToBluetooth)], nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger) section
{
	return [customLevels count];
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier 
{

	UILabel *levelName = [[UILabel alloc]initWithFrame:CGRectMake(10,0,320,50)];
	UIButton *play = [[UIButton alloc]initWithFrame:CGRectMake(275,4,35,35)];
	
	levelName.font = [UIFont fontWithName:@"WetPaint" size:24];
	levelName.textAlignment = UITextAlignmentLeft;
	levelName.backgroundColor = [UIColor clearColor];
	levelName.textColor = [UIColor whiteColor]; 
	levelName.tag = 1;
    
	play.tag = 2;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	
	[[cell contentView] addSubview:levelName];
	[[cell contentView] addSubview:play];
	
	[levelName release];
	[play release];
	
	return cell;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
        cell = [self getCellContentView:CellIdentifier];
	}
	
	NSUInteger row = [indexPath row];
    
    CTLevel *customLevel = [customLevels objectAtIndex:row];
    
    UILabel *levelName = (UILabel *)[cell viewWithTag:1];
	UIButton *play = (UIButton *)[cell viewWithTag:2];
	
    [play addTarget:self action:@selector(playLevelAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [play setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    play.tag = [indexPath row];
    
	levelName.text = customLevel.name;
        
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	newLevel.opacity = 255;
    edit.opacity = 255;
    share.opacity = 255;
    remove.opacity = 255;
}

#pragma mark -
#pragma mark Action Methods

-(void)playLevelAction:(id)sender forEvent:(UIEvent *)event
{    
    NSIndexPath *indexPath = [table indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:table]];
    
    CTLevel *customLevel = [customLevels objectAtIndex:[indexPath row]];

    GameplayControllerScene *gameplayScene = [GameplayControllerScene node];
    [gameplayScene loadLevel:customLevel];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)newCustomLevel
{	
    [[CCDirector sharedDirector] replaceScene:[LevelCreatorScene node]];
}

-(void)shareCustomLevel
{
	[self btnSend];
}

-(void)editCustomLevel
{
    LevelCreatorScene *creatorScene = [LevelCreatorScene node];
    
    NSIndexPath *selectedIndex = [table indexPathForSelectedRow];
    CTLevel *customLevel = [customLevels objectAtIndex:[selectedIndex row]];
    [creatorScene editLevelWithName:customLevel.name];
    [[CCDirector sharedDirector] replaceScene:creatorScene];
}

-(void)deleteCustomLevel
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Are you sure you want to delete this level permanently?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"NO"];
	[alert show];
	[alert release];
}

-(void)quit
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene node]];
}

-(void)connectToBluetooth
{
    if(currentSession)
    {
        [connection setString:@"Connect"];
        [self btnDisconnect];
    }
    
    else
    {
        [connection setString:@"Disconnect"];
        [self btnConnect];
    }
}

#pragma mark -
#pragma mark UIAlertView method

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{		
        share.opacity = 50;
        edit.opacity = 50;
        remove.opacity = 50;
        
		NSFileManager *fm = [NSFileManager defaultManager];
        
        NSIndexPath *selectedIndex = [table indexPathForSelectedRow];
        
        CTLevel *customLevel = [customLevels objectAtIndex:[selectedIndex row]];

        [fm removeItemAtPath:[[FileHelper getCustomLevelsDirectory]stringByAppendingPathComponent:customLevel.name] error:nil];
        
        [self loadCustomLevels];
        
        [table reloadData];
	}	
}

#pragma mark -
#pragma mark Bluetooth Methods

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    GKSession* session = [[[GKSession alloc] initWithSessionID:@"com.alternativevisuals.cattrap2" displayName:nil sessionMode:GKSessionModePeer]autorelease];
    return session;
}

-(void)btnConnect
{
    thePicker = [[GKPeerPickerController alloc] init];
    thePicker.delegate = self;
    thePicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;     
	
    [thePicker show];    
    
    [connection setString:@"Disconnect"];
}

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session 
{
    self.currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	picker.delegate = nil;
	
    [picker dismiss];
    [picker autorelease];
}

-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker autorelease];
    [connection setString:@"Connect"];
}

-(void)btnDisconnect
{
    [self.currentSession disconnectFromAllPeers];
    [self setCurrentSession:nil];
    currentSession = nil;
    [connection setString:@"Connect"];
}

-(void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state 
{
    switch (state)
    {
        case GKPeerStateConnected:
            //NSLog(@"connected");
            break;
        case GKPeerStateDisconnected:
            [self setCurrentSession:nil];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"The connection has ended." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[alert show];
			[alert release];
            break;
        case GKPeerStateAvailable:
            break;
        case GKPeerStateConnecting:
            break;
        case GKPeerStateUnavailable:
            [connection setString:@"Connect"];
    }
}

-(void) sendDataToPeers:(NSData *) data
{
    if (currentSession) 
	{
        [self.currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];   
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent!" message:@"Your custom level has been sent." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't share a custom level unless you are connected to another peer." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    
}

-(void) btnSend
{
	NSMutableData *theData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
    NSIndexPath *selectedIndex = [table indexPathForSelectedRow];
    
    CTLevel *customLevel = [customLevels objectAtIndex:[selectedIndex row]];
		
	[archiver encodeObject:[customLevel getArchivableDictionary] forKey:@"level"];
	[archiver finishEncoding];
	
	[self sendDataToPeers:theData];
	[archiver release];
}

-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context 
{	
	NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *levelDict = [archiver decodeObjectForKey:@"level"];
	[archiver finishDecoding];
	[archiver release];
	
	if([[levelDict allKeys]count] == kKeyCountVerification)
	{
        CTLevel *receivedCustomLevel = [[CTLevel alloc]initFromDictionary:levelDict];
        [receivedCustomLevel writeToFile:[[FileHelper getCustomLevelsDirectory]stringByAppendingPathComponent:receivedCustomLevel.name]];
        [receivedCustomLevel release];
        
        [self loadCustomLevels];
        [table reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Received!" message:@"A custom level has been received." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
	}
}

#pragma mark -
#pragma mark Cleanup

-(void)dealloc
{
    [table removeFromSuperview];
	[table release];
    [customLevels release];
    [currentSession release];
    [super dealloc];
}

@end
