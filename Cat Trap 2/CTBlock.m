//
//  CTBlock.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTBlock.h"


@implementation CTBlock

-(id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
    }
    
    return self;
}

-(bool)pushableInDirection:(CTDirection)direction
{
    return [super pushableInDirection:direction];
}

-(bool)move:(CTDirection)direction
{
    return [super move:direction];
}

- (void)dealloc
{
    [super dealloc];
}

@end
