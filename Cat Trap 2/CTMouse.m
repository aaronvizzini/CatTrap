//
//  CTMouse.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTMouse.h"
#import "CTGridManager.h"

@implementation CTMouse
@synthesize livesLeft;

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
        self.location = CGPointMake(9, 9);
    }
    
    return self;
}

-(bool)move:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        if(![self isWallInDirection:direction] && ([[grid getElementForLocation:CGPointMake(self.location.x, self.location.y+1)]pushableInDirection:direction] || [grid getElementForLocation:CGPointMake(self.location.x, self.location.y+1)] == NULL))
        {
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    else if(direction == CTSouth)
    {
        if(![self isWallInDirection:direction] && ([[grid getElementForLocation:CGPointMake(self.location.x, self.location.y-1)]pushableInDirection:direction] || [grid getElementForLocation:CGPointMake(self.location.x, self.location.y-1)] == NULL))
        {
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    else if(direction == CTEast)
    {
        if(![self isWallInDirection:direction] && ([[grid getElementForLocation:CGPointMake(self.location.x+1, self.location.y)]pushableInDirection:direction] || [grid getElementForLocation:CGPointMake(self.location.x+1, self.location.y)] == NULL))
        {
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    else if(direction == CTWest)
    {
        if(![self isWallInDirection:direction] && ([[grid getElementForLocation:CGPointMake(self.location.x-1, self.location.y)]pushableInDirection:direction] || [grid getElementForLocation:CGPointMake(self.location.x-1, self.location.y)] == NULL))
        {
            [super move:direction];
            [self assessLcoation];
            return YES;
        }
    }
    
    return NO;
}

-(void)needsToDie
{
    
}

-(void)assessLcoation
{
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
