//
//  CTStickyTrap.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/21/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTStickyTrap.h"


@implementation CTStickyTrap

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        self.spriteType = CTStickyTrapElement;
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"stickyTrap.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
    }
    
    return self;
}

@end
