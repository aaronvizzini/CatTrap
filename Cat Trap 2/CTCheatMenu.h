//
//  CTCheatMenu.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 7/19/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "CCLayer.h"

@class CTGridManager;

typedef enum {CTInvisible, CTHealth, CTDogCall, CTAllToCheese}CTCheat;

@interface CTCheatMenu : CCLayer <UITextFieldDelegate>
{
    UITextField *cheatBox;
    CTGridManager *grid;
}
@property(assign)CTGridManager *grid;

-(void)show;
-(void)_didEnterCheat:(CTCheat)cheatType;

@end
