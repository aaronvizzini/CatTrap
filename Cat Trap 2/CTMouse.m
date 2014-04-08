//
//  CTMouse.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>

#import "CTMouse.h"

#import "CTGridManager.h"
#import "CTFireBlock.h"
#import "CTCheese.h"
#import "CTElement.h"
#import "CTPortal.h"
#import "CTDogTrigger.h"
#import "CTGameDisplayController.h"
#import "FileHelper.h"
#import "CTCat.h"
#import "CTLevel.h"
#import "SimpleAudioEngine.h"

#define STICK_TRAP_DELAY 3
#define MOUSE_INVINCIBLE_TIME 3.0f
#define kFireTag 2

@implementation CTMouse
@synthesize canMove;

#pragma mark -
#pragma mark Init Method

-(id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"mouse.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
        self.location = CGPointMake((grid.size+1)/2, (grid.size+1)/2);
        self.livesLeft = 5;
        self.canMove = YES;
        isInvincible = NO;
        
        CGRect rectX = [self textureRect];
        fire = [CCParticleFire node];
        fire.scale = .1f;
        fire.position = ccp(rectX.size.width/2, rectX.size.height/2);
        fire.gravity = ccp(0,40);
        fire.radialAccel = 10;
		fire.radialAccelVar = 0;
        fire.speed = 80;
		fire.angleVar = 180;
        fire.life = 2;
		fire.startSize = 64.0f;
        [self addChild:fire z:1 tag:kFireTag];
        [fire stopSystem];
        
        totalDeaths = 0;
        totalDistance = 0;
        trapDeaths = 0;
        catDeaths = 0;
        fireDeaths = 0;
    }
    
    return self;
}

-(void)reset
{
    if(self.grid.level.levelType != CTLevelCustom)
    {
        NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        [settingsDictionary setObject:[NSNumber numberWithInt:totalDeaths + [[settingsDictionary objectForKey:@"TotalDeaths"]intValue]] forKey:@"TotalDeaths"];
        [settingsDictionary setObject:[NSNumber numberWithInt:totalDistance + [[settingsDictionary objectForKey:@"TotalDistance"]intValue]] forKey:@"TotalDistance"];
        [settingsDictionary setObject:[NSNumber numberWithInt:trapDeaths + [[settingsDictionary objectForKey:@"DeathsByTrap"]intValue]] forKey:@"DeathsByTrap"];
        [settingsDictionary setObject:[NSNumber numberWithInt:catDeaths + [[settingsDictionary objectForKey:@"DeathsByCat"]intValue]] forKey:@"DeathsByCat"];
        [settingsDictionary setObject:[NSNumber numberWithInt:fireDeaths + [[settingsDictionary objectForKey:@"DeathsByFire"]intValue]] forKey:@"DeathsByFire"];
        [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
    }
    
    totalDeaths = 0;
    totalDistance = 0;
    trapDeaths = 0;
    catDeaths = 0;
    fireDeaths = 0;
    
    [fire stopSystem];
    self.livesLeft = 5;
    [self makeUnInvincible];
    [self makeInvincible];
}

#pragma mark -
#pragma mark overriden move method

-(bool)move:(CTDirection)direction
{
    if(!canMove)return NO;
    
    if(direction == CTNorth)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x, self.location.y+1)];
        
        if([pushable isKindOfClass:[CTFireBlock class]])
        {
            [self needsToBurn];
            return NO;
        }
        
        if(![self isWallInDirection:direction] && (pushable.spriteType== CTCatPushable || [pushable pushableInDirection:direction] || pushable == NULL))
        {
            totalDistance++;
            [self setRotation:0];
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    else if(direction == CTSouth)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x, self.location.y-1)];
        
        if([pushable isKindOfClass:[CTFireBlock class]])
        {
            [self needsToBurn];
            return NO;
        }
        
        if(![self isWallInDirection:direction] && (pushable.spriteType== CTCatPushable || [pushable pushableInDirection:direction] || pushable == NULL))
        {
            totalDistance++;
            [self setRotation:180];
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    else if(direction == CTEast)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x+1, self.location.y)];
        
        if([pushable isKindOfClass:[CTFireBlock class]])
        {
            [self needsToBurn];
            return NO;
        }
        
        if(![self isWallInDirection:direction] && (pushable.spriteType== CTCatPushable || [pushable pushableInDirection:direction] || pushable == NULL))
        {
            totalDistance++;
            [self setRotation:90];
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    else if(direction == CTWest)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x-1, self.location.y)];
        
        if([pushable isKindOfClass:[CTFireBlock class]])
        {
            [self needsToBurn];
            return NO;
        }
        
        if(![self isWallInDirection:direction] && (pushable.spriteType== CTCatPushable || [pushable pushableInDirection:direction] || pushable == NULL))
        {
            totalDistance++;
            [self setRotation:270];
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    [self assessLcoation];
    return NO;
}

