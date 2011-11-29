//
//  World.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/5/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface World : CCLayer {
	int worldId;
	int stageId;
	int levelId;
	NSString* description;
	float minScore;
	float avgScore;
	float maxScore;
	NSString* stageName;
	float gravity;
	float wind;
	float damping;
	float iteration;
	int minItemsToCollect;
	int isUnlocked;
	
	// To hold the count of the levels
	int cityLevelCount;
	int jungleLevelCount;
	int iceLevelCount;
	int desertLevelCount;
}

@property (nonatomic) int worldId;
@property (copy) NSString* description;
@property (copy) NSString* stageName;
@property (nonatomic) int stageId;
@property (nonatomic) int levelId;
@property (nonatomic) float minScore;
@property (nonatomic) float avgScore;
@property (nonatomic) float maxScore;
@property (nonatomic) float gravity;
@property (nonatomic) float wind;
@property (nonatomic) float damping;
@property (nonatomic) float iteration;
@property (nonatomic) int cityLevelCount;
@property (nonatomic) int jungleLevelCount;
@property (nonatomic) int iceLevelCount;
@property (nonatomic) int desertLevelCount;
@property (nonatomic) int minItemsToCollect;
@property (nonatomic) int isUnlocked;


@end
