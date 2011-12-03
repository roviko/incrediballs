//
//  DatabaseManager.m
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabaseManager.h"
#import "Ball.h"
#import "Power.h"
#import "User.h"
#import "Globals.h"
#import "World.h"
#import "HighScore.h"
#import "Tutorial.h"


@implementation DatabaseManager


#pragma mark - Initialization

- (id) init
{
	if((self = [super init]))
	{
		pool = [[NSAutoreleasePool alloc] init];
		
		//TODO copy the database into writeable area
		//REF http://icodeblog.com/2008/08/19/iphone-programming-tutorial-creating-a-todo-list-using-sqlite-part-1/
		dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IncrediballsDB.sqlite"];
		[self createEditableCopyOfDatabaseIfNeeded];
		
		
		//NSLog(@"DB Path :: %@", dbPath);
		
		db = [FMDatabase databaseWithPath:dbPath];
		[db setLogsErrors:YES];
		
		//NSLog(@"Inside database Manager init");
		
		if(![db open])
		{
			NSLog(@"Error: Could not open db");
			[pool release];
			return 0;
		}
		else
		{
			//[self getUserDatabase];
			NSLog(@"Database instance opened successfully.");
		}
	}
	
	return self;
}



- (void) createEditableCopyOfDatabaseIfNeeded
{
	bool success;
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error;
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	NSString* writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"IncrediballsDB.sqlite"];
	
	//Search for db in user document
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) {
		//Found db
		dbPath = writableDBPath;
		return;
	}
	
	//Copy the db over
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IncrediballsDB.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	dbPath = writableDBPath;
}

#pragma mark - Ball methods

// Get the ball info
- (NSMutableDictionary *) getBallDatabase
{
	NSMutableDictionary* balls = [[[NSMutableDictionary alloc] init] autorelease];
	
	FMResultSet* rs = [db executeQuery:@"SELECT * FROM BALL ORDER BY UPDATED_DATE"];
	while ([rs next]) {
		Ball* b = [[Ball alloc] init];
		b.ballId = [rs intForColumn:@"BALL_ID"];
		b.ballName = [rs stringForColumn:@"NAME"];
		b.ballDescription = [rs stringForColumn:@"DESCRIPTION"];
		b.radius = [rs intForColumn:@"RADIUS"];
		b.mass = [rs intForColumn:@"MASS"];
		b.elasticity = [rs intForColumn:@"ELASTICITY"]/100.0f;
		b.friction = [rs intForColumn:@"FRICTION"]/100.0f;
		b.ballPrice = [rs longForColumn:@"PRICE"];
		
		[balls setObject:b forKey:[NSNumber numberWithInt:b.ballId]];
		
		// Release the ball object
		[b release];
	}
	[rs close];
	
	//Get powers of every ball
	for (id key in balls) {
		Ball* ball = [balls objectForKey:key];
		//Get priceList
		NSMutableArray* powerList = [[NSMutableArray alloc] init];
		rs = [db executeQuery:@"SELECT P.POWER_ID AS PID, P.NAME AS PNAME, P.DESCRIPTION AS PDESC,BPM.POWER_INTENSITY AS INTENSITY from POWER P INNER JOIN BALL_POWER_MAP BPM ON P.POWER_ID = BPM.POWER_ID where BPM.BALL_ID = ?" withArgumentsInArray:[NSArray arrayWithObject:key]];
		while ([rs next]) {
			Power* p = [[Power alloc] init];
			p.powerId = [rs intForColumn:@"PID"];
			p.powerName = [rs stringForColumn:@"PNAME"];
			p.powerDescription = [rs stringForColumn:@"PDESC"];
			p.powerIntensity = [rs longForColumn:@"INTENSITY"];
			[powerList addObject:p];
			
			[p release];
		}
		ball.powers = powerList;
		[rs close];
	}
	
	// Get which ball is unlocked
	rs = [db executeQuery:@"SELECT BALL_ID FROM USER_BALL_MAP WHERE USER_ID = ?", [NSString stringWithFormat:@"%d",gUserId]];
	while ([rs next]) {
		int userBallId = [rs intForColumn:@"BALL_ID"];
		Ball* ball = [balls objectForKey:[NSNumber numberWithInt:userBallId]];
		ball.isBallUnlocked = TRUE;
	}
	[rs close];
	
	return balls;
}

