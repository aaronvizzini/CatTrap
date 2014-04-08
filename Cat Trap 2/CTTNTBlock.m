//
//  CTTNTBlock.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/1/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTTNTBlock.h"
#import "CTGridManager.h"
#import "CTMouse.h"
#import "CTCat.h"
#import "SimpleAudioEngine.h"

#define kParticleSysTag 241

@implementation CTTNTBlock

#pragma mark -
#pragma mark Init Method

-(id)initWithOwningGrid:(CTGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    if (self) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"TNTBlock.png"];
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
        
        self.spriteType = CTTNTBlockPushable;
        
        isPrimed = NO;
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Overriden move method

-(bool)move:(CTDirection)direction
{
    CGPoint mouseLocation = [self.grid mouse].location;
    CGPoint locationInBehind = CGPointZero;
    
    if(direction == CTNorth) locationInBehind = CGPointMake(self.location.x, self.location.y - 1);

    if(direction == CTSouth) locationInBehind = CGPointMake(self.location.x, self.location.y + 1);
    
    if(direction == CTEast) locationInBehind = CGPointMake(self.location.x - 1, self.location.y);
    
    if(direction == CTWest) locationInBehind = CGPointMake(self.location.x + 1, self.location.y);
    
    
    if(CGPointEqualToPoint(mouseLocation, locationInBehind))
    {
        if(!isPrimed)[self primeFuse];
    }
    
    return [super move:direction];
}

#pragma mark -
#pragma mark Explosion Methods

-(void)primeFuse
{
    isPrimed = YES;
    id action1 = [CCTintTo actionWithDuration:.2f red:255 green:255 blue:255];
    id action2 = [CCTintTo actionWithDuration:.2f red:255/2 green:255/2 blue:255/2];
    [self runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:action1, action2, nil] times:5], [CCCallFunc actionWithTarget:self selector:@selector(detonate)], nil]];
}

-(void)detonate
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Explosion.wav"];
    [self.parent reorderChild:self z:20]; 
    
    CGRect rectX = [self textureRect];
    
    CCParticleExplosion *explosion = [CCParticleExplosion node];
    explosion.speed = 200;
    [explosion setLife:.5f];
    [explosion setLifeVar:.1f];
    [explosion setTotalParticles:100];
    [explosion setSpeedVar:70];
    
    [explosion setStartColor:ccc4FFromccc3B(ccc3(255, 255, 0))];
    [explosion setStartColorVar:ccc4FFromccc3B(ccc3(0, 0, 0))];
    
    [explosion setEndColor:ccc4FFromccc3B(ccc3(238, 0, 0))];
    [explosion setEndColorVar:ccc4FFromccc3B(ccc3(0, 0, 0))];
    
    explosion.position = ccp(rectX.size.width/2, rectX.size.height/2);
    explosion.scale = .2f;
    
    [self addChild:explosion z:2 tag:kParticleSysTag];
    [explosion resetSystem];

    [self performSelector:@selector(removeSelf) withObject:nil afterDelay:.6f];
    [self runAction:[CCFadeOut actionWithDuration:.4f]];
    [self performDamage];
}

-(void)removeSelf
{
    [self removeChildByTag:kParticleSysTag cleanup:YES];
    [self.grid.pushables removeObject:self];
    [self.parent removeChild:self cleanup:YES];
}

