//
//  CTGridManager.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CTGridManager.h"
#import "SimpleAudioEngine.h"

//Blocks
#import "CTBasicBlock.h"
#import "CTLeadBlock.h"
#import "CTSolidBlock.h"
#import "CTFishBlock.h"
#import "CTFireBlock.h"
#import "CTTNTBlock.h"

//Elements
#import "CTStickyTrap.h"
#import "CTMouseTrap.h"
#import "CTPortal.h"
#import "CTDogTrigger.h"

//Main Game Sprites
#import "CTCat.h"
#import "CTDog.h"
#import "CTMouse.h"
#import "CTCheese.h"

//Support
#import "CCArray.h"
#import "CTSprite.h"
#import "CTPushable.h"
#import "CTLevel.h"
#import "CTGameDisplayController.h"
#import "CTGameModeManager.h"

#define kBgSize kGridSize * kGridBlockSize
#define kDefaultMousePoint ccp(160,240)

#define kCatZ 6
#define kMouseZ 5
#define kPushableZ 4
#define kCheeseZ 3
#define kElementZ 2
#define kBackgroundZ 1

#define discoSpeed .3

#define blockAppearSpeedMax 8 //is equal to .8 when converted to decimal
#define blockAppearSpeedMin 3 

#define kRegenerateHealthNumber 25

@implementation CTGridManager

@synthesize mousePoint, pushables, cats, mouse, size, blockSize, elements, cheese, gameDisplayController, level, gameModeManager;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) 
    {       
        size = kGridSize;
        blockSize = kGridBlockSize;
        
        mousePoint = CGPointZero;
        pushables = [[CCArray alloc]init];
        cats = [[CCArray alloc]init];
        elements = [[CCArray alloc]init];
        cheese = [[CCArray alloc]init];
        
        mouse = [[CTMouse alloc]initWithOwningGrid:self];
        [self addChild:mouse z:kMouseZ];
        
        catsRequired = 0;
        wavesRequired = 0;
        
        [[CCScheduler sharedScheduler]scheduleSelector:@selector(update:) forTarget:self interval:1.0f paused:NO];
        [[CCScheduler sharedScheduler]pauseTarget:self];
    }
    
    return self;
}

-(void) update: (ccTime) dt
{
    if(self.gameModeManager)[gameModeManager update:dt];
}

#pragma mark -
#pragma mark level handling methods

-(void)loadLevel:(CTLevel *)theLevel
{
    [[CCScheduler sharedScheduler]pauseTarget:self];
    
    for(CTCheese *c in cheese)[self removeChild:c cleanup:YES];
    for(CTCat *cat in cats)[self removeChild:cat cleanup:YES];
    for(CTPushable *pushable in pushables)[self removeChild:pushable cleanup:YES];
    for(CTElement *element in elements)[self removeChild:element cleanup:YES];
    
    [self removeChild:bg cleanup:YES];
    if([bg2 parent]==self)[self removeChild:bg2 cleanup:YES];
    
    [cheese removeAllObjects];
    [cats removeAllObjects];
    [pushables removeAllObjects];
    [elements removeAllObjects];
    
    self.level = theLevel;

    [mouse reset];
    mouse.location = CGPointMake((self.size+1)/2, (self.size+1)/2);
    mouse.position = [self positionForLocation:mouse.location];
    
    [self loadString:theLevel.data];
    [self createBackgroundForType:theLevel.bg];
    
    wavesRequired = theLevel.waveCount;
    [self createCatWaveOfSize:self.level.firstWaveSize];
        
    [[CCScheduler sharedScheduler] resumeTarget:self];
}