// Get all balls
-(NSMutableDictionary *) getAllBalls
{
	return [self getBallDatabase];
}

// Get a particular ball
-(Ball *) getBallWithId:(NSNumber* )pBallID
{
	
	NSMutableDictionary* balls = [self getAllBalls];
	
	return (Ball *)[balls objectForKey:pBallID];
}

// Returns the current value of the highscore or money availabel by the user
-(int)buyBall:(int) ballId price:(int)ballPrice userScore:(int)score
{
	// Local variables
	int newUserScore = score - ballPrice;
	
	// Start transaction
	[db beginTransaction];
    
	NSLog(@"ball iD = %d",ballId);
	[self createEditableCopyOfDatabaseIfNeeded];
	// Insert into the buy table
	NSString *insertBall = [NSString stringWithFormat: @"INSERT INTO USER_BALL_MAP (USER_ID, BALL_ID) VALUES (%d, %d) ",gUserId, ballId ];
	
	[db executeUpdate: insertBall];
	[self createEditableCopyOfDatabaseIfNeeded];
	NSString *updateUserScore = [NSString stringWithFormat:@"UPDATE USER SET SCORE = %d, UPDATED_DATE = CURRENT_TIMESTAMP WHERE USER_ID = %d",newUserScore, gUserId];
	
	// Update the user score/money
	[db executeUpdate: updateUserScore];
	
	NSLog(@"new score = %d",newUserScore);
	
	// Commit the chages
	[db commit];
	
	// Get the current user again
	User *userNow = [self getCurrentUser];
	
	NSLog(@"Inside database map Highscore : %d", userNow.userScore);
	
	// Return the current score/money
	return userNow.userScore;
	
}


#pragma mark - User methods

// Get the user details
- (NSMutableDictionary *) getUserDatabase
{
	NSMutableDictionary* user = [[[NSMutableDictionary alloc] init] autorelease];
	
	int counter = 0;
	//Get all the Balls
	FMResultSet* rs = [db executeQuery:@"SELECT * FROM USER ORDER BY UPDATED_DATE DESC"];
	
	while ([rs next]) {
		User* u = [[User alloc] init];
		u.userId = [rs intForColumn:@"USER_ID"];
		u.userName = [rs stringForColumn:@"NAME"];
		u.userScore = [rs intForColumn:@"SCORE"];
		if(counter == 0)
		{
			u.isCurrentUser = TRUE;
		}
		
		[user setObject:u forKey:[NSNumber numberWithInt:counter]];
		counter++;
		// Release the ball object
		[u release];
	}
	[rs close];
	
	return user;
}


// Get all the users
-(NSMutableDictionary *) getAllUsers
{
	return [self getUserDatabase];
}


-(User *) getCurrentUser
{
	NSMutableDictionary* users = [self getAllUsers];
	User* user;
	//Get products for every city
	for (id key in users) {
		User* forLoopUser = [users objectForKey:key];
		if (forLoopUser.isCurrentUser) {
			user = forLoopUser;
			break;
		}
	}
	return user;
}



-(void)setCurrentUser: (int)userId
{
	[db beginTransaction];
	[self createEditableCopyOfDatabaseIfNeeded];
	NSString *updateUserQuery = [NSString stringWithFormat:@"UPDATE USER SET UPDATED_DATE = CURRENT_TIMESTAMP WHERE USER_ID = %d", userId];
	[db executeUpdate: updateUserQuery];
	[db commit];
}


