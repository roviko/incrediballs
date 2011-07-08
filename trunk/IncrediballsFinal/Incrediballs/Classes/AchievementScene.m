//
//  AchievementScene.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/30/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "AchievementScene.h"
#import "Globals.h"
#import "DatabaseManager.h"
#import "World.h"
#import "game_map.h"
#import "BallInventoryScene.h"
#import "MenuLevelSelector.h"
#import "User.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"


@implementation AchievementScene

CCSprite *levelSprite[4];
CCSprite *medal;
CCLabelTTF *header;
CCLabelTTF *message;
CCSprite *messageBG;

int iPrevScore;
int curLevelMinScore;
int curLevelAvgScore;
int curLevelMaxScore;
BOOL levelCleared;
BOOL scoreImproved;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AchievementScene *layer = [AchievementScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		[self addBackgroundLayer];
		[self getDetailsFromDatabase];
		[self insertInDatabase];
		[self animateProgress];
		[self addMenuItem];
		
	}
	
	return self;
}

-(void) getDetailsFromDatabase
{
	levelCleared = TRUE;
	
	DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
	NSMutableDictionary *userStatistics = [dbInstance getUnlockedLevelsByLoggedInUser];

	for (id key in userStatistics) {
		World* forLoopWorld = [userStatistics objectForKey:key];
		
		if (forLoopWorld.stageId == giMapType) {
		
			if (forLoopWorld.isUnlocked == 1) {
				
				int score = [dbInstance getScoreForUserForParticularLevel:forLoopWorld.stageId levelNumber:forLoopWorld.levelId];
			
				if(score >= forLoopWorld.maxScore){
					[levelSprite[forLoopWorld.levelId - 1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"gold.png"]]];
				}
				else if (score >= forLoopWorld.avgScore) {
					[levelSprite[forLoopWorld.levelId - 1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"silver.png"]]];
				}
				else if (score >= forLoopWorld.minScore) {
					[levelSprite[forLoopWorld.levelId - 1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"bronze.png"]]];
				}
				
				if (forLoopWorld.levelId == giLevelNumber) {
					
					iPrevScore = score;
					curLevelMinScore = forLoopWorld.minScore;
					curLevelMaxScore = forLoopWorld.maxScore;
					curLevelAvgScore = forLoopWorld.avgScore;
					
				}
				
			}
			else {
				if (forLoopWorld.levelId == giLevelNumber) {
	
					iPrevScore = 0;
					curLevelMinScore = forLoopWorld.minScore;
					curLevelMaxScore = forLoopWorld.maxScore;
					curLevelAvgScore = forLoopWorld.avgScore;
					
				}
				
				[levelSprite[forLoopWorld.levelId - 1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"base.png"]]];
			}

				
		}
	}
}

-(void) insertInDatabase
{
	if (giItemCollected >= gMinItemsToCollect) {
		
		DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
		// update user's score and store in data
		[dbInstance updateUserScore:giScoreRecieved];
		
		// store newly opened level in database
		[dbInstance unlockNextLevel];
		// level was successfully cleared.
		
		User* userInstance = [dbInstance getCurrentUser];
		
		gUserHighScore = userInstance.userScore;
	}
}
	
