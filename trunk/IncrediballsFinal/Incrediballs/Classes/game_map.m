//
//  game_map.m
//  Incrediballs
//
//  Created by student on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "game_map.h"
#import "CCTouchDispatcher.h"
#import "HelloWorldScene.h"
#import "BallInventoryScene.h"
#import "LevelBuilder.h"
#import "MultipleLayer.h"
#import "Globals.h"
#import "MenuLevelSelector.h"
#import "User.h"
#import "World.h"
#import "ArrowMenu.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"

const int animationDuration = 1;
const float arrowAnimationDuration = 0.1f;
const int levelSelectorOffsetX = 100;
const int levelSelectorOffsetY = 60;
const float arrowScalingFactor = 0.5f;
const int cornorArrowOffsetValue = 0;
const int lookAtWholeWorld = 0;
const int lookAtCity = 1;
const int lookAtJungle = 2;
const int lookAtIce = 3;
const int lookAtDesert = 4;

MenuLevelSelector *levelMenuSelector[4][4];
CCSprite *allLevelsInGame[4][4];
BOOL showWholeWorldIcon = TRUE;
CCMenuItemImage *arrowMenuItems[3];
CCSprite *worldMapImage;
CCMenuItemImage *showWholeMap;
int lookAtStageId;
// The labels to display the name
CCLabelTTF *lUserName;
NSMutableDictionary* unlockedLevels;
CCMenu *arrowMenu;


@implementation game_map

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	game_map *layer = [game_map node];
	
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
		
		if (playGeneralSound) {
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mainTheme.wav"];
		}
		
		// Initialize the static variables
		[self initializeTheStaticVariables];
		
		// Set the global variables with a database call
		[self setTheCurrentUserGlobally];
		
		// Set the background
		// Initail set up
		worldMapImage = [CCSprite spriteWithFile:@"levelSelector.png"];
		worldMapImage.position = ccp(240,160);
		worldMapImage.scale = 0.5f;
		[self addChild:worldMapImage];
		
		// Animate the level selector to show the city first
		[self animateTheWorldMap: 480 yPosition: 0 duration:0 arrowDuration:arrowAnimationDuration scale:1 selectLevelFor:lookAtCity animateWorld:FALSE animateArrows:FALSE];
		
		// Call to add all the level images on the world map
		[self addAllLevelImagesOnTheWorldImage];
		
		// Database call to get the unlcoked levels and show on the screen
		[self getUnlockedLevels];
		
		// To add all the information from the database to the scree
		[self setLevelMenuScreenDescription];
		
		[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
		
	}
	return self;
}

-(void)initializeTheStaticVariables
{
	showWholeWorldIcon = TRUE;
	lookAtStageId = 0;
}

-(void) goBack{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1  scene:[HelloWorld node]]];
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


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector]convertToGL:location];
	
	if(showWholeWorldIcon)
	{
		showWholeWorldIcon = FALSE;
		int zoomIntoLevel = 0;
		int fromCenterX = 0;
		int fromCenterY = 0;
		
		if(convertedLocation.x < 240 && convertedLocation.y > 160)// City
		{
			zoomIntoLevel = 1;
			fromCenterX = 480;
			fromCenterY = 0;
			NSLog(@"Go to city");
		}
		else if(convertedLocation.x > 240 && convertedLocation.y > 160)// Jungle
		{
			zoomIntoLevel = 2;
			fromCenterX = 0;
			fromCenterY = 0;
			NSLog(@"Go to Jungle");
		}
		else if(convertedLocation.x < 240 && convertedLocation.y < 160)// Ice
		{
			zoomIntoLevel = 3;
			fromCenterX = 480;
			fromCenterY = 320;
			NSLog(@"Go to Ice");
		}
		else {// Desert
			zoomIntoLevel = 4;
			fromCenterX = 0;
			fromCenterY = 320;
			NSLog(@"Go to Desert");
		}
		
		// Animate the level selector to show the city first
		[self animateTheWorldMap: fromCenterX yPosition:fromCenterY duration:1 arrowDuration:arrowAnimationDuration scale:2 selectLevelFor:zoomIntoLevel animateWorld:TRUE animateArrows:TRUE];
	}

}

