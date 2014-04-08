//
//  CTCat.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTCat.h"
#import "CTGridManager.h"

@implementation CTCat

@synthesize isCheese;

- (id)init
{
    self = [super init];
    if (self) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"cat.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
    }
      
    return self;
}

-(void)makeDecision 
{
    
}

-(bool)move:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        if(![self isWallInDirection:direction] && ![grid getElementForLocation:CGPointMake(self.location.x, self.location.y+1)])
        {
            self.position = CGPointMake(self.position.x,self.position.y+grid.blockSize);
            return YES;
        }
    }
    
    else if(direction == CTSouth)
    {
        if(![self isWallInDirection:direction] && ![grid getElementForLocation:CGPointMake(self.location.x, self.location.y+1)])
        {
            self.position = CGPointMake(self.position.x,self.position.y-grid.blockSize);
            return YES;
        }
    }
    
    else if(direction == CTEast)
    {
        if(![self isWallInDirection:direction] && ![grid getElementForLocation:CGPointMake(self.location.x, self.location.y+1)])
        {
            self.position = CGPointMake(self.position.x+grid.blockSize,self.position.y);
            return YES;
        }
    }
    
    else if(direction == CTWest)
    {
        if(![self isWallInDirection:direction] && ![grid getElementForLocation:CGPointMake(self.location.x, self.location.y+1)])
        {
            self.position = CGPointMake(self.position.x-grid.blockSize,self.position.y);
            return YES;
        }
    }
    
    return NO;
}

-(bool)pushableInDirection:(CTDirection)direction
{
    if(![self isWallInDirection:direction] && [self getElementInDirection:direction] == NULL)
    {
        [self move:direction];
        return YES;
    }
    
    else
    {
        if(![self isWallInDirection:direction] && [self getElementInDirection:direction] && [[self getElementInDirection:direction]pushableInDirection:direction])
        {
            [self move:direction];
            return YES;
        }
        
        else return NO;
    }
}

-(void)turnToCheese
{
    
}

-(void)animateOut
{
    
}

-(void)animateIn
{
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
