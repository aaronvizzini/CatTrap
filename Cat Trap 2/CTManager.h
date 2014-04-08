//
//  CTManager.h
//  Cat Trap
//
//  Created by Aaron Vizzini on 10/29/09.
//  Copyright 2009 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//

@class CTProfile;

@interface CTManager : NSObject 
{
    CTProfile *currentProfile;
}
@property(nonatomic, retain)CTProfile *currentProfile;

//Creates the shared instance of this object
+ (CTManager*)sharedInstance;

@end
