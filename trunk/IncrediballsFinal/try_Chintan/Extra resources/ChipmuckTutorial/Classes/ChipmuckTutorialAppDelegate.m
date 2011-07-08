//
//  ChipmuckTutorialAppDelegate.m
//  ChipmuckTutorial
//
//  Created by Alexandre on 27/04/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ChipmuckTutorialAppDelegate.h"
#import "ChipmuckTutorialViewController.h"

@implementation ChipmuckTutorialAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
