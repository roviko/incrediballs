//
//  ShooterAppDelegate.h
//  Shooter
//
//  Created by CHINTANKUMAR PATEL on 2/24/11.
//  Copyright USC 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ShooterAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
