//
//  CTDog.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/20/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTDog.h"
#import "CTGridManager.h"
#import "CTFishBlock.h"
#import "CTCat.h"
#import "SimpleAudioEngine.h"
#import "CTManager.h"
#import "CTProfile.h"
#import "CTLevel.h"

#define AI_SPEED_NORMAL .5f
#define AI_SPEED_HARD .3f

@implementation CTDog

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) 
    {
        self.spriteType = CTDogPushable;
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"dog.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"Dog_Bark.wav"];
    }
    
    return self;
}

#pragma mark -
#pragma mark AI state methods

-(void)startAI
{
    if(self.grid.level.levelType == CTLevelClassic && [[[[CTManager sharedInstance]currentProfile]difficulty]isEqualToString:@"hard"])[[CCScheduler sharedScheduler]scheduleSelector:@selector(makeDecision) forTarget:self interval:AI_SPEED_HARD paused:NO];
    else [[CCScheduler sharedScheduler]scheduleSelector:@selector(makeDecision) forTarget:self interval:AI_SPEED_NORMAL paused:NO];
}


-(void)pauseAI
{
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(makeDecision) forTarget:self];
}

-(void)endExistance
{
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(makeDecision) forTarget:self];
    [self.grid.pushables removeObject:self];
    [self.grid removeChild:self cleanup:YES];
}

#pragma mark -
#pragma mark AI decision methods

-(void)makeDecision 
{
    CTCat *nearestCat = [self getNearestCat];
    if(!nearestCat)return;
    
    int nearestCatX = nearestCat.location.x;
    int nearestCatY = nearestCat.location.y;
    int dogX = self.location.x;
    int dogY = self.location.y;
    int deltaX = abs(nearestCatX - dogX);
    int deltaY = abs(nearestCatY - dogY);
    int r = (arc4random() % 2) + 0;
        
    if(nearestCatX == dogX && nearestCatY == dogY)
    {
        [nearestCat turnToCheese];
        [self endExistance];
    }
    
    //DELTAS EQUAL AND NO DIAGONALS
    else if(deltaX == deltaY)
    {
        if(dogX > nearestCatX && dogY < nearestCatY)//Top Left
        {
            if(r == 0)
            {
                if(![self move:CTNorth])[self move:CTWest];
            }
                
            else if(r==1)
            {
                if(![self move:CTWest])[self move:CTNorth];
            }
        }
            
        else if(dogX > nearestCatX && dogY > nearestCatY)//bottom left
        {
            if(r == 0)
            {
                if(![self move:CTSouth])[self move:CTWest];
            }
                
            else if(r==1)
            {
                if(![self move:CTWest])[self move:CTSouth];
            }
        }
            
        else if(dogX < nearestCatX && dogY < nearestCatY)//Top Right
        {
            if(r == 0)
            {
                if(![self move:CTNorth])[self move:CTEast];
            }
                
            else if(r==1)
            {
                if(![self move:CTEast])[self move:CTNorth];
            }
        }
            
        else if(dogX < nearestCatX && dogY > nearestCatY)//bottom right
        {
            if(r == 0)
            {
                if(![self move:CTSouth])[self move:CTEast];
            }
                
            else if(r==1)
            {
                if(![self move:CTEast])[self move:CTSouth];
            }
        }
    }
    
    //NO DIAGNONAL AND NO DELTA EQUAL
    else if(nearestCatY > dogY && deltaY > deltaX)//North
    {
        if(nearestCatX == dogX)//north
        {
            if(![self move:CTNorth])
            {
                if(r == 0)
                {
                    if(![self move:CTWest])[self move:CTEast];
                }
                    
                else if(r == 1)
                {
                    if(![self move:CTEast])[self move:CTWest];
                }
            }
        }
        
        else if(![self move:CTNorth])
        {
            if(nearestCatX < dogX)//north west
            {
                if(![self move:CTWest])[self move:CTEast];
            }
                
            else if(nearestCatX > dogX)//north east
            {
                if(![self move:CTEast])[self move:CTWest];
            }
        }
    }
    
    else if(nearestCatY < dogY && deltaY > deltaX)//south
    {
        if(nearestCatX == dogX)//south
        {
            if(![self move:CTSouth])
            {
                if(r == 0)
                {
                    if(![self move:CTWest])[self move:CTEast];
                }
                
                else if(r == 1)
                {
                    if(![self move:CTEast])[self move:CTWest];
                }
            }
        }
        
        else if(![self move:CTSouth])
        {
            if(nearestCatX < dogX)//north west
            {
                if(![self move:CTWest])[self move:CTEast];
            }
                
            else if(nearestCatX > dogX)//north east
            {
                if(![self move:CTEast])[self move:CTWest];
            }
        }
    }
    
    else if(nearestCatX > dogX && deltaY < deltaX)//East
    {
        if(nearestCatY == dogY)//east
        {
            if(![self move:CTEast])
            {
                if(r == 0)
                {
                    if(![self move:CTNorth])[self move:CTSouth];
                }
                    
                else if(r == 1)
                {
                    if(![self move:CTSouth])[self move:CTNorth];
                }
            }
        }
        
        else if(![self move:CTEast])
        {
            if(nearestCatY < dogY)//north west
            {
                if(![self move:CTSouth])[self move:CTNorth];
            }
                
            else if(nearestCatY > dogY)//north east
            {
                if(![self move:CTNorth])[self move:CTSouth];
            }
        }
    }
    
    else if(nearestCatX < dogX && deltaY < deltaX)//west
    {
        if(nearestCatY == dogY)//west
        {
            if(![self move:CTWest])
            {
                if(r == 0)
                {
                    if(![self move:CTNorth])[self move:CTSouth];
                }
                    
                else if(r == 1)
                {
                    if(![self move:CTSouth])[self move:CTNorth];
                }
            }
        }
        
        else if(![self move:CTWest])
        {
            if(nearestCatY < dogY)//north west
            {
                if(![self move:CTSouth])[self move:CTNorth];
            }
                
            else if(nearestCatY > dogY)//north east
            {
                if(![self move:CTNorth])[self move:CTSouth];
            }
        }
    }
}