-(void)setLevelMenuScreenDescription
{
	lUserName = [CCLabelTTF labelWithString:gUserName fontName:@"Marker Felt" fontSize:16];
	lUserName.position = ccp(240,300);
	//lUserName.color = ccc3(153.0f, 0.0f, 0.0f);
	
	[self addChild:lUserName];
}

-(void) getUnlockedLevels
{
	// Create a back button, always present
	CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"back_a.png" selectedImage:@"back_b.png"
																target:self
															  selector:@selector(goBack)];
	backButton.position = ccp(-200,-120);
	
	// Call to the database to get the unlocked levels by the user
	DatabaseManager* dbManagerInstance = [[DatabaseManager alloc] init];
	unlockedLevels = [dbManagerInstance getUnlockedLevelsByLoggedInUser];
	
	NSLog(@"Unlocked levels : %d",[unlockedLevels count]);
	
	// Menu to go into the level
	CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
	
	for(id key in unlockedLevels)
	{
		World* level = [unlockedLevels objectForKey:key];
		int centerOfTheMapX = 0;
		int centerOfTheMapY = 0;
		
		if (level.isUnlocked == 1) 
		{
			DatabaseManager* dbMgrInst = [[DatabaseManager alloc] init];
			
			int score = [dbMgrInst getScoreForUserForParticularLevel:level.stageId levelNumber:level.levelId];
			//NSLog(@"The score for this level is : %d => %d", score, level.minScore);
			
			if (score < level.avgScore) {
				levelMenuSelector[level.stageId - 1][level.levelId - 1] = [MenuLevelSelector itemFromNormalImage:@"bronze.png" selectedImage:@"bronze.png"
																										  target:self selector:@selector(startLevel:)];
			}
			else if (score < level.maxScore) {
				levelMenuSelector[level.stageId - 1][level.levelId - 1] = [MenuLevelSelector itemFromNormalImage:@"silver.png" selectedImage:@"silver.png"
																										target:self selector:@selector(startLevel:)];
			}
			else if(score >= level.maxScore){
				levelMenuSelector[level.stageId - 1][level.levelId - 1] = [MenuLevelSelector itemFromNormalImage:@"gold.png" selectedImage:@"gold.png"
																										target:self selector:@selector(startLevel:)];
			}
			
		}
		else
		{
			levelMenuSelector[level.stageId - 1][level.levelId - 1] = [MenuLevelSelector itemFromNormalImage:@"base.png" selectedImage:@"base.png"
																								  target:self selector:@selector(startLevel:)];
		}
		//levelMenuSelector[level.stageId - 1][level.levelId - 1].select
		levelMenuSelector[level.stageId - 1][level.levelId - 1].mapType = level.stageId;
		levelMenuSelector[level.stageId - 1][level.levelId - 1].levelNumber = level.levelId;
		levelMenuSelector[level.stageId - 1][level.levelId - 1].worldId = level.worldId;
		levelMenuSelector[level.stageId - 1][level.levelId - 1].minItemsToCollect = level.minItemsToCollect;
		levelMenuSelector[level.stageId - 1][level.levelId - 1].scale = 0.7f;
		
		//[self unschedule:@selector(animatePlayableLevel)];	
		
		
		//Position the items
		if (level.stageId == lookAtCity) {
			centerOfTheMapX = 0;
			centerOfTheMapY = 320;
		}
		else if(level.stageId == lookAtJungle)
		{
			centerOfTheMapX = 480;
			centerOfTheMapY = 320;
		}
		else if(level.stageId == lookAtIce)
		{
			centerOfTheMapX = 0;
			centerOfTheMapY = 0;
		}
		else if(level.stageId == lookAtDesert){
			centerOfTheMapX = 480;
			centerOfTheMapY = 0;
		}
		
		if(level.levelId == lookAtCity)
		{
			levelMenuSelector[level.stageId - 1][level.levelId - 1].position = ccp(centerOfTheMapX - levelSelectorOffsetX, centerOfTheMapY + levelSelectorOffsetY);
		}
		else if(level.levelId == lookAtJungle)
		{
			levelMenuSelector[level.stageId - 1][level.levelId - 1].position = ccp(centerOfTheMapX + levelSelectorOffsetX, centerOfTheMapY + levelSelectorOffsetY);
		}
		else if(level.levelId == lookAtIce)
		{
			levelMenuSelector[level.stageId - 1][level.levelId - 1].position = ccp(centerOfTheMapX - levelSelectorOffsetX, centerOfTheMapY - levelSelectorOffsetY);
		}
		else if(level.levelId == lookAtDesert)
		{
			levelMenuSelector[level.stageId - 1][level.levelId - 1].position = ccp(centerOfTheMapX + levelSelectorOffsetX, centerOfTheMapY - levelSelectorOffsetY);
		}
		
		// Add the menu
		[menu addChild:levelMenuSelector[level.stageId - 1][level.levelId - 1]];
	}
	
	//[self schedule:@selector(animatePlayableLevel) interval:2];
	
	//[self addChild:menu];
	[worldMapImage addChild:menu];
}