-(void) addBackgroundLayer
{
	CCSprite *bgLayer = [CCSprite spriteWithFile:@"levelSelector.png"];
	
	switch (giMapType) {
		case 1:
			bgLayer.position = ccp(480,0);
			break;
		case 2:
			bgLayer.position = ccp(0,0);
			break;
		case 3:
			bgLayer.position = ccp(480,320);
			break;
		case 4:
			bgLayer.position = ccp(0,320);
			break;
		default:
			break;
	}
	[self addChild:bgLayer];
	
	for (int i = 0; i < 4; i++) {
		levelSprite[i] = [CCSprite spriteWithFile:@"disabled.png"];
		levelSprite[i].scale = 0.7f;
	}
	
	levelSprite[0].position = ccp( 140, 220);
	levelSprite[1].position = ccp( 340, 220);
	levelSprite[2].position = ccp( 140, 100);
	levelSprite[3].position = ccp( 340, 100);
	
	for (int i = 0; i < 4; i++) {
		[self addChild:levelSprite[i]];
	}
	
	CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"showWholeWorld.png" selectedImage:@"showWholeWorld.png"
																target:self
															  selector:@selector(backButtonTouched)];
	
	if (giLevelNumber == 1 || giLevelNumber == 3) {
	
		backButton.position = ccp(-240 + 35,0);
		
	}
	else {
		backButton.position = ccp(240 - 35,0);
	}

	
	
	CCMenu *menu = [CCMenu menuWithItems:backButton,nil];
	

	CCSprite *headerBG = [CCSprite spriteWithFile:@"HUDTopBar.png"];
	headerBG.position = ccp(215,290);
	headerBG.scaleX = 1.19f;
	[self addChild:headerBG];
	
	[self addChild:menu];
	
	header = [CCLabelTTF labelWithString:@"LEVEL COMPLETE!" fontName:@"Marker Felt" fontSize:35];
	//header.color = ccc3(153, 0, 0);
	header.position = ccp(240,290);
	
	[self addChild:header];
	
	messageBG = [CCSprite spriteWithFile:@"HUDTopBar.png"];
	messageBG.position = ccp(215,30);
	messageBG.scaleX = 1.19f;
	[self addChild:messageBG];
	
	message = [CCLabelTTF labelWithString:@"You didn't beat your previous best" fontName:@"Marker Felt" fontSize:30];
	message.position = ccp(240,30);
	
	[self addChild:message];
}

-(void) backButtonTouched
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionRotoZoom transitionWithDuration:1 scene:[game_map node]]];
}

-(void) animateProgress
{
	
	if (giScoreRecieved < curLevelMinScore) {
		
		levelCleared = FALSE;
		
		[header setString:@"LEVEL FAILED!"];
		
		[message setString:[NSString stringWithFormat:@"You need to score %d to clear level",curLevelMinScore]];
		
	}
	
	
	
	if (levelCleared) {
		
		scoreImproved = TRUE;
		
		medal = [CCSprite spriteWithFile:@"bronzem_100px.png"];
		[self schedule:@selector(animateMedal) interval:1.0f];
		
		if (giScoreRecieved >= curLevelAvgScore && giScoreRecieved < curLevelMaxScore) {
			[medal setTexture:[[CCTextureCache sharedTextureCache] addImage:@"silverm_100px.png"]];
		}
		else if (giScoreRecieved >= curLevelMaxScore)
		{
			[medal setTexture:[[CCTextureCache sharedTextureCache] addImage:@"goldm_100px.png"]];
		}
		
		medal.position = ccp(240,160);
		
		[self addChild:medal];
		
		//play victory music
		[[SimpleAudioEngine sharedEngine] playEffect:@"victory.mp3"];
		
	
		if (iPrevScore == 0) {
			// do something for newly played level
			[header setString:@"Congratulations!"];
			[message setString:[NSString stringWithFormat:@"You set your new best (%d)",giScoreRecieved]];
			[self schedule:@selector(moveMedal) interval:4.0f];
		}
		else {
			// animation for already played level
			
			if (giScoreRecieved < iPrevScore) {
				[message setString:[NSString stringWithFormat:@"You didn't beat your best (%d)",iPrevScore]];
				[self schedule:@selector(moveMedal) interval:4.0f];
				scoreImproved = FALSE;
			}
			else {
				[header setString:@"Congratulations!"];
				[message setString:[NSString stringWithFormat:@"You improved your old best (%d)",giScoreRecieved]];
				[self schedule:@selector(moveMedal) interval:4.0f];
			}

		}
	}
	else {
		[self schedule:@selector(moveMessage) interval:4.0f];
		[self schedule:@selector(removeMessageBG) interval:4.0f];
	}

}

-(void) animateMedal
{
	[medal runAction:[CCSequence actions:[CCScaleTo  actionWithDuration:0.5f scale:1.3f],[CCScaleTo  actionWithDuration:0.5f scale:1.0f],nil]];
}