-(void)removeUserFromTable:(int) userId
{
	[db beginTransaction];
	[db executeUpdate:@"DELETE FROM USER WHERE USER_ID = ?",userId];
	[db commit];
}


// Add a user
-(void)insertAnotherUser
{
	[db beginTransaction];
	[self createEditableCopyOfDatabaseIfNeeded];
	NSString *insertUser = [NSString stringWithFormat:@"INSERT INTO USER (NAME, UPDATED_DATE) VALUES ( '%@' ,CURRENT_TIMESTAMP)", gUserName];
	[db executeUpdate: insertUser];
	[db commit];
}


#pragma mark - Level methods

// Get the level unlocked by user
- (NSMutableDictionary *) getLevelDatabase
{
	NSMutableDictionary* levels = [[[NSMutableDictionary alloc] init] autorelease];
	
	//Get all the levels unlocked by user
	FMResultSet* rs = [db executeQuery:@"select W.WORLD_ID, W.STAGE_ID, W.LEVEL_ID,W.MIN_SCORE, W.MAX_SCORE, W.AVG_SCORE, W.DESCRIPTION, W.DAMPING, W.GRAVITY, W.WIND, W.ITERATION, W.MIN_ITEM from USER_LEVEL_MAP ULM INNER JOIN WORLD W ON W.WORLD_ID = ULM.WORLD_ID WHERE ULM.USER_ID = ?",  [NSString stringWithFormat:@"%d",gUserId]];
	while ([rs next]) {
		World *w = [[World alloc] init];
		w.worldId = [rs intForColumn:@"WORLD_ID"];
		w.stageId = [rs intForColumn:@"STAGE_ID"];
		w.levelId = [rs intForColumn:@"LEVEL_ID"];
		w.minScore = [rs longForColumn:@"MIN_SCORE"];
		w.maxScore = [rs longForColumn:@"MAX_SCORE"];
		w.avgScore = [rs longForColumn:@"AVG_SCORE"];
		w.description = [rs stringForColumn:@"DESCRIPTION"];
		w.gravity = [rs doubleForColumn:@"GRAVITY"];
		w.damping = [rs doubleForColumn:@"DAMPING"];
		w.wind = [rs doubleForColumn:@"WIND"];
		w.iteration = [rs doubleForColumn:@"ITERATION"];
		w.minItemsToCollect = [rs intForColumn:@"MIN_ITEM"];
		
		NSLog(@"Min score : %f", w.minScore);
		
		[levels setObject:w forKey:[NSNumber numberWithInt:w.worldId]];
		
		// Release the ball object
		[w release];
	}
	[rs close];
	
	//Get powers of every ball
	for (id key in levels) {
		World* worldObj = [levels objectForKey:key];
		
		//Get user name and total score/money
		NSString *highScoreQuery = [NSString stringWithFormat:@"SELECT * FROM HIGHSCORE WHERE WORLD_ID = %d AND USER_ID = %d LIMIT 1 ", worldObj.worldId, gUserId];
		
		rs = [db executeQuery:highScoreQuery];
		while ([rs next]) {
			worldObj.isUnlocked = 1;
		}
		[rs close];
	}
	
	return levels;
}

// Get level unlocked by a user
-(NSMutableDictionary *) getUnlockedLevelsByLoggedInUser
{
	[self createEditableCopyOfDatabaseIfNeeded];
	NSMutableDictionary* levels = [self getLevelDatabase];
	
	//Get products for every city
	for (id key in levels) {
		World* forLoopWorld = [levels objectForKey:key];
		if (forLoopWorld.stageId == 1) {
			forLoopWorld.stageName = @"City";
			forLoopWorld.cityLevelCount++;
		}
		else if(forLoopWorld.stageId == 2)
		{
			forLoopWorld.stageName = @"Jungle";
			forLoopWorld.jungleLevelCount++;
		}
		else if(forLoopWorld.stageId == 3)
		{
			forLoopWorld.stageName = @"Ice";
			forLoopWorld.iceLevelCount++;
		}
		else {
			forLoopWorld.stageName = @"Desert";
			forLoopWorld.iceLevelCount++;
		}
	}
	return levels;
}


