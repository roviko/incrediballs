//
//  TutorialBuilder.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/15/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "HUD.h"
#import "BackgroundMap.h"
#import "Globals.h"
#import "Power.h"

@interface TutorialBuilder : CCLayer {
	
	CCTMXTiledMap *theMap;
	CCTMXLayer *bgLayer;
	cpSpace *space;
	CCSprite *revPower;
	CCSprite *spritePower1;
	BOOL isBallFired;
	float firePower;
	int ballCount;
	float angleOfShoot;
	BOOL isTutorialFinished;
	
	CCSprite *collectable[16];
	BackgroundMap *frontBackground;
	BackgroundMap *backBackground;
}

@property (nonatomic, retain) CCTMXTiledMap *theMap;
@property (nonatomic, retain) CCTMXLayer *bgLayer;
@property (nonatomic, retain) CCSprite *revPower;
@property (nonatomic, retain) CCSprite *spritePower1;
@property (readwrite) BOOL isBallFired;
@property (readwrite) float firePower;
@property (readwrite) int ballCount;
@property (readwrite) float angleOfShoot;
@property (readwrite) BOOL isTutorialFinished;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) setGlobalVariables;
-(void) setLevelMap;
-(void) addBackground;
-(void) getParent;
-(void) step: (ccTime) dt;
-(void) addNewSpriteX:(float)x y:(float)y power:(float)firePower angle:(float)fireAngle;
-(void) setCenterOfScreen:(CGPoint) position;
-(void) setScaleOfScreen:(CGPoint) position;
-(void) addTracePath:(CGPoint) position;
-(void) removeTracePath;
-(void) reAttempt;
-(void) showRetryPopup;
-(void) changeRotationAnimation:(CGPoint)touchLocation;
-(void) calculatePowerForTouch:(CGPoint)touchLocation;
-(void) changePowerAnimation;
-(void) moveBackground:(CGPoint)position diffPos:(CGPoint) difference;
-(void) addPlatformCollision:(int)startTile endTile:(int)endTile height:(int)iHeight;
-(void) scrollMapBySlide: (CGPoint)touchLocation;
-(void) displayTouchImage: (CGPoint) position;
-(void) shootBall;
-(void) fireBall;
-(void) powerUsed;
-(void) powerUsed2;
-(void) powerUsed3;
//static int myBeginCollision(cpArbiter *arb, cpSpace *space, void *unused);



@end