-(void) moveMedal
{
	[self unschedule:@selector(animateMedal)];
	[self unschedule:@selector(moveMedal)];
	
	CGPoint destPos = ccp(140 - 15, 220 - 10); // for first level
	
	switch (giLevelNumber) {
		case 2:
			destPos = ccp(340 - 15, 220 - 10);
			break;
		case 3:
			destPos = ccp(140 - 15, 100 - 10);
			break;
		case 4:
			destPos = ccp(340 - 15, 100 - 10);
			break;
		default:
			break;
	}
	if (scoreImproved == FALSE) {
		destPos = ccp(20,290);
	}
	
	id actMove = [CCMoveTo actionWithDuration:2.0f position:destPos];
	id actScale = [CCScaleTo actionWithDuration:2.0f scale:0.2f];
	
	[medal runAction:[CCSpawn actions:actMove,actScale,nil]];
	
	[self moveMessage];
	
	if (scoreImproved == FALSE) {
		[self removeMessageBG];
	}
	else {
		if (iPrevScore == 0) {
			// animation for newly opened level
		
			[self schedule:@selector(unlockAnimation) interval:2.0f];
		}
		else {
			[self removeMessageBG];
		}

	}

}

-(void) moveMessage
{
	[self unschedule:@selector(moveMessage)];
	[message runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(messageBG.position.x + 480,message.position.y)]];
}

-(void) removeMessageBG
{
	[self unschedule:@selector(removeMessageBG)];
	[messageBG runAction:[CCFadeOut actionWithDuration:2.0f]];
}

-(void) unlockAnimation
{
	[self unschedule:@selector(unlockAnimation)];
	
	message.position = ccp(-240,message.position.y);
	[message setString:@"You unlocked new level"];
	
	[message runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(240,message.position.y)]];

	[levelSprite[giLevelNumber] runAction:[CCScaleTo actionWithDuration:1.0f scale:0.0f]];
	
	[self schedule:@selector(changeLevelSprite) interval:1.0f];
}

-(void) changeLevelSprite
{
	[self unschedule:@selector(changeLevelSprite)];
	
	[levelSprite[giLevelNumber] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"base.png"]];
	
	[levelSprite[giLevelNumber] runAction:[CCScaleTo actionWithDuration:1.0f scale:0.7f]];
	
	[self schedule:@selector(moveMessage) interval:6.0f];
	[self schedule:@selector(removeMessageBG) interval:6.0f];
}

-(void) addMenuItem
{
	CCMenu *menu = [CCMenu menuWithItems:nil];
	
	DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
	NSMutableDictionary *userStatistics = [dbInstance getUnlockedLevelsByLoggedInUser];
	
	for (id key in userStatistics) {
		World* forLoopWorld = [userStatistics objectForKey:key];
		
		if (forLoopWorld.stageId == giMapType) {
		
			MenuLevelSelector *levelSelector = [MenuLevelSelector itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"
											target:self selector:@selector(startLevel:)];
			levelSelector.mapType = forLoopWorld.stageId;
			levelSelector.levelNumber = forLoopWorld.levelId;
			levelSelector.worldId = forLoopWorld.worldId;
			levelSelector.minItemsToCollect = forLoopWorld.minItemsToCollect;
			levelSelector.scale = 1.4f;
			
			switch (forLoopWorld.levelId) {
				case 1:
					levelSelector.position = ccp(-100,60);
					break;
				case 2:
					levelSelector.position = ccp(100,60);
					break;
				case 3:
					levelSelector.position = ccp(-100,-60);
					break;
				case 4:
					levelSelector.position = ccp(100,-60);
					break;
				default:
					break;
			}
			
			[menu addChild:levelSelector];
		}
	}
	
	[self addChild:menu];
}

-(void) startLevel: (MenuLevelSelector*) sender {
	// Setting the map info global variables
	giMapType = sender.mapType;
	giLevelNumber = sender.levelNumber;
	giWorldId = sender.worldId;
	gMinItemsToCollect = sender.minItemsToCollect;
	
	NSLog(@"Before creating ball menu Scene");
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1 scene:[BallInventoryScene node]]];
}

@end