//
//  LevelCreatorLayer.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/3/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "LevelCreatorLayer.h"

#import "CTBasicBlock.h"
#import "CTFishBlock.h"
#import "CTLeadBlock.h"
#import "CTMouseTrap.h"
#import "CTDogTrigger.h"
#import "CTSolidBlock.h"
#import "CTFireBlock.h"
#import "CTStickyTrap.h"
#import "CTPortal.h"
#import "MainMenuScene.h"
#import "SpriteRect.h"
#import "CTLevel.h"
#import "FileHelper.h"
#import "CustomLevelMenuScene.h"
#import "CTTNTBlock.h"
#import "SimpleAudioEngine.h"

#define kFingerBuffer 35
#define discoSpeed .3
#define kBgSize kGridSize * kGridBlockSize
#define kBackGroundZ 1
#define kRepeatActionTag 1
#define kBgTag 1
#define kBg2Tag 2
#define kCreatorYAdjustment 47

@implementation LevelCreatorLayer
@synthesize selectedSprite;

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.isTouchEnabled = YES;
        
        levelNameCurrentlyEditing = nil;
         
        selectedItemType = -1;
        lastItemType = CTRegularBlockItem;
        allItems = [[NSMutableArray alloc]init];
        self.selectedSprite = nil;
        
        saveButton = [CCSprite spriteWithFile:@"continueButton.png"];
        saveButton.position = ccp(160,452);
        
        quitButton = [CCSprite spriteWithFile:@"quitButton.png"];
        quitButton.position = ccp(20,452);
        
        restartButton = [CCSprite spriteWithFile:@"restartButton.png"];
        restartButton.position = ccp(295,452);
        
        paintBrush = [CCSprite spriteWithFile:@"paintBrush.png"];
        paintBrush.position = ccp(268, 54);
        
        [self addChild:quitButton];
        [self addChild:saveButton];
        [self addChild:restartButton];
        [self addChild:paintBrush];
        
        [self createBackgroundForType:CTWoodBackground];
        
        bgMenu = [BackgroundSelectMenu node];
        bgMenu.delegate = self;
        [self addChild:bgMenu z:3];
        
        currentBg = CTWoodBackground;
        
        saveMenu = [SaveLevelMenu node];
        saveMenu.delegate = self;
        [self addChild:saveMenu z:4];
        
        undoStack = [[NSMutableArray alloc]init];
        redoStack = [[NSMutableArray alloc]init];
        
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    }
    
    return self;
}

-(void)editLevelWithName:(NSString *)levelName
{
    [levelNameCurrentlyEditing release];
    levelNameCurrentlyEditing = [levelName retain];
    
    CTLevel *editingLevel = [[CTLevel alloc]initFromFile:[[FileHelper getCustomLevelsDirectory]stringByAppendingPathComponent:levelName]];
    
    [self loadString: editingLevel.data];
    [self createBackgroundForType:editingLevel.bg];
    
    [editingLevel release];
}

-(void)loadString:(NSString *)theString
{    
    int y = 1;
    int x = 1;
    
    for (int i = 0; i < theString.length; i++) 
    {
        int currentVal = [theString characterAtIndex:i];
        CGPoint blockPosition = [self positionForLocation:CGPointMake(y, x)];// x y
        
        CTSprite *ctSprite = nil;
        
        if(currentVal == CTEmptySpace){}
        else if(currentVal == CTRegularBlockItem)ctSprite = [[CTBasicBlock alloc]initWithOwningGrid:nil];
        else if(currentVal == CTSolidBlockItem)ctSprite = [[CTSolidBlock alloc]initWithOwningGrid:nil];
        else if(currentVal == CTLeadBlockItem)ctSprite = [[CTLeadBlock alloc]initWithOwningGrid:nil];
        else if(currentVal == CTFireBlockItem)ctSprite = [[CTFireBlock alloc]initWithOwningGrid:nil];
        else if(currentVal == CTFishBlockItem)ctSprite = [[CTFishBlock alloc]initWithOwningGrid:nil];
        else if(currentVal == CTMouseTrapItem)ctSprite = [[CTMouseTrap alloc]initWithOwningGrid:nil];
        else if(currentVal == CTStickyTrapItem)ctSprite = [[CTStickyTrap alloc]initWithOwningGrid:nil];
        else if(currentVal == CTPortalItem)ctSprite = [[CTPortal alloc]initWithOwningGrid:nil];
        else if(currentVal == CTDogTriggerItem)ctSprite = [[CTDogTrigger alloc]initWithOwningGrid:nil];
        else if(currentVal == CTTNTItem)ctSprite = [[CTTNTBlock alloc]initWithOwningGrid:nil];
        
        if(ctSprite != nil)
        {
            ctSprite.location = CGPointMake(x, y);//Reveresed only due to Cocos2d reveserve x/y plain.//y x
        
            [allItems addObject:ctSprite];
                
            [self addChild:ctSprite z:2];
            
            ctSprite.position = blockPosition;

            [ctSprite release];
        }
        
        if(y == kGridSize)
        {
            y = 1;
            
            if(x == kGridSize)break;
            x++;
        }
        
        else y++;
    }
}

