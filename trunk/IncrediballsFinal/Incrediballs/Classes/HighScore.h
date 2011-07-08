//
//  HighScore.h
//  Incrediballs
//
//  Created by student on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HighScore : CCLayer {
	int highScoreId;
	int worldId;
	int stageId;
	int levelId;
	int levelScore;
	int userId;
	int minScore;
	int avgScore;
	int maxScore;
	int totalScore;
	NSString *userName;
}

@property (nonatomic) int highScoreId;
@property (nonatomic) int worldId;
@property (nonatomic) int stageId;
@property (nonatomic) int levelId;
@property (nonatomic) int userId;
@property (nonatomic) int minScore;
@property (nonatomic) int avgScore;
@property (nonatomic) int maxScore;
@property (nonatomic) int totalScore;
@property (nonatomic) int levelScore;
@property (copy) NSString* userName;


@end
