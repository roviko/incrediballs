//
//  Ball.m
//  Shooter
//
//  Created by CHINTANKUMAR PATEL on 2/24/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "Ball.h"


@implementation Ball

@synthesize iColorIndex;
@synthesize iQuadrant;
@synthesize iPositionIndex;
@synthesize isChecked;
@synthesize toBeRemoved;

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
	// moving of the ball goes here if some other ball has made place because of its busting
}

@end
