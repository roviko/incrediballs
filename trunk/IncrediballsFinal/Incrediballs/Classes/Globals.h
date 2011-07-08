//
//  Globals.h
//  Incrediballs
//
//  Created by student on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DatabaseManager.h"

// Global Distance label
CCLabelTTF *gLabelDistance;
CCLabelTTF *gLabelScore;
//temporary 3 power buttons
CCMenuItemImage *gPowerButton1;
CCMenuItemImage *gPowerButton2;
CCMenuItemImage *gPowerButton3;
CCSprite *powerArray[6];
bool powerUsedArray[3];
short powerUsedCount[3];


// ball related variables
const static int numMenuBalls = 8;
int gBallID;
float gBallMass;
float gBallElasticity;
float gBallFriction;
int gBallPower1;
int gBallPower2;
int gBallPower3;
int collPowerFlag;
int shadPowerFlag;

// map and level related variables

int giMapType;		// 1 for city, 2 for Jungle, 3 for ice, 4 for desert
int giLevelNumber;	// stores which level is being selected
int giWorldId;
int gMinItemsToCollect;
int giItemCollected;
int giScoreRecieved;

// User related variables
int gUserId;
int gUserHighScore;
NSString* gUserName;


// Database instance to user everywhere
DatabaseManager* gDbManager;

// Variable related to tutorials
bool gIsTutorialSelected;
int gTutNumber;

bool playGeneralSound;

@interface Globals : CCLayer {

}

@end
