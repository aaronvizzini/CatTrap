//
//  CTElement.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTPushable.h"
#import "CTSprite.h"

@implementation CTPushable

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

#pragma mark -
#pragma mark deafault pushable method

-(bool)pushableInDirection:(CTDirection)direction
{
    return YES;
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}

@end
