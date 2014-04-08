//
//  CTManager.m
//  Cat Trap
//
//  Created by Aaron Vizzini on 10/29/09.
//  Copyright 2009 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//

#import "CTManager.h"


static CTManager *sharedInstance = nil;

@implementation CTManager
@synthesize currentProfile;

#pragma mark -
#pragma mark Singleton methods

+ (CTManager*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[CTManager alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end

