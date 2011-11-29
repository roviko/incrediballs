//
//  BackgroundMap.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/5/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "BackgroundMap.h"


@implementation BackgroundMap

@synthesize iBackgroundIndex;

- (id)initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	// Call the init method of the parent class (CCSprite)
	if ((self = [super initWithTexture:texture rect:rect]))
	{
		// The only custom stuff here is scheduling an update method
		[self scheduleUpdate];
	}
	
	return self;
}

- (void)update:(ccTime)dt
{
	// moving of the background goes here
}

@end