// Get a particular level info
-(World *) getLevelWithId:(NSNumber* )pWorldId
{
	
	NSMutableDictionary* levels = [self getLevelDatabase];
	
	return (World *)[levels objectForKey:pWorldId];
}


// Unlock the next level
-(void) unlockNextLevel
{
	[db beginTransaction];
	[self createEditableCopyOfDatabaseIfNeeded];
	NSString *unlockNewLevel = [NSString stringWithFormat:@"INSERT INTO USER_LEVEL_MAP (USER_ID, WORLD_ID) VALUES ( %d ,%d)", gUserId, giWorldId + 4];
	[db executeUpdate: unlockNewLevel];
	[db commit];
}

#pragma mark - Score metohds

-(void) updateUserScore: (int)score
{
	[db beginTransaction];
	int latestHighscoreFromDatabase = 0;
	int previousHighScore = 0;
	int totalScore = gUserHighScore;
	
	previousHighScore = [self getScoreFromDatabase];
	[self createEditableCopyOfDatabaseIfNeeded];
	NSString *insertNewHighScore = [NSString stringWithFormat:@"INSERT INTO HIGHSCORE (USER_ID, WORLD_ID, SCORE) VALUES (%d,%d,%d)", gUserId, giWorldId, score];
	[db executeUpdate: insertNewHighScore];
	
	// Get the highest score from the database
	latestHighscoreFromDatabase = [self getScoreFromDatabase];
	
	if(latestHighscoreFromDatabase > previousHighScore)
	{
		totalScore = totalScore + latestHighscoreFromDatabase - previousHighScore;
		[self createEditableCopyOfDatabaseIfNeeded];
		NSString *updateScore = [NSString stringWithFormat:@"UPDATE USER SET SCORE = %d WHERE USER_ID = %d", totalScore, gUserId];
		[db executeUpdate: updateScore];
	}
	
	[db commit];
}

-(int)getScoreFromDatabase
{
	int scoreFromDatabase = 0;
	
	NSString *highscoreQuery = [NSString stringWithFormat:@"SELECT SCORE FROM HIGHSCORE WHERE USER_ID = %d AND WORLD_ID = %d ORDER BY SCORE DESC LIMIT 1", gUserId, giWorldId];
	
	//Get all the levels unlocked by user
	FMResultSet* rs = [db executeQuery: highscoreQuery];
	while ([rs next]) {
		scoreFromDatabase = [rs intForColumn:@"SCORE"];
	}
	[rs close];
	
	return scoreFromDatabase;
}

-(int)getScoreForUserForParticularLevel:(int)stageId levelNumber:(int)levelId
{
	int score = 0;
	
	NSString *getScoreQuery = [NSString stringWithFormat:@"SELECT SCORE FROM HIGHSCORE WHERE USER_ID = %d AND WORLD_ID = (SELECT WORLD_ID FROM WORLD WHERE STAGE_ID = %d AND LEVEL_ID = %d ) ORDER BY SCORE DESC LIMIT 1", gUserId, stageId, levelId];

	FMResultSet* rs = [db executeQuery: getScoreQuery];
	while ([rs next]) {
		score = [rs intForColumn:@"SCORE"];
	}
	[rs close];
	return score;
}


