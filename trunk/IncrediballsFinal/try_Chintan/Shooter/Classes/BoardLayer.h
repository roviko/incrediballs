//
//  BoardLayer.h
//  Shooter
//
//  Created by CHINTANKUMAR PATEL on 2/24/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ball.h"

@interface BoardLayer : CCLayer {

	NSMutableArray *oBalls;
	Ball *arrBall[9][9];
}

+(id)scene;
-(void) setGlobleVariables;
-(void) setupBoard;
-(void) addMiddleLine;
-(BOOL) isLeftMachineSelected: (CGPoint) location;
-(void) restrictMachineMovement: (CGPoint) curLocation Machine : (BOOL) isLeft;
-(void) createBallAt:(BOOL)isLeft;
-(void)resetBalls;
-(void) adjustMachinePos: (CGPoint) curLocation;
-(void) shootNewBall: (CGPoint) curLocation;
-(void) moveNewBall: (CGPoint) newPos Machine : (BOOL) isLeft;
-(void) burstAlgorithm;
-(void) colorMatchingAlgorithm: (int) iColor ballPosition: (CGPoint) pos;
-(void) manageScores;
-(void) gameOver;

@end