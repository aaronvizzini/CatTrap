//
//  CTDogTrigger.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/22/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTDogTrigger.h"
#import "CTDog.h"
#import "CTGridManager.h"

@implementation CTDogTrigger

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        self.spriteType = CTDogTriggerElement;
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"bone.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
    }
    
    return self;
}

#pragma mark -
#pragma mark dog trigger method

-(void)callForDog
{
    CTDog *dog = [[CTDog alloc]initWithOwningGrid:self.grid];
    CGPoint randomLocation = [self.grid getRandomEmptyLocation];
    dog.location = randomLocation;
    dog.position = [self.grid positionForLocation:CGPointMake(randomLocation.y,randomLocation.x)];// y x Does this need switched? I think NOt
    [self.grid addChild:dog z:10];
    [self.grid.pushables addObject:dog];
    dog.scale = 0.0f;
    
    id dogAppearAction = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
    [dog runAction:dogAppearAction];
    
    [dog startAI];
    [dog release];
    
    [self.grid.elements removeObject:self];
    [self.grid removeChild:self cleanup:YES];
}

@end
