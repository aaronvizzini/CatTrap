//
//  CTSprite.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTSprite.h"
#import "CTBlock.h"
#import "CTGridManager.h"
#import "CTPushable.h"

@implementation CTSprite
@synthesize grid, location, spriteType;

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super init];
    if (self) {
        grid = theGrid;
    }
    
    return self;
}

#pragma mark -
#pragma mark Peripheral Access Methods

-(CTPushable *)getPushableInDirection:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        CGPoint northPoint = CGPointMake(self.location.x, self.location.y+1);
        return [grid getPushableForLocation:northPoint];
    }
    
    else if(direction == CTSouth)
    {
        CGPoint southPoint = CGPointMake(self.location.x, self.location.y-1);
        return [grid getPushableForLocation:southPoint];
    }
    
    else if(direction == CTEast)
    {
        CGPoint eastPoint = CGPointMake(self.location.x+1, self.location.y);
        return [grid getPushableForLocation:eastPoint];
    }
    
    else
    {
        CGPoint westPoint = CGPointMake(self.location.x-1, self.location.y);
        return [grid getPushableForLocation:westPoint];
    }
}

-(bool)isWallInDirection:(CTDirection)direction
{
    if(direction == CTNorth && self.location.y == grid.size)return YES;
    else if(direction == CTSouth && self.location.y - 1 == 0)return YES;
    else if(direction == CTEast && self.location.x == grid.size)return YES;
    else if(direction == CTWest && self.location.x-1 == 0)return YES;
    else return NO;
}

#pragma mark -
#pragma mark movement method

-(bool)move:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        self.position = CGPointMake(self.position.x,self.position.y+grid.blockSize);
        self.location = CGPointMake(self.location.x, self.location.y+1);
        return YES;
    }
    
    else if(direction == CTSouth)
    {
        self.position = CGPointMake(self.position.x,self.position.y-grid.blockSize);
        self.location = CGPointMake(self.location.x, self.location.y-1);
        return YES;
    }
    
    else if(direction == CTEast)
    {
        self.position = CGPointMake(self.position.x+grid.blockSize,self.position.y);
        self.location = CGPointMake(self.location.x+1, self.location.y);
        return YES;
    }
    
    else if(direction == CTWest)
    {
        self.position = CGPointMake(self.position.x-grid.blockSize,self.position.y);
        self.location = CGPointMake(self.location.x-1, self.location.y);
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}

@end