#pragma mark -
#pragma mark Overriden move method

-(bool)move:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x, self.location.y+1)];
        if(![self isWallInDirection:direction] && (!pushable || pushable.spriteType == CTCatPushable))
        {
            [self setRotation:0];
            [super move:direction];
            return YES;
        }
    }
    
    else if(direction == CTSouth)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x, self.location.y-1)];
        if(![self isWallInDirection:direction] && (!pushable || pushable.spriteType == CTCatPushable))
        {
            [self setRotation:180];
            [super move:direction];
            return YES;
        }
    }
    
    else if(direction == CTEast)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x+1, self.location.y)];
        if(![self isWallInDirection:direction] && (!pushable || pushable.spriteType == CTCatPushable))
        {
            [self setRotation:90];
            [super move:direction];
            return YES;
        }
    }
    
    else if(direction == CTWest)
    {
        CTPushable *pushable = [grid getPushableForLocation:CGPointMake(self.location.x-1, self.location.y)];
        if(![self isWallInDirection:direction] && (!pushable || pushable.spriteType == CTCatPushable))
        {
            [self setRotation:270];
            [super move:direction];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark Overriden pushable method

-(bool)pushableInDirection:(CTDirection)direction
{
    CTPushable *pushable = [self getPushableInDirection:direction];
    
    if(![self isWallInDirection:direction] && pushable == NULL)
    {
        [self move:direction];
        return YES;
    }
    
    else
    {
        if(![self isWallInDirection:direction] && pushable && [pushable pushableInDirection:direction])
        {
            [self move:direction];
            return YES;
        }
        
        else return NO;
    }
}

#pragma mark -
#pragma mark Cat retrieval method

-(CTCat *)getNearestCat
{
    CTCat *nearest = nil;
    
    for(CTCat *cat in grid.cats)
    {
        if(nearest == nil) nearest = cat;
        
        else
        {
            int deltaX = abs(cat.location.x - self.location.x);
            int deltaY = abs(cat.location.y - self.location.y);
            
            int currentDeltaX = abs(nearest.location.x - self.location.x);
            int currentDeltaY = abs(nearest.location.x - self.location.x);
            
            if(currentDeltaX > deltaX && currentDeltaY > deltaY)nearest = cat; 
        }
    }
           
    return nearest;
}

#pragma mark -
#pragma mark animation methods

-(void)animateOut
{
    
}

-(void)animateIn
{
    
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}

@end
