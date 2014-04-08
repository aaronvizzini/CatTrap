//
//  CTElement.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/21/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTElement.h"


@implementation CTElement

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Overriden Move Method

-(bool)move:(CTDirection)direction
{
    return NO;
}

@end
