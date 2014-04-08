//
//  CTBasicBlock.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTBasicBlock.h"
#import "CTGridManager.h"

@implementation CTBasicBlock

-(id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"block.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
    }
    
    return self;
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

-(bool)move:(CTDirection)direction
{
    if(direction == CTNorth)
    {
        return [super move:direction];
    }
    
    else if(direction == CTSouth)
    {
        return [super move:direction];
    }
    
    else if(direction == CTEast)
    {
        return [super move:direction];
    }
    
    else if(direction == CTWest)
    {
        return [super move:direction];
    }
    
    return NO;
}

- (void)dealloc
{
    [super dealloc];
}

@end
