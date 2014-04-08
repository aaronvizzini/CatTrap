//
//  GameplayController.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "GameplayController.h"
#import "CTMouse.h"

#define kSwipeDistance 65
#define kSwipeMarginOfError 75
#define kHoldMoveDelay .15

@implementation GameplayController

- (id)init
{
    self = [super init];
    if (self) {
        touchStartPoint = CGPointZero;
        [self setIsTouchEnabled:YES];
        
        grid = [[CTGridManager alloc]initWithLevelString:nil];
        [self addChild:grid];
        
        isTouchHeld = NO;
    }
    //
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    touchStartPoint = point;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y < touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveUp) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveUp) forTarget:self interval:kHoldMoveDelay paused:NO];
    }
    
    else if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y > touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveDown) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveDown) forTarget:self interval:kHoldMoveDelay paused:NO];
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x > touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveRight) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveRight) forTarget:self interval:kHoldMoveDelay paused:NO];
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x < touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveLeft) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveLeft) forTarget:self interval:kHoldMoveDelay paused:NO];
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];

    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y < touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        [self moveUp];
    }
    
    else if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y > touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        [self moveDown];
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x > touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        [self moveRight];
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x < touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        [self moveLeft];
    }
    
    isTouchHeld
    
}

-(void)moveUp
{
    isTouchHeld = YES;
    [grid.mouse move:CTNorth];
}

-(void)moveDown
{
    [grid.mouse move:CTSouth];
}

-(void)moveRight
{
    [grid.mouse move:CTEast];
}

-(void)moveLeft
{
    [grid.mouse move:CTWest];
}

- (void)dealloc
{
    [grid release];
    [super dealloc];
}

@end
