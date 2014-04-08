//
//  CTSprite.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTSprite.h"
#import "CTBlock.h"
#import "CTGridManager.h"
#import "CTElement.h"

@implementation CTSprite
@synthesize grid, location;

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super init];
    if (self) {
        // Initialization code here.
        grid = theGrid;
    }
    
    return self;
}

-(CTElement *)getElementInDirection:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        CGPoint northPoint = CGPointMake(self.location.x, self.location.y+1);
        return [grid getElementForLocation:northPoint];
    }
    
    else if(direction == CTSouth)
    {
        CGPoint southPoint = CGPointMake(self.location.x, self.location.y-1);
        return [grid getElementForLocation:southPoint];
    }
    
    else if(direction == CTEast)
    {
        CGPoint eastPoint = CGPointMake(self.location.x+1, self.location.y);
        return [grid getElementForLocation:eastPoint];
    }
    
    else
    {
        CGPoint westPoint = CGPointMake(self.location.x-1, self.location.y);
        return [grid getElementForLocation:westPoint];
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
    
    return NO;//Subclasses override and define their own move behavior.
}

- (void)dealloc
{
    [super dealloc];
}

@end
