//
//  CTCat.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTCat.h"
#import "CTGridManager.h"
#import "CTFishBlock.h"
#import "CTCheese.h"
#import "CTMouse.h"
#import "CTManager.h"
#import "CTProfile.h"
#import "CTLevel.h"

#define AI_SPEED_NORMAL .7f
#define AI_SPEED_HARD .5f

@implementation CTCat

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) 
    {
        self.spriteType = CTCatPushable;
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"cat.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
        
        northEastPushable = nil;
        northWestPushable = nil;
        southEastPushable = nil;
        southWestPushable = nil;
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

#pragma mark -
#pragma mark AI Decision Methods

-(void)makeDecision 
{
    int mouseX = self.grid.mouse.location.x;
    int mouseY = self.grid.mouse.location.y;
    int catX = self.location.x;
    int catY = self.location.y;
    int deltaX = abs(mouseX - catX);
    int deltaY = abs(mouseY - catY);
    int r = (arc4random() % 2) + 0;
    
    northEastPushable = [grid getPushableForLocation:CGPointMake(catX+1, catY+1)];
    northWestPushable = [grid getPushableForLocation:CGPointMake(catX-1, catY+1)];
    southEastPushable = [grid getPushableForLocation:CGPointMake(catX+1, catY-1)];
    southWestPushable = [grid getPushableForLocation:CGPointMake(catX-1, catY-1)];
    
    if(![self canMove])
    {
        if(self.grid.mouse.location.x == self.location.x && self.grid.mouse.location.y == self.location.y)[self.grid.mouse needsToDie];
        if([self shouldBecomeCheese])[self turnToCheese];
        return;
    }

    if(mouseX == catX && mouseY == catY)
    {
        [self.grid.mouse needsToDie];
        return;
    }
    
    //DELTAS EQUAL AND NO DIAGONALS
    else if(deltaX == deltaY)
    {
        if(![self diagonolDecision])
        {
            if(catX > mouseX && catY < mouseY)//Top Left
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
        
            else if(catX > mouseX && catY > mouseY)//bottom left
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
        
            else if(catX < mouseX && catY < mouseY)//Top Right
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
        
            else if(catX < mouseX && catY > mouseY)//bottom right
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
    }
    
    //NO DIAGNONAL AND NO DELTA EQUAL
    else if(mouseY > catY && deltaY > deltaX)//North
    {
        if(mouseX == catX)//north
        {
            if(![self move:CTNorth])
            {
                if(![self diagonolDecision])
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
        }
        
        else if(![self move:CTNorth])
        {
            if(![self diagonolDecision])
            {
                if(mouseX < catX)//north west
                {
                    if(![self move:CTWest])[self move:CTEast];
                }
            
                else if(mouseX > catX)//north east
                {
                    if(![self move:CTEast])[self move:CTWest];
                }
            }
        }
    }
    
    else if(mouseY < catY && deltaY > deltaX)//south
    {
        if(mouseX == catX)//south
        {
            if(![self move:CTSouth])
            {
                if(![self diagonolDecision])
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
        }
        
        else if(![self move:CTSouth])
        {
            if(![self diagonolDecision])
            {
                if(mouseX < catX)//north west
                {
                    if(![self move:CTWest])[self move:CTEast];
                }
        
                else if(mouseX > catX)//north east
                {
                    if(![self move:CTEast])[self move:CTWest];
                }
            }
        }
    }
    
    else if(mouseX > catX && deltaY < deltaX)//East
    {
        if(mouseY == catY)//east
        {
            if(![self move:CTEast])
            {
                if(![self diagonolDecision])
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
        }
        
        else if(![self move:CTEast])
        {
            if(![self diagonolDecision])
            {
                if(mouseY < catY)//north west
                {
                    if(![self move:CTSouth])[self move:CTNorth];
                }
        
                else if(mouseY > catY)//north east
                {
                    if(![self move:CTNorth])[self move:CTSouth];
                }
            }
        }
    }
    
    else if(mouseX < catX && deltaY < deltaX)//west
    {
        if(mouseY == catY)//west
        {
            if(![self move:CTWest])
            {
                if(![self diagonolDecision])
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
        }
        
        else if(![self move:CTWest])
        {
            if(![self diagonolDecision])
            {
                if(mouseY < catY)//north west
                {
                    if(![self move:CTSouth])[self move:CTNorth];
                }
            
                else if(mouseY > catY)//north east
                {
                    if(![self move:CTNorth])[self move:CTSouth];
                }
            }
        }
    }
    
    if(self.grid.mouse.location.x == self.location.x && self.grid.mouse.location.y == self.location.y)[self.grid.mouse needsToDie];
    if([self shouldBecomeCheese])[self turnToCheese];
}

-(bool)diagonolDecision
{
    if(self.grid.level.levelType == CTLevelClassic && [[[[CTManager sharedInstance]currentProfile]difficulty]isEqualToString:@"easy"])return NO;

    int mouseX = self.grid.mouse.location.x;
    int mouseY = self.grid.mouse.location.y;
    int catX = self.location.x;
    int catY = self.location.y;
    int r = (arc4random() % 2) + 0;
    
    int deltaX = abs(mouseX - catX);
    int deltaY = abs(mouseY - catY);
    
    BOOL topRightOpen = NO;
    if(!northEastPushable && !([self isWallInDirection:CTNorth] || [self isWallInDirection:CTEast]))topRightOpen=YES;
    
    BOOL topLeftOpen = NO;
    if(!northWestPushable && !([self isWallInDirection:CTNorth] || [self isWallInDirection:CTWest]))topLeftOpen=YES;
    
    BOOL bottomRightOpen = NO;
    if(!southEastPushable && !([self isWallInDirection:CTSouth] || [self isWallInDirection:CTEast]))bottomRightOpen=YES;
    
    BOOL bottomLeftOpen = NO;
    if(!southWestPushable && !([self isWallInDirection:CTSouth] || [self isWallInDirection:CTWest]))bottomLeftOpen=YES;
        
    if(catX >= mouseX && catY <= mouseY && topLeftOpen)//Top Left
    {
        [self diagonolMove:CTTopLeft];
        return YES;
    }
    
    else if(catX >= mouseX && catY >= mouseY && bottomLeftOpen)//bottom left
    {
        [self diagonolMove:CTBottomLeft];
        return YES;
    }
    
    else if(catX <= mouseX && catY <= mouseY && topRightOpen)//Top Right
    {
        [self diagonolMove:CTTopRight];
        return YES;
    }
    
    else if(catX <= mouseX && catY >= mouseY && bottomRightOpen)//bottom right
    {
        [self diagonolMove:CTBottomRight];
        return YES;
    }
    
    else if(catX == mouseX && catY <= mouseY && topLeftOpen && topRightOpen)//Direct north
    {
        if(r==0)[self diagonolMove:CTTopRight];
        else if(r==1)[self diagonolMove:CTTopLeft];
        return  YES;
    }
    
    else if(catX == mouseX && catY >= mouseY && bottomLeftOpen && bottomRightOpen)//Direct south
    {
        if(r==0)[self diagonolMove:CTBottomRight];
        else if(r==1)[self diagonolMove:CTBottomLeft];
        return YES;
    }
    
    else if(catY == mouseY && catX <= mouseX && topRightOpen && bottomRightOpen)//Direct east
    {
        if(r==0)[self diagonolMove:CTTopRight];
        else if(r==1)[self diagonolMove:CTBottomRight];
        return YES;
    }
    
    else if(catY == mouseY && catX >= mouseX && topLeftOpen && bottomLeftOpen)
    {
        if(r==0)[self diagonolMove:CTTopLeft];
        else if(r==1)[self diagonolMove:CTBottomLeft];
        return  YES;
    }
    
    //
    
    else if(deltaY > deltaX)//More important up and down
    {
        if(catY > mouseY)//go down
        {
            if(catX > mouseX)//down left
            {
                if(!bottomLeftOpen && bottomRightOpen)
                {
                    [self diagonolMove:CTBottomRight];
                    return YES;
                }
            }
            
            else if(catX < mouseX)//down right
            {
                if(!bottomRightOpen && bottomLeftOpen)
                {
                    [self diagonolMove:CTBottomLeft];
                    return YES;
                }
            }
        }
        
        else if(catY < mouseY)//go up
        {
            if(catX > mouseX)//up left
            {
                if(!topLeftOpen && topRightOpen)
                {
                    [self diagonolMove:CTTopRight];
                    return YES;
                }
            }
            
            else if(catX < mouseX)//up right
            {
                if(!topRightOpen && topLeftOpen)
                {
                    [self diagonolMove:CTTopLeft];
                    return YES;
                }
            }
        }
    }
    
    else if(deltaX > deltaY)//More important right left
    {
        if(catX > mouseX)//go left
        {
            if(catY > mouseY)//go down
            {
                if(!bottomLeftOpen && topLeftOpen)
                {
                    [self diagonolMove:CTTopLeft];
                    return YES;
                }
            }
            
            else if(catY < mouseY)//go up
            {
                if(!topLeftOpen && bottomLeftOpen)
                {
                    [self diagonolMove:CTBottomLeft];
                    return YES;
                }
            }
        }
        
        else if(catX < mouseX)//go right
        {
            if(catY > mouseY)//go down
            {
                if(!bottomRightOpen && topRightOpen)
                {
                    [self diagonolMove:CTTopRight];
                    return YES;
                }
            }
            
            else if(catY < mouseY)//go up
            {
                if(!topRightOpen && bottomRightOpen)
                {
                    [self diagonolMove:CTBottomRight];
                    return YES;
                }
            }
        }
    }
    
    return NO;

}

-(bool)move:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        if(![self isWallInDirection:direction] && ![grid getPushableForLocation:CGPointMake(self.location.x, self.location.y+1)])
        {
            [self setRotation:0];
            [super move:direction];
            return YES;
        }
    }
    
    else if(direction == CTSouth)
    {
        if(![self isWallInDirection:direction] && ![grid getPushableForLocation:CGPointMake(self.location.x, self.location.y-1)])
        {
            [self setRotation:180];
            [super move:direction];
            return YES;
        }
    }
    
    else if(direction == CTEast)
    {
        if(![self isWallInDirection:direction] && ![grid getPushableForLocation:CGPointMake(self.location.x+1, self.location.y)])
        {
            [self setRotation:90];
            [super move:direction];
            return YES;
        }
    }
    
    else if(direction == CTWest)
    {
        if(![self isWallInDirection:direction] && ![grid getPushableForLocation:CGPointMake(self.location.x-1, self.location.y)])
        {
            [self setRotation:270];
            [super move:direction];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark Overriden move method

-(void)diagonolMove:(CTDiagonolDirection)direction
{    
    int mouseX = self.grid.mouse.location.x;
    int mouseY = self.grid.mouse.location.y;
    int catX = self.location.x;
    int catY = self.location.y;    
    int deltaX = abs(mouseX - catX);
    int deltaY = abs(mouseY - catY);
    
    if(direction == CTTopRight)
    {
        //North East
        if(deltaX > deltaY)[self setRotation:90];
        else if(deltaY > deltaX)[self setRotation:0];
        
        self.location = CGPointMake(self.location.x+1, self.location.y+1);
        self.position = [grid positionForLocation:CGPointMake(self.location.y, self.location.x)];
    }
    
    else if(direction == CTTopLeft)
    {
        //North West
        if(deltaX > deltaY)[self setRotation:270];
        else if(deltaY > deltaX)[self setRotation:0];
        
        self.location = CGPointMake(self.location.x-1, self.location.y+1);
        self.position = [grid positionForLocation:CGPointMake(self.location.y, self.location.x)];
    }
    
    else if(direction == CTBottomRight)
    {
        //South East
        if(deltaX > deltaY)[self setRotation:90];
        else if(deltaY > deltaX)[self setRotation:180];
        
        self.location = CGPointMake(self.location.x+1, self.location.y-1);
        self.position = [grid positionForLocation:CGPointMake(self.location.y, self.location.x)];
    }
    
    else if(direction == CTBottomLeft)
    {
        //South West
        if(deltaX > deltaY)[self setRotation:270];
        else if(deltaY > deltaX)[self setRotation:180];
        
        self.location = CGPointMake(self.location.x-1, self.location.y-1);
        self.position = [grid positionForLocation:CGPointMake(self.location.y, self.location.x)];
    }
}


-(bool)canMove
{
    if([[self getPushableInDirection:CTNorth]isKindOfClass:[CTFishBlock class]])return NO;
    else if([[self getPushableInDirection:CTSouth]isKindOfClass:[CTFishBlock class]])return NO;
    else if([[self getPushableInDirection:CTEast]isKindOfClass:[CTFishBlock class]])return NO;
    else if([[self getPushableInDirection:CTWest]isKindOfClass:[CTFishBlock class]])return NO;
    
    return YES;
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
        if(![self isWallInDirection:direction] && [self getPushableInDirection:direction] && [pushable pushableInDirection:direction])
        {
            [self move:direction];
            return YES;
        }
        
        else return NO;
    }
}

#pragma mark -
#pragma mark become cheese methods

-(bool)shouldBecomeCheese
{
    CTPushable *north = [self getPushableInDirection:CTNorth];
    CTPushable *south = [self getPushableInDirection:CTSouth];
    CTPushable *east = [self getPushableInDirection:CTEast];
    CTPushable *west = [self getPushableInDirection:CTWest];
    bool isWallInNorth = [self isWallInDirection:CTNorth];
    bool isWallInSouth = [self isWallInDirection:CTSouth];
    bool isWallInEast = [self isWallInDirection:CTEast];
    bool isWallInWest = [self isWallInDirection:CTWest];
    
    if(northWestPushable && northEastPushable && southWestPushable && southEastPushable && north && south && east && west)return YES;
    
    else if(northWestPushable && northEastPushable && southWestPushable && southEastPushable && isWallInNorth && south && east && west) return YES;
    else if(northWestPushable && northEastPushable && southWestPushable && southEastPushable && north && isWallInSouth && east && west)return YES;
    else if(northWestPushable && northEastPushable && southWestPushable && southEastPushable && north && south && isWallInEast && west)return YES;
    else if(northWestPushable && northEastPushable && southWestPushable && southEastPushable && north && south && east && isWallInWest)return YES;
    
    else if(northWestPushable && southWestPushable && southEastPushable && isWallInNorth && south && isWallInEast && west) return YES;
    else if(northEastPushable && southWestPushable && southEastPushable && isWallInNorth && south && east && isWallInWest) return YES;
    else if(northWestPushable && northEastPushable && southWestPushable && north && isWallInSouth && isWallInEast && west)return YES;
    else if(northWestPushable && northEastPushable && southEastPushable && north && isWallInSouth && east && isWallInWest)return YES;
    
    else if(southWestPushable && southEastPushable && isWallInNorth && south && east && west)return YES;
    else if(northWestPushable && northEastPushable && north && isWallInSouth && east && west)return YES;
    else if(northWestPushable && southWestPushable && north && south && isWallInEast && west)return YES;
    else if(northEastPushable && southEastPushable && north && south && east && isWallInWest)return YES;
    
    else if(southEastPushable && south && east && isWallInNorth && isWallInWest)return YES;
    else if(southWestPushable && south && west && isWallInNorth && isWallInEast)return YES;
    else if(northEastPushable && north && east && isWallInSouth && isWallInWest)return YES;
    else if(northWestPushable && north && west && isWallInSouth && isWallInEast)return YES;
    
    else return NO;
}
        
-(void)turnToCheese
{
    CTCheese *cheese = [[CTCheese alloc]initWithOwningGrid:self.grid];
    cheese.location = self.location;
    cheese.position = self.position;
    [self.grid addCheese:cheese];
    [cheese release];
    [self.grid.cats removeObject:self];
    [self.grid removeChild:self cleanup:YES];
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
