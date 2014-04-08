//
//  CreditsMenuScene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 8/5/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CreditsMenuScene.h"
#import "CreditsMenuLayer.h"

@implementation CreditsMenuScene

- (id)init
{
    self = [super init];
    if (self) 
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"blankBackground.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
        
        CCLabelTTF *credits = [CCLabelTTF labelWithString:@"- Development -\nAlternative Visuals\n\n- Programming -\nAaron Vizzini\n\n- Graphics -\nAlex Vizzini\nAaron Vizzini\n\n- Audio -\nPADCDV\nSoundJay\nFlashkit\nSoundSnap\n\n- Special Thanks -\nCocos2d" dimensions:CGSizeMake(300,460) alignment:CCTextAlignmentCenter lineBreakMode:CCLineBreakModeWordWrap fontName:@"WetPaint" fontSize:22];
        credits.position = ccp(160,230);
        credits.color = ccc3(72, 175, 249);
        [self addChild:credits];
        
        [self addChild:[CreditsMenuLayer node]];
    }
    
    return self;
}

@end
