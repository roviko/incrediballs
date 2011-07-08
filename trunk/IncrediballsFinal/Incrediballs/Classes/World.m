//
//  World.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/5/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "World.h"


@implementation World

@synthesize worldId, stageId, levelId, description, minScore, avgScore, maxScore, stageName;
@synthesize gravity, wind, iteration, damping;
@synthesize cityLevelCount, jungleLevelCount,iceLevelCount, desertLevelCount, minItemsToCollect, isUnlocked;


//TODO remove this test class, make a constructor with proper city info
-(id) init
{
	if ((self = [super init])) {
		
	}
	return self;
}

@end