// Get the level unlocked by user
- (NSMutableDictionary *) getAllHighScoreForLevel
{
	NSMutableDictionary* highScores = [[[NSMutableDictionary alloc] init] autorelease];
	int counter = 0;
	NSString *queryToExecute;
	if(giLevelNumber == 5)
	{
		queryToExecute = [NSString stringWithFormat:@"SELECT NAME, SCORE FROM USER ORDER BY SCORE DESC LIMIT 5"];
	}
	else {
		queryToExecute = [NSString stringWithFormat:@"SELECT U.NAME, H.SCORE FROM HIGHSCORE H INNER JOIN USER U ON U.USER_ID = H.USER_ID WHERE H.WORLD_ID = (SELECT WORLD_ID FROM WORLD WHERE LEVEL_ID = %d AND STAGE_ID = %d) ORDER BY H.SCORE DESC LIMIT 5", giLevelNumber, giMapType];
	}

	FMResultSet* rs = [db executeQuery:queryToExecute];
	while ([rs next]) {
		
		HighScore *highScore = [[HighScore alloc] init];
		highScore.userName = [rs stringForColumn:@"NAME"];
		highScore.levelScore = [rs intForColumn:@"SCORE"];
		
		[highScores setObject:highScore forKey:[NSNumber numberWithInt:counter]];
		
		counter++;
		// Release the ball object
		[highScore release];
	}
	[rs close];
	
	return highScores;
}

#pragma mark - Tutorial methods

-(NSMutableDictionary *) getAllTutorialInformation
{
	NSMutableDictionary* tutorials = [[[NSMutableDictionary alloc] init] autorelease];
	
	//Get all the levels unlocked by user
	FMResultSet* rs = [db executeQuery:@"SELECT TUTORIAL_ID, TITLE, DESC FROM TUTORIAL"];
	while ([rs next]) {
		Tutorial *t = [[Tutorial alloc] init];
		
		t.tutorialId = [rs intForColumn:@"TUTORIAL_ID"];
		t.title = [rs stringForColumn:@"TITLE"];
		t.description = [rs stringForColumn:@"DESC"];
		[tutorials setObject:t forKey:[NSNumber numberWithInt:t.tutorialId]];
		
		// Release the ball object
		[t release];
	}
	[rs close];
	
	return tutorials;
}



-(void) tutorialCleared:(int)tutorialId
{
	[db beginTransaction];
	BOOL isAlreadyCleared = FALSE;
	
	NSString *isTutorialCleared = [NSString stringWithFormat:@"SELECT TUTORIAL_ID FROM USER_TUTORIAL_MAP WHERE USER_ID = %d AND TUTORIAL_ID = %d", gUserId, tutorialId];
	FMResultSet* rs = [db executeQuery:isTutorialCleared];
	while ([rs next]) {
		isAlreadyCleared = TRUE;
	}
	[rs close];
	if (!isAlreadyCleared) {
		[self createEditableCopyOfDatabaseIfNeeded];
		
		NSString *tutorialCleared = [NSString stringWithFormat:@"INSERT INTO USER_TUTORIAL_MAP (USER_ID, TUTORIAL_ID) VALUES ( %d ,%d)", gUserId, tutorialId];
		[db executeUpdate: tutorialCleared];
		
	}
	[db commit];
}

-(NSMutableDictionary *) getPlayedTutorials
{
	NSMutableDictionary* tutorials = [[[NSMutableDictionary alloc] init] autorelease];
	
	//Get all the levels unlocked by user
	FMResultSet* rs = [db executeQuery:@"SELECT TUTORIAL_ID, TITLE, DESC FROM USER_TUTORIAL_MAP WHERE USER_ID = ?",  [NSString stringWithFormat:@"%d",gUserId]];
	while ([rs next]) {
		Tutorial *t = [[Tutorial alloc] init];
		
		t.tutorialId = [rs intForColumn:@"TUTORIAL_ID"];
		[tutorials setObject:t forKey:[NSNumber numberWithInt:t.tutorialId]];
		
		// Release the ball object
		[t release];
	}
	[rs close];
	
	return tutorials;
}


#pragma mark - Deallocation

-(void) dealloc
{
	NSLog(@"Inside dealloc of database manager");
	[pool release];
	[super dealloc];
}



@end