-(void)animatePlayableLevel
{
	
	if (unlockedLevels) {
		NSLog(@"Unlocked levels : %d",[unlockedLevels count]);
		for(id key in unlockedLevels)
		{
			NSLog(@"Inside animate playable levels");
			World* level = [unlockedLevels objectForKey:key];
			if(level.isUnlocked != 1)
			{
				[levelMenuSelector[level.stageId - 1][level.levelId - 1] runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1],[CCFadeIn actionWithDuration:1],nil] ];
			}
		}
	}
	
}

-(void)setTheCurrentUserGlobally
{
	// Setting user id and name
	DatabaseManager* dbManagerInstance = [[DatabaseManager alloc] init];
	User* userInstance = [dbManagerInstance getCurrentUser];
	
	gUserId = userInstance.userId;
	gUserName = userInstance.userName;
	gUserHighScore = userInstance.userScore;
}

-(void)animateTheWorldMap:(float) posX yPosition:(float)posY duration:(float)dt arrowDuration:(float)arrowAnimation scale:(float)scalingFactor selectLevelFor:(int)inputStageId animateWorld:(BOOL)isAnimateWorld animateArrows:(BOOL)isAnimateArrow
{
	// Actions for arrow menu
	id doNothingAction = [CCMoveBy actionWithDuration:dt position:ccp(0,0)];
	
	// Right arrow
	id moveRightArrow = [CCMoveTo actionWithDuration:arrowAnimation position:ccp(240 - (64 * arrowScalingFactor) ,0)];
	id totalRightArrowAnimation = [CCSequence actions:doNothingAction, moveRightArrow ,nil];
	
	// Down arrow
	id moveDownArrow= [CCMoveTo actionWithDuration:arrowAnimation position:ccp(0, -(160 - (64 * arrowScalingFactor)))];
	id totalDownArrowAnimation = [CCSequence actions:doNothingAction, moveDownArrow, nil];
	
	// Down Right arrow
	id moveDownRightArrow = [CCMoveTo actionWithDuration:arrowAnimation position:ccp(240 - (64 * arrowScalingFactor) - cornorArrowOffsetValue, -(160 - (64 * arrowScalingFactor)) + cornorArrowOffsetValue)];
	id totalDownRightArrowAnimation = [CCSequence actions:doNothingAction, moveDownRightArrow, nil];
	
	// Left arrow
	id moveLeftArrow = [CCMoveTo actionWithDuration:arrowAnimation position:ccp(-240 + (64 * arrowScalingFactor) ,0)];
	id totalLeftArrowAnimation = [CCSequence actions:doNothingAction, moveLeftArrow ,nil];
	
	// Down left arrow
	id moveDownLeftArrow = [CCMoveTo actionWithDuration:arrowAnimation position:ccp(-240 + (64 * arrowScalingFactor) + cornorArrowOffsetValue,-(160 - (64 * arrowScalingFactor)) - cornorArrowOffsetValue)];
	id totalDownLeftArrowAnimation = [CCSequence actions:doNothingAction, moveDownLeftArrow ,nil];
	
	// Up arrow
	id moveUpArrow = [CCMoveTo actionWithDuration:arrowAnimation position:ccp(0, (160 - (64 * arrowScalingFactor)))];
	id totalUpArrowAnimation = [CCSequence actions:doNothingAction, moveUpArrow, nil];
	
	// Up Right arrow
	id moveUpRightArrow = [CCMoveTo actionWithDuration:arrowAnimation position:ccp(240 - (64 * arrowScalingFactor) - cornorArrowOffsetValue, (160 - (64 * arrowScalingFactor) - cornorArrowOffsetValue))];
	id totalUpRightArrowAnimation = [CCSequence actions:doNothingAction, moveUpRightArrow, nil];
	
	// Up Left arrow
	id moveUpLeftArrow = [CCMoveTo actionWithDuration:arrowAnimation position:ccp( - 240 + (64 * arrowScalingFactor) + cornorArrowOffsetValue, (160 - (64 * arrowScalingFactor) - cornorArrowOffsetValue))];
	id totalUpLeftArrowAnimation = [CCSequence actions:doNothingAction, moveUpLeftArrow, nil];
	
	// Actions for world map
	if(isAnimateWorld)
	{
		id action1 = [CCMoveTo actionWithDuration:dt position:ccp(posX,posY)];
		id action2 = [CCScaleBy actionWithDuration:dt scale:scalingFactor];
		[worldMapImage runAction:[CCSequence actions:[CCSpawn actions:action1, action2,nil],nil] ];
	}
	lookAtStageId = inputStageId;
	
	// Create a default menu
	ArrowMenu *dummyArrow = [ArrowMenu itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"];
	dummyArrow.position = ccp(1000,1000);
	showWholeMap = [CCMenuItemImage itemFromNormalImage:@"showWholeWorld.png" selectedImage:@"showWholeWorld.png" target:self selector:@selector(zoomOutFromStage:)];
	
	arrowMenu = [CCMenu menuWithItems:dummyArrow, nil];
	
	if(isAnimateArrow)
	{
		if (lookAtStageId == lookAtCity) {
			showWholeMap.position = ccp(-960,0); 
			[showWholeMap runAction:totalLeftArrowAnimation];	
			
			// Set the variables for the arrow menu
			ArrowMenu *rightArrow = [ArrowMenu itemFromNormalImage:@"rightArrow.png" selectedImage:@"rightArrow.png"
															target:self
														  selector:@selector(animateWorldMapWithArrows:)];
			rightArrow.scale = arrowScalingFactor;
			rightArrow.position = ccp(960,0);
			rightArrow.centerX = -480;
			rightArrow.centerY = 0;
			rightArrow.durationOfAnimation = animationDuration;
			rightArrow.goingToStageId = lookAtJungle;
			rightArrow.scalingFactor = 1.0f;
			rightArrow.fromStageId = 1;
			
			// Animate the button
			[rightArrow runAction: totalRightArrowAnimation];
			
			// Create a down arrow menu
			ArrowMenu *downArrow = [ArrowMenu itemFromNormalImage:@"downArrow.png" selectedImage:@"downArrow.png"
																		target:self
																	 selector:@selector(animateWorldMapWithArrows:)];
			downArrow.scale = arrowScalingFactor;
			downArrow.position = ccp(0,-640);
			downArrow.centerX = 0;
			downArrow.centerY = 320;
			downArrow.durationOfAnimation = animationDuration;
			downArrow.goingToStageId = lookAtIce;
			downArrow.scalingFactor = 1.0f;
			downArrow.fromStageId = 1;
			
			[downArrow runAction:totalDownArrowAnimation];
			
			// Create a right bottom arrow menu
			ArrowMenu *downRightArrow = [ArrowMenu itemFromNormalImage:@"downRightArrow.png" selectedImage:@"downRightArrow.png"
																	   target:self
																		  selector:@selector(animateWorldMapWithArrows:)];
			downRightArrow.scale = arrowScalingFactor;
			downRightArrow.position = ccp(960,-640);
			downRightArrow.centerX = -480;
			downRightArrow.centerY = 320;
			downRightArrow.durationOfAnimation = animationDuration;
			downRightArrow.goingToStageId = lookAtDesert;
			downRightArrow.scalingFactor = 1.0f;
			downRightArrow.fromStageId = 1;
			
			[downRightArrow runAction:totalDownRightArrowAnimation];
			
			// Add all the arrows
			[arrowMenu addChild:rightArrow];
			[arrowMenu addChild:downArrow];
			[arrowMenu addChild:downRightArrow];
			[arrowMenu	addChild:showWholeMap];
	}
		else if(lookAtStageId == lookAtJungle){
			
			showWholeMap.position = ccp(960,0); 
			[showWholeMap runAction:totalRightArrowAnimation];	
			
			// Set the variables for the arrow menu
			ArrowMenu *leftArrow = [ArrowMenu itemFromNormalImage:@"leftArrow.png" selectedImage:@"leftArrow.png"
															target:self
														  selector:@selector(animateWorldMapWithArrows:)];
			leftArrow.scale = arrowScalingFactor;
			leftArrow.position = ccp(-960,0);
			leftArrow.centerX = 480;
			leftArrow.centerY = 0;
			leftArrow.durationOfAnimation = animationDuration;
			leftArrow.goingToStageId = lookAtCity;
			leftArrow.scalingFactor = 1.0f;
			leftArrow.fromStageId = 2;
			
			// Animate the button
			[leftArrow runAction: totalLeftArrowAnimation];
			
			// Create a down arrow menu
			ArrowMenu *downArrow = [ArrowMenu itemFromNormalImage:@"downArrow.png" selectedImage:@"downArrow.png"
														   target:self
														 selector:@selector(animateWorldMapWithArrows:)];
			downArrow.scale = arrowScalingFactor;
			downArrow.position = ccp(0,-640);
			downArrow.centerX = 0;
			downArrow.centerY = 320;
			downArrow.durationOfAnimation = animationDuration;
			downArrow.goingToStageId = lookAtDesert;
			downArrow.scalingFactor = 1.0f;
			downArrow.fromStageId = 2;
			
			[downArrow runAction:totalDownArrowAnimation];
			
			// Create a right bottom arrow menu
			ArrowMenu *downLeftArrow = [ArrowMenu itemFromNormalImage:@"downLeftArrow.png" selectedImage:@"downLeftArrow.png"
																target:self
															  selector:@selector(animateWorldMapWithArrows:)];
			downLeftArrow.scale = arrowScalingFactor;
			downLeftArrow.position = ccp(-120,-640);
			downLeftArrow.centerX = 480;
			downLeftArrow.centerY = 320;
			downLeftArrow.durationOfAnimation = animationDuration;
			downLeftArrow.goingToStageId = lookAtIce;
			downLeftArrow.scalingFactor = 1.0f;
			downLeftArrow.fromStageId = 2;
			
			[downLeftArrow runAction:totalDownLeftArrowAnimation];
			
			// Add all the arrows
			[arrowMenu addChild:leftArrow];
			[arrowMenu addChild:downArrow];
			[arrowMenu addChild:downLeftArrow];
			[arrowMenu addChild:showWholeMap];
	}
		else if(lookAtStageId == lookAtIce){
			
			showWholeMap.position = ccp(-960,0); 
			[showWholeMap runAction:totalLeftArrowAnimation];	
			
			
			// Set the variables for the arrow menu
			ArrowMenu *rightArrow = [ArrowMenu itemFromNormalImage:@"rightArrow.png" selectedImage:@"rightArrow.png"
															target:self
														  selector:@selector(animateWorldMapWithArrows:)];
			rightArrow.scale = arrowScalingFactor;
			rightArrow.position = ccp(960,0);
			rightArrow.centerX = -480;
			rightArrow.centerY = 0;
			rightArrow.durationOfAnimation = animationDuration;
			rightArrow.goingToStageId = lookAtDesert;
			rightArrow.scalingFactor = 1.0f;
			rightArrow.fromStageId = 3;
			
			// Animate the button
			[rightArrow runAction: totalRightArrowAnimation];
			
			// Create a down arrow menu
			ArrowMenu *upArrow = [ArrowMenu itemFromNormalImage:@"upArrow.png" selectedImage:@"upArrow.png"
														   target:self
														 selector:@selector(animateWorldMapWithArrows:)];
			upArrow.scale = arrowScalingFactor;
			upArrow.position = ccp(0,640);
			upArrow.centerX = 0;
			upArrow.centerY = -320;
			upArrow.durationOfAnimation = animationDuration;
			upArrow.goingToStageId = lookAtCity;
			upArrow.scalingFactor = 1.0f;
			upArrow.fromStageId = 1;
			
			[upArrow runAction:totalUpArrowAnimation];
			
			// Create a right bottom arrow menu
			ArrowMenu *upRightArrow = [ArrowMenu itemFromNormalImage:@"upRightArrow.png" selectedImage:@"upRightArrow.png"
																target:self
															  selector:@selector(animateWorldMapWithArrows:)];
			upRightArrow.scale = arrowScalingFactor;
			upRightArrow.position = ccp(960,640);
			upRightArrow.centerX = -480;
			upRightArrow.centerY = -320;
			upRightArrow.durationOfAnimation = animationDuration;
			upRightArrow.goingToStageId = lookAtJungle;
			upRightArrow.scalingFactor = 1.0f;
			upRightArrow.fromStageId = 1;
			
			[upRightArrow runAction:totalUpRightArrowAnimation];
			
			// Add all the arrows
			[arrowMenu addChild:rightArrow];
			[arrowMenu addChild:upArrow];
			[arrowMenu addChild:upRightArrow];
			[arrowMenu	addChild:showWholeMap];
	}
		else if(lookAtStageId == lookAtDesert){
		// Set the variables for the arrow menu
			showWholeMap.position = ccp(960,0); 
			[showWholeMap runAction:totalRightArrowAnimation];	
			
			ArrowMenu *leftArrow = [ArrowMenu itemFromNormalImage:@"leftArrow.png" selectedImage:@"leftArrow.png"
														   target:self
														 selector:@selector(animateWorldMapWithArrows:)];
			leftArrow.scale = arrowScalingFactor;
			leftArrow.position = ccp(-960,0);
			leftArrow.centerX = 480;
			leftArrow.centerY = 0;
			leftArrow.durationOfAnimation = animationDuration;
			leftArrow.goingToStageId = lookAtIce;
			leftArrow.scalingFactor = 1.0f;
			leftArrow.fromStageId = 4;
			
			// Animate the button
			[leftArrow runAction: totalLeftArrowAnimation];
			
			// Create a down arrow menu
			ArrowMenu *upArrow = [ArrowMenu itemFromNormalImage:@"upArrow.png" selectedImage:@"upArrow.png"
														 target:self
													   selector:@selector(animateWorldMapWithArrows:)];
			upArrow.scale = arrowScalingFactor;
			upArrow.position = ccp(0,640);
			upArrow.centerX = 0;
			upArrow.centerY = -320;
			upArrow.durationOfAnimation = animationDuration;
			upArrow.goingToStageId = lookAtJungle;
			upArrow.scalingFactor = 1.0f;
			upArrow.fromStageId = 4;
			
			[upArrow runAction:totalUpArrowAnimation];
			
			ArrowMenu *upLeftArrow = [ArrowMenu itemFromNormalImage:@"upLeftArrow.png" selectedImage:@"upLeftArrow.png"
														 target:self
													   selector:@selector(animateWorldMapWithArrows:)];
			upLeftArrow.scale = arrowScalingFactor;
			upLeftArrow.position = ccp(-960,640);
			upLeftArrow.centerX = 480;
			upLeftArrow.centerY = -320;
			upLeftArrow.durationOfAnimation = animationDuration;
			upLeftArrow.goingToStageId = lookAtCity;
			upLeftArrow.scalingFactor = 1.0f;
			upLeftArrow.fromStageId = 4;
			
			[upLeftArrow runAction:totalUpLeftArrowAnimation];
			
			// Add all the arrows
			[arrowMenu addChild:leftArrow];
			[arrowMenu addChild:upArrow];
			[arrowMenu addChild:upLeftArrow];
			[arrowMenu addChild:showWholeMap];
		}
	}

	[self addChild:arrowMenu];
}


-(void)animateWorldMapWithArrows:(ArrowMenu*) sender 
{
	id action1 = [CCMoveBy actionWithDuration:sender.durationOfAnimation position:ccp(sender.centerX,sender.centerY)];
	id action2 = [CCScaleBy actionWithDuration:sender.durationOfAnimation scale:sender.scalingFactor];
	[worldMapImage runAction:action1];
	[worldMapImage runAction:action2];
	lookAtStageId = sender.goingToStageId;
	
	// Clean the arrow menu
	[self removeChild:arrowMenu cleanup:TRUE];

	[self animateTheWorldMap:0 yPosition:0 duration:0 arrowDuration:1.3 scale:sender.scalingFactor selectLevelFor:sender.goingToStageId animateWorld:FALSE animateArrows:TRUE];
	
	NSLog(@"Arrow menu Item clicked");
	NSLog(@"Arrow going from : %d", sender.fromStageId);
	NSLog(@"Arrow going to %d", sender.goingToStageId);
}



-(void)zoomOutFromStage:(CCMenuItemImage*) sender 
{
	[self schedule:@selector(enablingTouchAgain) interval:2.1f];
	// Remove the menu
	[self removeChild:arrowMenu cleanup:TRUE];
	[self animateTheWorldMap:240 yPosition:160 duration:1 arrowDuration:0.1 scale:0.5f selectLevelFor:0 animateWorld:TRUE animateArrows:FALSE];
}

-(void)enablingTouchAgain
{
	showWholeWorldIcon = TRUE;
	[self unschedule:@selector(enablingTouchAgain)];
}


-(void)addAllLevelImagesOnTheWorldImage
{
	int lId = 0;
	int sId = 0;
	
	for (sId = 1; sId <= 4; sId++) {
		for (lId = 1; lId <= 4; lId++) {
			int centerOfX = 0;
			int centerOfY = 0;
			
			allLevelsInGame[sId][lId] = [CCSprite spriteWithFile:@"disabled.png"];
			allLevelsInGame[sId][lId].scale = 0.7f;
			
			if(sId == lookAtCity){
				centerOfX = 240;
				centerOfY = 480;// + 320;
			}else if (sId == lookAtJungle) {
				centerOfX = 720;
				centerOfY = 480;
			}else if (sId == lookAtIce) {
				centerOfX = 240;
				centerOfY = 160;
			}else if(sId == lookAtDesert){
				centerOfX = 720;// + 480;
				centerOfY = 160;
			}
			
			if (lId == lookAtCity) {
				allLevelsInGame[sId][lId].position = ccp(centerOfX - levelSelectorOffsetX, centerOfY + levelSelectorOffsetY);
			}else if (lId == lookAtJungle) {
				allLevelsInGame[sId][lId].position = ccp(centerOfX + levelSelectorOffsetX, centerOfY + levelSelectorOffsetY);
			}else if (lId == lookAtIce) {
				allLevelsInGame[sId][lId].position = ccp(centerOfX - levelSelectorOffsetX, centerOfY - levelSelectorOffsetY);
			}else if (lId == lookAtDesert) {
				allLevelsInGame[sId][lId].position = ccp(centerOfX + levelSelectorOffsetX, centerOfY - levelSelectorOffsetY);
			}
			
			
			[worldMapImage addChild:allLevelsInGame[sId][lId]];
			
		}
	}
	
	
	
}







@end
