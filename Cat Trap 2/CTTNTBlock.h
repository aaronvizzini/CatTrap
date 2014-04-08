//
//  CTTNTBlock.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/1/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "CTBlock.h"

@interface CTTNTBlock : CTBlock
{
    bool isPrimed;
}

-(void)primeFuse;
-(void)detonate;
-(void)performDamage;

@end
