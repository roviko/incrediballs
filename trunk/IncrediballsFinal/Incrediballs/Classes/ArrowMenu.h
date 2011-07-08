//
//  ArrowMenu.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/14/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ArrowMenu : CCMenuItemImage {
	int centerX;
	int centerY;
	int durationOfAnimation;
	int goingToStageId;
	int fromStageId;
	int scalingFactor;
}


@property (readwrite) int centerX;
@property (readwrite) int centerY;
@property (readwrite) int durationOfAnimation;
@property (readwrite) int goingToStageId;
@property (readwrite) int scalingFactor;
@property (readwrite) int fromStageId;


@end
