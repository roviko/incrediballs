//
//  DatabaseManager.h
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "User.h"
#import "Ball.h"

@interface DatabaseManager : NSObject {
	NSAutoreleasePool* pool; 
	FMDatabase* db;
	NSString* dbPath;
}

- (void) createEditableCopyOfDatabaseIfNeeded;
- (NSMutableDictionary *) getBallDatabase;
- (NSMutableDictionary *) getUserDatabase;
-(NSMutableDictionary *) getAllBalls;
-(NSMutableDictionary *) getAllUsers;
-(User *) getCurrentUser;
-(Ball *) getBallWithId:(NSNumber* )pBallID;
- (NSMutableDictionary *) getLevelDatabase;
-(NSMutableDictionary *) getUnlockedLevelsByLoggedInUser;
-(void)insertAnotherUser;
-(void)removeUserFromTable:(int) userId;
-(int)buyBall:(int) ballId price:(int)ballPrice userScore:(int)score;
-(void)setCurrentUser: (int)userId;
-(void) unlockNextLevel;
-(void) updateUserScore: (int)score;
-(int)getScoreFromDatabase;
- (NSMutableDictionary *) getAllHighScoreForLevel;
-(NSMutableDictionary *) getPlayedTutorials;
-(void) tutorialCleared:(int)tutorialId;
-(NSMutableDictionary *) getAllTutorialInformation;
-(int)getScoreForUserForParticularLevel:(int)stageId levelNumber:(int)levelId;



@end
