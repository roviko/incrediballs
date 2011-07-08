//
//  ChipmuckTutorialViewController.h
//  ChipmuckTutorial
//
//  Created by Alexandre on 27/04/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chipmunk.h"

@interface ChipmuckTutorialViewController : UIViewController {
	UIImageView *floor; // Holds our floor image
	UIImageView *ball; // Holds our ball image
	
	cpSpace *space; // Holds our Space object
}

- (void)setupChipmuck; // Bootstraps chipmuck and the timer
- (void)tick:(NSTimer *)timer; // Fires at each "frame"

void updateShape(void *ptr, void* unused); // Updates a shape's visual representation (i.e. sprite)
@end