#pragma mark -
#pragma mark death and trap methods

-(void)needsToDie
{
    if(!isInvincible)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.livesLeft--;
        totalDeaths++;
        
        if([[grid getPushableForLocation:self.location]isKindOfClass:[CTCat class]])
        {
            catDeaths++;
            [[SimpleAudioEngine sharedEngine] playEffect:@"Cat.wav"];
        }
        
        else
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"MouseDeath.wav"];
        }
        
        if(livesLeft == 0)
        {
            [self.grid gameOver];
            return;
        }
        
        [self makeInvincible];
    }
}

-(void)needsToBurn
{
    if(!isInvincible)
    {
        [fire resetSystem];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Mouse_Fire.wav"];
        [self performSelector:@selector(extinquishFire) withObject:nil afterDelay:1.0f];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.livesLeft--;
        totalDeaths++;
        fireDeaths++;
    
        if(livesLeft == 0)
        {
            [self.grid gameOver];
            return;
        }
        
        [self makeInvincible];
    }
}

-(void)extinquishFire
{
    [fire stopSystem];
}

-(void)stickyTrapped
{
    if(!isInvincible)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.canMove = NO;
        [self performSelector:@selector(untrap) withObject:nil afterDelay:STICK_TRAP_DELAY];
    }
}

-(void)untrap
{
    self.canMove = YES;
}

-(void)setLivesLeft:(int)theLivesLeft
{   
    livesLeft = theLivesLeft;
    [self.grid.gameDisplayController setMouseLives:theLivesLeft];
}

-(int)livesLeft
{
    return livesLeft;
}

#pragma mark -
#pragma mark locaiton assession method

-(void)assessLcoation
{
    //for(CTCheese *cheese in self.grid.cheese)
    
    bool finished = NO;
    
    while(!finished)
    {
        finished = YES;
        
        for(int i = 0; i<[self.grid.cheese count]; i++)
        {
            CTCheese *cheese = [self.grid.cheese objectAtIndex:i];
        
            if(cheese != nil && cheese.location.x == self.location.x && cheese.location.y == self.location.y)
            {
                [self.grid collectedCheese:cheese];
                finished = NO;
            }
        }
    }
    
    for (CTElement *element in self.grid.elements)
    {
        if(element.location.x == self.location.x && element.location.y == self.location.y)
        {
            if(element.spriteType == CTMouseTrapElement)
            {
                trapDeaths++;
                [self needsToDie];
            }
            
            else if(element.spriteType == CTStickyTrapElement)[self stickyTrapped];
            
            else if(element.spriteType == CTPortalElement)
            {
                CTPortal *portal = (CTPortal *)element;
                [portal teleport];
                break;
            }
            
            else if(element.spriteType == CTDogTriggerElement)
            {
                CTDogTrigger *trigger = (CTDogTrigger *)element;
                [trigger callForDog];
                break;
            }
        }
    }
}

#pragma mark -
#pragma mark Invincible Methods

-(void)makeInvincible
{
    self.opacity = 255/2;
    isInvincible = YES;
    [self performSelector:@selector(makeUnInvincible) withObject:nil afterDelay:MOUSE_INVINCIBLE_TIME];
}

-(void)makeInvincibleForever
{
    self.opacity = 255/2;
    isInvincible = YES;
}

-(void)makeUnInvincible
{
    self.opacity = 255;
    isInvincible = NO;
}

#pragma mark -
#pragma mark OnExit Method

-(void)onExit
{    
    if(self.grid.level.levelType != CTLevelCustom)
    {
        NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        [settingsDictionary setObject:[NSNumber numberWithInt:totalDeaths + [[settingsDictionary objectForKey:@"TotalDeaths"]intValue]] forKey:@"TotalDeaths"];
        [settingsDictionary setObject:[NSNumber numberWithInt:totalDistance + [[settingsDictionary objectForKey:@"TotalDistance"]intValue]] forKey:@"TotalDistance"];
        [settingsDictionary setObject:[NSNumber numberWithInt:trapDeaths + [[settingsDictionary objectForKey:@"DeathsByTrap"]intValue]] forKey:@"DeathsByTrap"];
        [settingsDictionary setObject:[NSNumber numberWithInt:catDeaths + [[settingsDictionary objectForKey:@"DeathsByCat"]intValue]] forKey:@"DeathsByCat"];
        [settingsDictionary setObject:[NSNumber numberWithInt:fireDeaths + [[settingsDictionary objectForKey:@"DeathsByFire"]intValue]] forKey:@"DeathsByFire"];
        [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
    }
    
    [super onExit];
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}

@end
