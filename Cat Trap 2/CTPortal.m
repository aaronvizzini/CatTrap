//
//  CTPortal.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/22/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTPortal.h"
#import "CTGridManager.h"
#import "CTMouse.h"
#import "SimpleAudioEngine.h"

#define SPIN_SPEED .5f
#define SPIN_ANGLE 720
#define SPIN_COUNT 1

@implementation CTPortal

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        self.spriteType = CTPortalElement;
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"portal.png"];
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
#pragma mark teleport methods

-(void)teleport
{   
    [[SimpleAudioEngine sharedEngine] playEffect:@"Warp_Pad.wav"];
    
    self.grid.mouse.canMove = NO;
    
    CCArray *portals = [[CCArray alloc]init];
    
    for(CTElement *element in self.grid.elements)
    {
        if(element.spriteType==CTPortalElement && element != self && ![self.grid getPushableForLocation:element.location])[portals addObject:element];
    }
    
    if ([portals count]<1)
    {
        self.grid.mouse.canMove = YES;
        [portals release];
        return;
    }
    
    int i = arc4random() % [portals count];
    CTElement *element = [portals objectAtIndex:i];
    CTPortal *portal = (CTPortal *)element;
    
    id rotateAction = [CCRepeat actionWithAction:[CCRotateBy actionWithDuration:SPIN_SPEED angle:SPIN_ANGLE] times:SPIN_COUNT];
    id shrinkAction = [CCScaleTo actionWithDuration:SPIN_SPEED scale:0.0];
    id callFunction = [CCCallFuncO actionWithTarget:self selector:@selector(teleportComplete:) object:portal];
    
    [self.grid.mouse runAction:rotateAction];
    [self.grid.mouse runAction:[CCSequence actions:shrinkAction,callFunction,nil]];
    
    [portals release];
}

-(void)teleportComplete:(CTPortal*)portal
{
    self.grid.mouse.location = portal.location;
    self.grid.mouse.position = portal.position;
    
    id rotateAction = [CCRepeat actionWithAction:[CCRotateBy actionWithDuration:SPIN_SPEED angle:SPIN_ANGLE] times:SPIN_COUNT];
    id shrinkAction = [CCScaleTo actionWithDuration:SPIN_SPEED scale:1.0];
    id callFunction = [CCCallFunc actionWithTarget:self selector:@selector(allowMouseToMove)];
    
    [self.grid.mouse runAction:rotateAction];
    [self.grid.mouse runAction:[CCSequence actions:shrinkAction,callFunction,nil]];
}

//Called by selector in timer
-(void)allowMouseToMove
{
    self.grid.mouse.canMove = YES;
}

@end