-(void)createBackgroundForType:(CTBackgroundType)backgroundType
{
    currentBg = backgroundType;

    self.isTouchEnabled = YES;
    
    [self stopActionByTag:kRepeatActionTag];
    if([self getChildByTag:kBgTag])[bg removeFromParentAndCleanup:YES];
    if([self getChildByTag:kBg2Tag])[bg2 removeFromParentAndCleanup:YES];
    
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
        id repeatAction = [CCRepeat actionWithAction:sequence times:-1];
        [self runAction:repeatAction];
        [repeatAction setTag:kRepeatActionTag];
        
        [bg.texture setTexParameters: &params];
        bg.position = CGPointMake(kBgSize/2 + 3, ((kFooterHeaderSize + 9 + kBgSize/2)-23.5)+kCreatorYAdjustment);
        [self addChild:bg z:kBackGroundZ tag:kBgTag];
        
        [bg2.texture setTexParameters: &params];
        bg2.position = CGPointMake(kBgSize/2 + 3, ((kFooterHeaderSize + 9 + kBgSize/2)-23.5)+kCreatorYAdjustment);
        [self addChild:bg2 z:kBackGroundZ tag:kBg2Tag];
        [bg2 setVisible:NO];
        
        return;
    }
    
    [bg.texture setTexParameters: &params];
    bg.position = CGPointMake(kBgSize/2 + 3, ((kFooterHeaderSize + 9 + kBgSize/2)-23.5)+kCreatorYAdjustment);
    [self addChild:bg z:kBackGroundZ tag:kBgTag];
    
}

#pragma mark -Disco Background method-

-(void)_alternateBackground
{     
    [bg setVisible:discoValue];
    [bg2 setVisible:!discoValue];
    
    discoValue = !discoValue;
}