-(void)createBackgroundForType:(CTBackgroundType)backgroundType
{
    ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};

    if(backgroundType == CTWoodBackground)bg = [CCSprite spriteWithFile:@"BG_Wood.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];
    else if(backgroundType == CTMetalBackground)bg = [CCSprite spriteWithFile:@"BG_Metal.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];  
    else if(backgroundType == CTGrassBackground)bg = [CCSprite spriteWithFile:@"BG_Grass.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];
    else if(backgroundType == CTDiscoBackground)
    {
        discoValue = NO;

        bg = [CCSprite spriteWithFile:@"BG_Disco.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];
        bg2 = [CCSprite spriteWithFile:@"BG_Disco2.png" rect:CGRectMake(0.0, 0.0, kBgSize, kBgSize)];
        id action = [CCCallFunc actionWithTarget:self selector:@selector(_alternateBackground)]; 
        id action2 = [CCDelayTime actionWithDuration:discoSpeed];
        id sequence = [CCSequence actions:action, action2, nil];
        [mouse runAction:[CCRepeat actionWithAction:sequence times:-1]];
        
        [bg.texture setTexParameters: &params];
        bg.position = CGPointMake(kBgSize/2 + 3, kFooterHeaderSize + 9 + kBgSize/2);
        [self addChild:bg z:kBackgroundZ];
        
        [bg2.texture setTexParameters: &params];
        bg2.position = CGPointMake(kBgSize/2 + 3, kFooterHeaderSize + 9 + kBgSize/2);
        [self addChild:bg2 z:kBackgroundZ];
        [bg2 setVisible:NO];
        
        return;
    }
    
    [bg.texture setTexParameters: &params];
    bg.position = CGPointMake(kBgSize/2 + 3, kFooterHeaderSize + 9 + kBgSize/2);
    [self addChild:bg z:kBackgroundZ];
}

#pragma mark -Disco Background method-

-(void)_alternateBackground
{     
    [bg setVisible:discoValue];
    [bg2 setVisible:!discoValue];
    
    discoValue = !discoValue;
}

-(void)loadString:(NSString *)theString
{
    [self pauseGrid];
    
    int y = 1;
    int x = 1;
        
    for (int i = 0; i < theString.length; i++) 
    {
        int currentVal = [theString characterAtIndex:i];
        CGPoint blockPosition = [self positionForLocation:CGPointMake(y, x)]; //x y
        
        CTSprite *ctSprite = nil;
        
        if(currentVal == CTEmptySpace){}
        else if(currentVal == CTRegularBlockItem)ctSprite = [[CTBasicBlock alloc]initWithOwningGrid:self];//Basic
        else if(currentVal == CTSolidBlockItem)ctSprite = [[CTSolidBlock alloc]initWithOwningGrid:self];
        else if(currentVal == CTLeadBlockItem)ctSprite = [[CTLeadBlock alloc]initWithOwningGrid:self];
        else if(currentVal == CTFireBlockItem)ctSprite = [[CTFireBlock alloc]initWithOwningGrid:self];
        else if(currentVal == CTFishBlockItem)ctSprite = [[CTFishBlock alloc]initWithOwningGrid:self];
        else if(currentVal == CTMouseTrapItem)ctSprite = [[CTMouseTrap alloc]initWithOwningGrid:self];
        else if(currentVal == CTStickyTrapItem)ctSprite = [[CTStickyTrap alloc]initWithOwningGrid:self];
        else if(currentVal == CTPortalItem)ctSprite = [[CTPortal alloc]initWithOwningGrid:self];
        else if(currentVal == CTDogTriggerItem)ctSprite = [[CTDogTrigger alloc]initWithOwningGrid:self];
        else if(currentVal == CTTNTItem)ctSprite = [[CTTNTBlock alloc]initWithOwningGrid:self];
        
        if(ctSprite != nil)
        {
            ctSprite.position = ccp(160,240);
            ctSprite.location = CGPointMake(x, y);//Reveresed only due to Cocos2d reveserve x/y plain. //y x
            
            if(currentVal != CTMouseTrapItem && currentVal != CTStickyTrapItem && currentVal != CTDogTriggerItem && currentVal != CTPortalItem)
            {
                [pushables addObject:ctSprite];
                [self addChild:ctSprite z:kPushableZ];
            }
            
            else
            {
                [elements addObject:ctSprite];
                
                [self addChild:ctSprite z:kElementZ];
            }
            
            float delay = (((arc4random() % (blockAppearSpeedMax-blockAppearSpeedMin)) + 1)/10.0f)+blockAppearSpeedMin/10.0f;
            id flyInAction = [CCMoveTo actionWithDuration:delay position:blockPosition];
            [ctSprite runAction:[CCEaseSineIn actionWithAction:flyInAction]];
            
            [ctSprite release];
        }
                 
        if(y == self.size)
        {
            y = 1;
            
            if(x == self.size)break;
            x++;
        }
        
        else y++;
        
    }

    [self performSelector:@selector(unpauseGrid) withObject:nil afterDelay:(blockAppearSpeedMax+1)/10.0f];
}

#pragma mark -
#pragma mark location and ocupation methods

-(CGPoint)positionForLocation:(CGPoint)location
{
    int locationX = location.x;
    int locationY = location.y;
    float positionX = 0.0f;
    float positionY = 0.0f;
        
    positionX = kFooterHeaderSize + (locationX * (self.blockSize));
    positionY = (locationY * (self.blockSize)) - kMarginSize;
        
    return CGPointMake(positionY, positionX);//Reveresed only due to Cocos2d reveserve x/y plain.
}

-(bool)isLocationOccupied:(CGPoint)location
{
    for(CTSprite *sprite in self.pushables)
    {
        if(sprite.position.x == location.x && sprite.position.y == location.y) return YES;
    }
    
    for(CTSprite *cat in self.cats)
    {
        if(cat.position.x == location.x && cat.position.y == location.y) return cat;
    }
    
    return NO;
}

-(CTPushable *)getPushableForLocation:(CGPoint)location
{
    for(CTPushable *sprite in self.pushables)
    {
        if(sprite.location.x == location.x && sprite.location.y == location.y)
        {
            return sprite;
        }
    }
    
    for(CTPushable *cat in self.cats)
    {
        if(cat.location.x == location.x && cat.location.y == location.y) return cat;
    }

    return NULL;
}

#pragma mark -
#pragma mark Cat wave creation menu

-(void)createCatWaveOfSize:(int)waveSize
{
    int totalGridStuff = [self.cats count] + [self.pushables count] + 1;
    if(totalGridStuff >= (kGridSize * kGridSize))return;
    
    catsRequired += waveSize;
    
    for(int i = 0; i < waveSize; i++)
    {
        CGPoint randomLocation = [self getRandomEmptyLocation];
        
        CTCat *cat = [[CTCat alloc]initWithOwningGrid:self];
        cat.location = randomLocation;
        cat.position = [self positionForLocation:CGPointMake(randomLocation.y,randomLocation.x)];// y x Does this need switched? I think NOt
        cat.scale = .0f;
        [cats addObject:cat];
        
        id catAppearAction = [CCScaleTo actionWithDuration:.5f scale:1.0f];
        [cat runAction:catAppearAction];
        
        [cat startAI];
        [cat release];
    }
    
    for(CTCat *cat in self.cats)if([cat parent]!=self)[self addChild:cat z:kCatZ];
}

#pragma mark -
#pragma mark Rnadom Location Utility Methods

-(CGPoint)getRandomEmptyLocation
{
    int x, y; 
    bool validLocation = NO;
    
    while(!validLocation)
    {
        x = (arc4random() % kGridSize) + 1;
        y = (arc4random() % kGridSize) + 1;
        
        if(mouse.location.x == x && mouse.location.y == y)validLocation = NO;
        else validLocation = YES;
        if([self getPushableForLocation:CGPointMake(x, y)]!=NULL)validLocation = NO;
    }
    
    return CGPointMake(x, y);
}

#pragma mark -
#pragma mark cheese handling methods

-(void)addCheese:(CTCheese *)theCheese
{
    [cheese addObject:theCheese];
    [self addChild:theCheese z:kCheeseZ];
}

-(void)collectedCheese:(CTCheese *)theCheese
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Cheese_Collect.wav"];
    
    [cheese removeObject:theCheese];
    [self removeChild:theCheese cleanup:YES];
    [self.gameDisplayController setCheeseCount:self.gameDisplayController.cheeseCount+1 wasABloack:NO];
    
    if(self.gameDisplayController.cheeseCount % kRegenerateHealthNumber == 0 && self.gameDisplayController.cheeseCount > 0)
    {
        if(self.mouse.livesLeft < 5)
        {
            [self.gameDisplayController setMouseLives:self.gameDisplayController.mouseLives+1];
            self.mouse.livesLeft++;
        }
    }
}

-(void)blockCollectedCheese:(CTCheese *)theCheese
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Cheese_Collect.wav"];
    
    [cheese removeObject:theCheese];
    [self removeChild:theCheese cleanup:YES];
    [self.gameDisplayController setCheeseCount:self.gameDisplayController.cheeseCount+1 wasABloack:YES];
    
    if(self.gameDisplayController.cheeseCount % kRegenerateHealthNumber == 0 && self.gameDisplayController.cheeseCount > 0)
    {
        if(self.mouse.livesLeft < 5)
        {
            [self.gameDisplayController setMouseLives:self.gameDisplayController.mouseLives+1];
            self.mouse.livesLeft++;
        }
    }
}

#pragma mark -
#pragma mark game state methods

-(void)gameOver
{
    [self pauseGrid];
    [self.gameDisplayController displayGameOver];
}

-(void)gameWin
{
    [self pauseGrid];
    [self.gameDisplayController displayGameWin];
}

-(void)pauseGrid
{
    for(CTCat *cat in self.cats)[cat pauseAI];
    self.mouse.canMove = NO;
    for(CTDog *dog in self.pushables)
    {
        if([dog isKindOfClass:[CTDog class]])[dog pauseAI];
    }
    [[CCScheduler sharedScheduler]pauseTarget:self];
    
    for(CTPushable *pushable in self.pushables)
    {
        [pushable pauseSchedulerAndActions];
    }
}

-(void)unpauseGrid
{
    for(CTCat *cat in self.cats)[cat startAI];
    self.mouse.canMove = YES;
    for(CTDog *dog in self.pushables)
    {
        if([dog isKindOfClass:[CTDog class]])[dog startAI];
    }
    
    [[CCScheduler sharedScheduler]resumeTarget:self];
    [[CCActionManager sharedManager] resumeTarget:self];

    for(CTPushable *pushable in self.pushables)
    {
        [pushable resumeSchedulerAndActions];
    }
}

-(void)reset
{
    [[CCScheduler sharedScheduler]pauseTarget:self];
    
    [self loadLevel:self.level];
}

#pragma mark -
#pragma mark clean up

- (void)dealloc
{
    [gameModeManager release];
    [level release];
    [cheese release];
    [cats release];
    [pushables release];
    [elements release];
    [mouse release];
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end