-(void)performDamage
{
    CTPushable *nPushable = [self.grid getPushableForLocation:CGPointMake(self.location.x, self.location.y+1)];
    CTPushable *sPushable = [self.grid getPushableForLocation:CGPointMake(self.location.x, self.location.y-1)];
    CTPushable *ePushable = [self.grid getPushableForLocation:CGPointMake(self.location.x+1, self.location.y)];
    CTPushable *wPushable = [self.grid getPushableForLocation:CGPointMake(self.location.x-1, self.location.y)];
    
    CTPushable *nwPushable = [self.grid getPushableForLocation:CGPointMake(self.location.x-1, self.location.y+1)];
    CTPushable *swPushable = [self.grid getPushableForLocation:CGPointMake(self.location.x-1, self.location.y-1)];
    CTPushable *nePushable = [self.grid getPushableForLocation:CGPointMake(self.location.x+1, self.location.y+1)];
    CTPushable *sePushable = [self.grid getPushableForLocation:CGPointMake(self.location.x+1, self.location.y-1)];
    
    if([nPushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)nPushable;
        [cat turnToCheese];
    }
    
    else if([nPushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)nPushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:nPushable cleanup:YES];
        [self.grid.pushables removeObject:nPushable];
    }
    
    if([sPushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)sPushable;
        [cat turnToCheese];
    }
    
    else if([sPushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)sPushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:sPushable cleanup:YES];
        [self.grid.pushables removeObject:sPushable];
    }
    
    if([ePushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)ePushable;
        [cat turnToCheese];
    }
    
    else if([ePushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)ePushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:ePushable cleanup:YES];
        [self.grid.pushables removeObject:ePushable];
    }
    
    if([wPushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)wPushable;
        [cat turnToCheese];
    }
    
    else if([wPushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)wPushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:wPushable cleanup:YES];
        [self.grid.pushables removeObject:wPushable];
    }
    
    if([nwPushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)nwPushable;
        [cat turnToCheese];
    }
    
    else if([nwPushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)nwPushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:nwPushable cleanup:YES];
        [self.grid.pushables removeObject:nwPushable];
    }
    
    if([swPushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)swPushable;
        [cat turnToCheese];
    }
    
    else if([swPushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)swPushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:swPushable cleanup:YES];
        [self.grid.pushables removeObject:swPushable];
    }
    
    if([nePushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)nePushable;
        [cat turnToCheese];
    }
    
    else if([nePushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)nePushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:nePushable cleanup:YES];
        [self.grid.pushables removeObject:nePushable];
    }
    
    if([sePushable isKindOfClass:[CTCat class]]) 
    {
        CTCat *cat = (CTCat *)sePushable;
        [cat turnToCheese];
    }
    
    else if([sePushable isKindOfClass:[self class]])
    {
        CTTNTBlock *tnt = (CTTNTBlock *)sePushable;
        [tnt primeFuse];
    }
    
    else
    {
        [self.grid removeChild:sePushable cleanup:YES];
        [self.grid.pushables removeObject:sePushable];
    }
    
    CGPoint mouseLocation = [self.grid mouse].location;
    
    CGPoint mouseNorth = CGPointMake(self.location.x, self.location.y - 1);
    CGPoint mouseSouth = CGPointMake(self.location.x, self.location.y + 1);
    CGPoint mouseEast = CGPointMake(self.location.x - 1, self.location.y);
    CGPoint mouseWest = CGPointMake(self.location.x + 1, self.location.y);
    
    CGPoint mouseNorthEast = CGPointMake(self.location.x + 1, self.location.y + 1);
    CGPoint mouseNorthWest = CGPointMake(self.location.x - 1, self.location.y + 1);
    CGPoint mouseSouthEast = CGPointMake(self.location.x + 1, self.location.y - 1);
    CGPoint mouseSouthWest = CGPointMake(self.location.x - 1, self.location.y - 1);
    
    if(CGPointEqualToPoint(mouseLocation, mouseNorth) || CGPointEqualToPoint(mouseLocation, mouseSouth) || CGPointEqualToPoint(mouseLocation, mouseEast) || CGPointEqualToPoint(mouseLocation, mouseWest) || CGPointEqualToPoint(mouseLocation, mouseNorthEast) || CGPointEqualToPoint(mouseLocation, mouseNorthWest) || CGPointEqualToPoint(mouseLocation, mouseSouthEast) || CGPointEqualToPoint(mouseLocation, mouseSouthWest))
    {
        [self.grid.mouse needsToBurn];
    }
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [super dealloc];
}

@end