#pragma mark -
#pragma mark Touch methods

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
                 
    touchStartPoint = point;
    
    if(point.x > 18 && point.x < 45 && point.y < 415 && point.y > 388)
    {
        selectedItemType = CTRegularBlockItem;
        lastItemType = CTRegularBlockItem;
        
        CTBasicBlock *item = [[CTBasicBlock alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
                
        return;
    }
    
    else if(point.x > 58 && point.x < 85 && point.y < 415 && point.y > 388)
    {
        selectedItemType = CTFishBlockItem;
        lastItemType = CTFishBlockItem;
        
        CTFishBlock *item = [[CTFishBlock alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
                
        return;
    }
    
    else if(point.x > 101 && point.x < 129 && point.y < 415 && point.y > 388)
    {
        selectedItemType = CTSolidBlockItem;
        lastItemType = CTSolidBlockItem;
        
        CTSolidBlock *item = [[CTSolidBlock alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    else if(point.x > 142 && point.x < 170 && point.y < 415 && point.y > 388)
    {
        selectedItemType = CTMouseTrapItem;
        lastItemType = CTMouseTrapItem;
        
        CTMouseTrap *item = [[CTMouseTrap alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    else if(point.x > 180 && point.x < 206 && point.y < 415 && point.y > 388)
    {
        selectedItemType = CTDogTriggerItem;
        lastItemType = CTDogTriggerItem;
        
        CTDogTrigger *item = [[CTDogTrigger alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    else  if(point.x > 18 && point.x < 45 && point.y < 465 && point.y > 439)
    {
        selectedItemType = CTLeadBlockItem;
        lastItemType = CTLeadBlockItem;
        
        CTLeadBlock *item = [[CTLeadBlock alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    else if(point.x > 58 && point.x < 85 && point.y < 465 && point.y > 439)
    {
        selectedItemType = CTFireBlockItem;
        lastItemType = CTFireBlockItem;
        
        CTFireBlock *item = [[CTFireBlock alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    else if(point.x > 101 && point.x < 129 && point.y < 465 && point.y > 439)
    {
        selectedItemType = CTTNTItem;
        lastItemType = CTTNTItem;
        
        CTTNTBlock *item = [[CTTNTBlock alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    else if(point.x > 142 && point.x < 170 && point.y < 465 && point.y > 439)
    {
        selectedItemType = CTStickyTrapItem;
        lastItemType = CTStickyTrapItem;
        
        CTStickyTrap *item = [[CTStickyTrap alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    else if(point.x > 183 && point.x < 211 && point.y < 465 && point.y > 439)
    {
        selectedItemType = CTPortalItem;
        lastItemType = CTPortalItem;
        
        CTPortal *item = [[CTPortal alloc]initWithOwningGrid:nil];
        [self addChild:item z:3];
        [allItems addObject:item];
        self.selectedSprite = item;
        item.position = ccp(-50,-50);
        [item release];
        return;
    }
    
    selectedItemType = -1;
    
    for(CTSprite *sprite in allItems)
    {
        CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];

        CGPoint local = [sprite convertToNodeSpace:touchLocation];
        CGRect r = [sprite textureRect];
        
        if(CGRectContainsPoint(r, local))
        {
            self.selectedSprite = sprite;
            [self reorderChild:sprite z:[[allItems lastObject]zOrder]+1];
            return;
        }
    }
    
    self.selectedSprite = nil;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    if(selectedSprite != nil)
    {
		CGPoint newPoint = [[CCDirector sharedDirector] convertToGL: point];
        self.selectedSprite.position = CGPointMake(newPoint.x, newPoint.y + kFingerBuffer);
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{        
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    CGPoint convertedPoint = [self convertTouchToNodeSpace:[touches anyObject]];  

    int xDiff = (int)abs(touchStartPoint.x - point.x);
    int yDiff = (int)abs(touchStartPoint.y - point.y);
    
    CGRect saveRect = [self rectForSprite:saveButton];
    CGRect quitRect = [self rectForSprite:quitButton];
    CGRect restartRect = [self rectForSprite:restartButton];
    CGRect paintBrushRect = [self rectForSprite:paintBrush];
    
    if(CGRectContainsPoint(saveRect,convertedPoint) && xDiff < 10 && yDiff < 10 && selectedSprite == nil)
    {
        [self saveClicked];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(quitRect,convertedPoint) && xDiff < 10 && yDiff < 10 && selectedSprite == nil)
    {
        [self quitClicked];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(restartRect, convertedPoint) && xDiff < 10 && yDiff < 10 && selectedSprite == nil)
    {
        [self restartClicked];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }
    
    else if(CGRectContainsPoint(paintBrushRect, convertedPoint) && xDiff < 10 && yDiff < 10 && selectedSprite == nil)
    {
        id tilt1 = [CCRotateBy actionWithDuration:.2f angle:15];
        id tilt2 = [CCRotateBy actionWithDuration:.2f angle:-15];
        id tilting = [CCRepeat actionWithAction:[CCSequence actions:tilt1, tilt2, nil] times:2];
        id callFunct = [CCCallFunc actionWithTarget:self selector:@selector(showBackgroundSelect)];
        
        [paintBrush runAction:[CCSequence actions:tilting, callFunct, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
    }

    if(self.selectedSprite == nil)
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView: [touch view]];
		CGPoint newPoint = [[CCDirector sharedDirector] convertToGL: point];
        
        CTSprite *sprite = nil;
                
        if(lastItemType == CTRegularBlockItem) sprite = [[CTBasicBlock alloc]initWithOwningGrid:nil];
        if(lastItemType == CTFishBlockItem) sprite = [[CTFishBlock alloc]initWithOwningGrid:nil];        
        if(lastItemType == CTSolidBlockItem) sprite = [[CTSolidBlock alloc]initWithOwningGrid:nil];        
        if(lastItemType == CTMouseTrapItem) sprite = [[CTMouseTrap alloc]initWithOwningGrid:nil];
        if(lastItemType == CTDogTriggerItem) sprite = [[CTDogTrigger alloc]initWithOwningGrid:nil];
        if(lastItemType == CTLeadBlockItem) sprite = [[CTLeadBlock alloc]initWithOwningGrid:nil];
        if(lastItemType == CTFireBlockItem) sprite = [[CTFireBlock alloc]initWithOwningGrid:nil];
        if(lastItemType == CTTNTItem) sprite = [[CTTNTBlock alloc]initWithOwningGrid:nil];
        if(lastItemType == CTStickyTrapItem) sprite = [[CTStickyTrap alloc]initWithOwningGrid:nil];
        if(lastItemType == CTPortalItem) sprite = [[CTPortal alloc]initWithOwningGrid:nil];
           
        [self addChild:sprite z:2];
        [allItems addObject:sprite];
        self.selectedSprite = sprite;
        self.selectedSprite.position = newPoint;
        [self placeSelectedBlock];
        [sprite release];
        
        return;
    }
    
    [self reorderChild:self.selectedSprite z:2];
    
    [self placeSelectedBlock];
}

#pragma mark -
#pragma mark button methods

-(void)showBackgroundSelect
{
    self.isTouchEnabled = NO;
    [bgMenu show];
}

-(void)saveClicked
{
    self.isTouchEnabled = NO;
    
    if(levelNameCurrentlyEditing)[saveMenu setLevelToLoadWith:levelNameCurrentlyEditing];
    
    [saveMenu show];
    
    id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
    [saveButton runAction:[CCSequence actions:bounce, nil]];
}

-(void)quitClicked
{    
    id bounce = [CCEaseBounceOut actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:.8f],[CCScaleTo actionWithDuration:.3f scale:1.0f], nil]];
    [quitButton runAction:[CCSequence actions:bounce, [CCCallFunc actionWithTarget:self selector:@selector(quit)], nil]];
}

-(void)restartClicked
{
    id spinAction = [CCRotateBy actionWithDuration:.5f angle:720];
    id callFunc = [CCCallFunc actionWithTarget:self selector:@selector(resetCreator)];
    [restartButton runAction:[CCSequence actions:spinAction, callFunc, nil]];
}

-(void)quit
{
    [[CCDirector sharedDirector] replaceScene:[CustomLevelMenuScene node]];
}

-(void)resetCreator
{
    for(CTSprite *sprite in allItems)[self removeChild:sprite cleanup:YES];
    [allItems removeAllObjects];
    self.selectedSprite = nil;
}

#pragma mark -
#pragma mark Placement methods

-(void)placeSelectedBlock
{    
    float spriteX = selectedSprite.position.x;
    float spriteY = selectedSprite.position.y;
    float blockDiffX = ((spriteX)/kGridBlockSize);
    float blockDiffY = (((spriteY - 51.5f)-kCreatorYAdjustment)/kGridBlockSize);
    
    int blockDiffXFinal = 0, blockDiffYFinal = 0;
    
    if(fmod(blockDiffX, 1) < .5f)blockDiffXFinal = (int)blockDiffX+1;
    else blockDiffXFinal = (int)blockDiffX + 1;
    if(fmod(blockDiffY, 1) < .5f)blockDiffYFinal = (int)blockDiffY+0;
    else blockDiffYFinal = (int)blockDiffY + 1;
    
    if(blockDiffXFinal <= 0)
    {
        [self removeChild:selectedSprite cleanup:YES];
        [allItems removeObject:selectedSprite];
    }
    
    else if(blockDiffYFinal <= 0)
    {
        [self removeChild:selectedSprite cleanup:YES];
        [allItems removeObject:selectedSprite];
    }
    
    else if(blockDiffXFinal >= 20)
    {
        [self removeChild:selectedSprite cleanup:YES];
        [allItems removeObject:selectedSprite];
    }
    
    else if(blockDiffYFinal >= 20)
    {
        [self removeChild:selectedSprite cleanup:YES];
        [allItems removeObject:selectedSprite];
    }
    
    else if(blockDiffXFinal == 10 && blockDiffYFinal == 10)
    {
        [self removeChild:selectedSprite cleanup:YES];
        [allItems removeObject:selectedSprite];
    }
    
    else 
    {
        [redoStack removeAllObjects];
        [undoStack addObject:[self getLevelString]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Creator_Button.wav"];
    }
    
    
    CGPoint finalLocation = CGPointMake(blockDiffXFinal, blockDiffYFinal);//Y X
    
    CTSprite *itemToReplace = nil;

    for(CTSprite *item in allItems)
    {
        if(finalLocation.x == item.location.x && finalLocation.y == item.location.y && item != self.selectedSprite)
        {
            itemToReplace = item;
        }
    }
    
    if(itemToReplace)
    {
        [self removeChild:itemToReplace cleanup:YES];
        [allItems removeObject:itemToReplace];
    }
    
    self.selectedSprite.position = [self positionForLocation:CGPointMake(blockDiffYFinal, blockDiffXFinal)];//Final location
    self.selectedSprite.location = finalLocation;
        
    self.selectedSprite = nil;
}

#pragma mark -
#pragma mark Position and Location methods
                            
-(CGPoint)positionForLocation:(CGPoint)location
{
    int locationX = location.x;
    int locationY = location.y;
    float positionX = 0.0f;
    float positionY = 0.0f;
    
    positionX = (kFooterHeaderSize - 23) + (locationX * (kGridBlockSize)); //24 is a footer diff.
    positionY = ((locationY * (kGridBlockSize)) - kMarginSize);
        
    return CGPointMake(positionY, positionX+kCreatorYAdjustment);//Reveresed only due to Cocos2d reveserve x/y plain.
}

-(CTSprite *)getSpriteForLocation:(CGPoint)location
{
    for(CTSprite *sprite in allItems)
        if(CGPointEqualToPoint(sprite.location,location))return sprite;
    
    return nil;
}

#pragma mark -
#pragma mark BackgroundSelectMenu delegate methods

-(void)didChooseBackground:(CTBackgroundType)bgSelected
{
    currentBg = bgSelected;
    [self createBackgroundForType:bgSelected];
    [bgMenu hide];
    self.isTouchEnabled = YES;
}

#pragma mark -
#pragma mark Save Menu delegate methods

-(NSMutableArray *)getAllElements
{
    return allItems;
}

-(CTBackgroundType)getBackground
{
    return currentBg;
}

-(void)didSave
{
    [saveMenu hide];
    
    self.isTouchEnabled = YES;
    [[CCDirector sharedDirector] replaceScene:[CustomLevelMenuScene node]];
}

-(void)didCancel
{
    [saveMenu hide];
    self.isTouchEnabled = YES;
}

-(NSString *)getLevelString
{
    NSMutableString *levelString = [[[NSMutableString alloc]init]autorelease];
                    
    int y = 1;
    int x = 1;
    
    for (int i = 0; i < (kGridSize*kGridSize); i++) 
    {        
        CTSprite *currentSprite = [self getSpriteForLocation:CGPointMake(x, y)];
        if(currentSprite == nil)[levelString appendString:[NSString stringWithFormat:@"%c",'0']];
        else if(currentSprite.spriteType == CTBasicBlockPushable)[levelString appendString:[NSString stringWithFormat:@"%c",CTRegularBlockItem]];
        else if(currentSprite.spriteType == CTSolidBlockPushable)[levelString appendString:[NSString stringWithFormat:@"%c",CTSolidBlockItem]];
        else if(currentSprite.spriteType == CTLeadBlockPushable)[levelString appendString:[NSString stringWithFormat:@"%c",CTLeadBlockItem]];
        else if(currentSprite.spriteType == CTFishBlockPushable)[levelString appendString:[NSString stringWithFormat:@"%c",CTFishBlockItem]];
        else if(currentSprite.spriteType == CTFireBlockPushable)[levelString appendString:[NSString stringWithFormat:@"%c",CTFireBlockItem]];
        else if(currentSprite.spriteType == CTMouseTrapElement)[levelString appendString:[NSString stringWithFormat:@"%c",CTMouseTrapItem]];
        else if(currentSprite.spriteType == CTStickyTrapElement)[levelString appendString:[NSString stringWithFormat:@"%c",CTStickyTrapItem]];
        else if(currentSprite.spriteType == CTPortalElement)[levelString appendString:[NSString stringWithFormat:@"%c",CTPortalItem]];
        else if(currentSprite.spriteType == CTDogTriggerElement)[levelString appendString:[NSString stringWithFormat:@"%c",CTDogTriggerItem]];
        else if(currentSprite.spriteType == CTTNTBlockPushable)[levelString appendString:[NSString stringWithFormat:@"%c",CTTNTItem]];
        
        if(y == kGridSize)
        {
            y = 1;
            
            if(x == kGridSize)break;
            x++;
        }
        
        else y++;
    }
        
    return levelString;
}

#pragma mark -
#pragma mark Undo/Redo Method

-(void)undo
{
    if([undoStack count] > 0)
    {        
        [self resetCreator];
        [self loadString:[undoStack lastObject]];
                
        [redoStack addObject:[undoStack lastObject]];
        
        [undoStack removeLastObject];
    }
}

-(void)redo
{
    if([redoStack count] > 0)
    {        
        [self resetCreator];
        [self loadString:[redoStack lastObject]];
    
        [undoStack addObject:[redoStack lastObject]];
    
        [redoStack removeLastObject];
    }
}

#pragma mark -
#pragma makr Accelerometer Methods

#define kUndoSensitivity 1.3f

-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
 	if(acceleration.x > kUndoSensitivity)
    {
        [self undo];
    }
}

#pragma mark -
#pragma mark Clean up
                               
-(void)dealloc
{
    [[UIAccelerometer sharedAccelerometer]setDelegate:nil];
    [undoStack release];
    [redoStack release];
    [levelNameCurrentlyEditing release];
    [selectedSprite release];
    [allItems release];
    [super dealloc];
}

@end
