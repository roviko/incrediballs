//
//  ChipmuckTutorialAppDelegate.h
//  ChipmuckTutorial
//
//  Created by Alexandre on 27/04/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChipmuckTutorialViewController;

@interface ChipmuckTutorialAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ChipmuckTutorialViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ChipmuckTutorialViewController *viewController;

@end

