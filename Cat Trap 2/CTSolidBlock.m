//
//  CTSolidBlock.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/16/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTSolidBlock.h"


@implementation CTSolidBlock

#pragma mark -
#pragma mark Init Method

-(id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"GrayBlock.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
        
        self.spriteType = CTSolidBlockPushable;
    }
    
    return self;
}

#pragma mark -
#pragma mark Overriden pushable method

-(bool)pushableInDirection:(CTDirection)direction
{
    return NO;
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}
@end
