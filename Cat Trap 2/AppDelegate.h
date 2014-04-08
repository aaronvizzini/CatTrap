//
//  AppDelegate.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 4/9/11.
//  Copyright Home 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
