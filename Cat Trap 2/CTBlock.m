//
//  CTBlock.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTBlock.h"
#import "CTCheese.h"
#import "CTGridManager.h"

@implementation CTBlock

#pragma mark -
#pragma mark Init Method

-(id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
    }
    
    return self;
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
#pragma mark location assession method

-(void)assessLcoationForDirection:(CTDirection)direction
{
    int currentY = (direction == CTNorth) ? self.location.y + 1 : (direction == CTSouth) ? self.location.y - 1 : self.location.y;
    int currentX = (direction == CTEast) ? self.location.x + 1 : (direction == CTWest) ? self.location.x - 1 : self.location.x;
    
    bool finished = NO;
    
    while(!finished)
    {
        finished = YES;
        
        for(int i = 0; i<[self.grid.cheese count]; i++)
        {
            CTCheese *cheese = [self.grid.cheese objectAtIndex:i];
            
            if(cheese != nil && cheese.location.x == currentX && cheese.location.y == currentY)
            {
                [self.grid blockCollectedCheese:cheese];
                finished = NO;
            }
        }
    }
}

#pragma mark -
#pragma mark Overriden move method
-(bool)move:(CTDirection)direction
{
    [self assessLcoationForDirection:direction];
    return [super move:direction];
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}

@end
