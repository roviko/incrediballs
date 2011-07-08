//
//  Ball.h
//  Shooter
//
//  Created by CHINTANKUMAR PATEL on 2/24/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Ball : CCSprite {

	int iColorIndex;		// which color it has
	int iQuadrant;			// Which quadrant its in (1 = right top, 2 = left top, 3 = left bottom, 4 = right bottom)
	CGPoint	iPositionIndex;	// position of the ball in array
	BOOL isChecked;			// flag to keep track whether given ball has been checked for match or not
	BOOL toBeRemoved;		// flag to keep track whether given ball has  to be removed after current algorithm
}

@property int iColorIndex;
@property int iQuadrant;
@property CGPoint iPositionIndex;
@property BOOL isChecked;
@property BOOL toBeRemoved;

- (id)initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect;

- (void)update:(ccTime)dt;

@end