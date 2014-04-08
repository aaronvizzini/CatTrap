//
//  CTLeadBlock.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/16/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTLeadBlock.h"


@implementation CTLeadBlock

#pragma mark -
#pragma mark Init Method

-(id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"BlackBlock.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
        
        self.spriteType = CTLeadBlockPushable;
    }
    
    return self;
}

#pragma mark -
#pragma mark overridden pushable method

-(bool)pushableInDirection:(CTDirection)direction
{
    CTDirection oppDir = (direction == CTNorth) ? CTSouth : (direction == CTSouth) ? CTNorth : (direction == CTEast) ? CTWest : CTEast;
    
    if(![self isWallInDirection:direction] && [self getPushableInDirection:direction] == NULL && [self getPushableInDirection:oppDir] == NULL)
    {
        [self move:direction];
        return YES;
    }
    
    else return NO;
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}

@end
