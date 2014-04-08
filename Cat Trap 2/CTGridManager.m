//
//  CTGridManager.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTGridManager.h"
#import "CTBasicBlock.h"

@implementation CTGridManager

@synthesize mousePoint, elements, cats, mouse, size, blockSize;

- (id)initWithLevelString:(NSString *)levelString
{
    self = [super init];
    if (self) 
    {
        size = kGridSize;
        blockSize = kGridBlockSize;
        
        mousePoint = CGPointZero;
        elements = [[CCArray alloc]init];
        cats = [[CCArray alloc]init];
        
        mouse = [[CTMouse alloc]initWithOwningGrid:self];
        mouse.position = ccp(160,240);
        [self addChild:mouse z:1];
        
        size = kGridSize;
        blockSize = kGridBlockSize;
        
        [self loadBlocks];
    }
    
    return self;
}

-(void)loadBlocks
{
    double space = 160+self.blockSize;
    int pos = 10;
    
    for(int i = 0; i<=4; i++)
    {
        CTBasicBlock *block = [[CTBasicBlock alloc]initWithOwningGrid:self];
        block.position = ccp(space,240);
        
        space += self.blockSize;
        block.location = CGPointMake(pos, 9);
        pos++;
        [self addChild:block z:1];
        
        [elements addObject:block];
        [block release];
    }
}

-(bool)isLocationOccupied:(CGPoint)location
{
    for(CTSprite *sprite in self.elements)
    {
        if(sprite.position.x == location.x && sprite.position.y == location.y) return YES;
    }
    
    for(CTSprite *cat in self.cats)
    {
        if(cat.position.x == location.x && cat.position.y == location.y) return cat;
    }
    
    return NO;
}

-(CTElement *)getElementForLocation:(CGPoint)location
{

    for(CTElement *sprite in self.elements)
    {
        if(sprite.location.x == location.x && sprite.location.y == location.y)
        {
            return sprite;
        }
    }
    
    for(CTElement *cat in self.cats)
    {
        if(cat.location.x == location.x && cat.location.y == location.y) return cat;
    }

    return NULL;
}

- (void)dealloc
{
    [cats release];
    [elements release];
    [mouse release];
    [super dealloc];
}

@end
