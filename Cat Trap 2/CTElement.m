//
//  CTElement.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTElement.h"
#import "CTSprite.h"

@implementation CTElement
@synthesize elementType;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(bool)pushableInDirection:(CTDirection)direction
{
    return YES;
}

- (void)dealloc
{
    [super dealloc];
}

@end
