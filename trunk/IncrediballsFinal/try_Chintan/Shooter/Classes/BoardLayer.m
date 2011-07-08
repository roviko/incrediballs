//
//  BoardLayer.m
//  Shooter
//
//  Created by CHINTANKUMAR PATEL on 2/24/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "BoardLayer.h"
#import "CCTouchDispatcher.h"
#import "Globals.h"

@implementation BoardLayer

CCSprite *machineL;
CCSprite *machineR;
CGRect LeftPanel;
CGRect RightPanel;
Ball *prevLeftBall;
Ball *prevRightBall;
NSMutableArray *ballsWithSameColor;
NSMutableArray *ballsToBeBursted;
int leftOffset;
int bottomOffset;
float fMovingAnimation;
int tempInt;


+ (id)scene
{
	CCScene *scene = [CCScene node];
	
	BoardLayer *layer = [BoardLayer node];
	
	[scene addChild:layer];
	
	return scene;
}

- (id) init
{
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"Icon.png" selectedImage:@"Icon.png"
															   target:self
															 selector:@selector(resetBalls)];
		
		item1.position = ccp(200,-125);
		
		
		CCMenu *menu = [CCMenu menuWithItems:item1,nil];
		
		[self addChild:menu];
		
		[self setGlobleVariables];
		
		[self setupBoard];
		
		
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
	}
	
	return self;
}


// Following function is used to set all the global variables of file level

-(void) setGlobleVariables
{
	oBalls = [[NSMutableArray alloc] init];
	
	ballsWithSameColor = [[NSMutableArray alloc] init];
	ballsToBeBursted = [[NSMutableArray alloc] init];
	
	// left rect box 
	LeftPanel = CGRectMake(0, 0, 240, 320);
	
	//right rect box
	RightPanel = CGRectMake(240, 0, 240, 320);
	
	leftOffset = 120;
	bottomOffset = 40;
	
	fMovingAnimation = 0.6f;
	
	tempInt = 0;
}


// following function is used to created the starting setup for board

-(void) setupBoard
{
	// background board
	CCSprite *board = [CCSprite spriteWithFile:@"Shooterboard2.png"];
	board.position = ccp(240,160);
	
	// left shooting machine
	machineL = [CCSprite spriteWithFile:@"FireMachineLeft.png"];
	machineL.position = ccp(240 - 5*30,160);
	
	
	//right shooting machine
	machineR = [CCSprite spriteWithFile:@"FireMachineRight.png"];
	machineR.position = ccp(240 + 5*30,160);
	
	prevLeftBall = [Ball spriteWithFile:@"circle1.png"];
	prevLeftBall.position = ccp(machineL.contentSize.width/2,machineL.contentSize.height/2);
	prevRightBall = [Ball spriteWithFile:@"circle1.png"];
	prevRightBall.position = ccp(machineR.contentSize.width/2,machineR.contentSize.height/2);
	
	[self addChild:board];
	[self addChild:machineL];
	[self addChild:machineR];
	[machineL addChild:prevLeftBall];
	[machineR addChild:prevRightBall];
	
	[self addMiddleLine];
	
	[self createBallAt:LEFT];
	[self createBallAt:RIGHT];
}


// Following function adds the middle line of squares at the begin of the setup of the board

-(void) addMiddleLine
{
	int randColor = 0;
	int min = 1;
	int max = 5;
	
	//previous color is used to make sure there are no consecutive same color
	int prevColor = 0;
	
	for (int i = 0; i < NUMGRID; i++) {
	
		while (prevColor == randColor) {
			randColor =  (arc4random() % (max-min+1)) + min ;
		}
		
		Ball *square = [Ball spriteWithFile:[NSString stringWithFormat:@"square%d.png",randColor]];
	
		square.position = ccp(leftOffset + 30 * 4, bottomOffset + 30 * i);
		square.iQuadrant = 0; // no specific quadrant hence 0
		square.iColorIndex = randColor;
		square.iPositionIndex = ccp(4,i); // In this case this number shows the position in middle line
		square.isChecked = FALSE;
		square.toBeRemoved = FALSE;
		
		arrBall[4][i] = square;
		
		[self addChild:square];
		
		prevColor = randColor;
	}	
}


// Following function adds new ball on machine, basically one ball is always attached to each machine, in following function only the color changes

- (void) createBallAt:(BOOL)isLeft
{
	int randColor = 0;
	int min = 1;
	int max = 5;
	
	randColor =  (arc4random() % (max-min+1)) + min ;
	NSLog(@"%d",randColor);
	
	
	if (isLeft) {
		[prevLeftBall setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"circle%d.png",randColor]]];
	
		// setting properties of the ball
		prevLeftBall.iColorIndex = randColor;
		prevLeftBall.iQuadrant = 2;
		prevLeftBall.iPositionIndex = ccp(-1,-1);
		prevLeftBall.isChecked = FALSE;
		prevLeftBall.toBeRemoved = FALSE;
	}
	else {
		[prevRightBall setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"circle%d.png",randColor]]];
	
		// setting properties of the ball
		prevRightBall.iColorIndex = randColor;
		prevRightBall.iQuadrant = 2;
		prevRightBall.iPositionIndex = ccp(-1,-1);
		prevRightBall.isChecked = FALSE;
		prevRightBall.toBeRemoved = FALSE;
	}
}


// Clears all balls from the entire board

-(void)resetBalls
{
	int count = 0;
	NSLog(@"Inside Reset");
	
	// remove all the balls from the layer
	for (Ball *b in oBalls) {
		
		[self removeChild:b cleanup:NO];
		NSLog(@"removed : %d",count);
	
		count++;
	}
	
	// remove all squares rom middle line
	
	for (int i = 0; i < NUMGRID; i++) {
		[self removeChild:arrBall[4][i] cleanup:NO];
	}
	
	
	// make all the reference from arrBall to NULL
	
	for (int i = 0; i < NUMGRID; i++) {
		for (int j = 0; j < NUMGRID; j++) {
			
			if (arrBall[i][j] == NULL) {
				NSLog(@"(%d,%d) is NULL",i,j);
			}
			else {
				
				NSLog(@"(%d,%d) =========",i,j);
				arrBall[i][j] = NULL;
			}

		}
	}
	
	// empty out ball-storing array
	[oBalls removeAllObjects];
	
	// again add middle line for next game
	[self addMiddleLine];
}

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	BOOL isLeft = [self isLeftMachineSelected: touchLocation];
	[self restrictMachineMovement: touchLocation Machine: isLeft];
	
	return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint curLocation = [touch locationInView: [touch view]];
	curLocation = [[CCDirector sharedDirector] convertToGL:curLocation];


	BOOL isLeft = [self isLeftMachineSelected: curLocation];
	[self restrictMachineMovement:curLocation Machine:isLeft];
}


// For each touch following function checks which side the touch is, left or right and  returns boolean value

-(BOOL) isLeftMachineSelected: (CGPoint) location
{
	BOOL returnValue = FALSE;
	
	if (CGRectContainsPoint(LeftPanel, location)) {
		
		returnValue = TRUE;
	}
	
	return returnValue;
}


// Following function restricts the movement of the both machine at bottom and top to keep them within the board boundary. Basically boundary condition check. 

-(void) restrictMachineMovement: (CGPoint) curLocation Machine : (BOOL) isLeft
{
	int machineCantMove = 0;
	int numSlots = NUMGRID / 2;
	
	if (isLeft) {
		
		if (curLocation.y <= 160 - 30*numSlots) {
			machineL.position = ccp(machineL.position.x,160 - 30*numSlots);
			machineCantMove = 1;
		}
		if (curLocation.y >= 160 + 30*numSlots) {
			machineL.position = ccp(machineL.position.x,160 + 30*numSlots);
			machineCantMove = 1;
		}
		if (machineCantMove == 0) {
			machineL.position = ccp(machineL.position.x,curLocation.y);
		}
		
	}
	else{
		if (curLocation.y <= 160 - 30*numSlots) {
			machineR.position = ccp(machineR.position.x,160 - 30*numSlots);
			machineCantMove = 1;
		}
		if (curLocation.y >= 160 + 30*numSlots) {
			machineR.position = ccp(machineR.position.x,160 + 30*numSlots);
			machineCantMove = 1;
		}
		if (machineCantMove == 0) {
			machineR.position = ccp(machineR.position.x,curLocation.y);
		}
	}
}


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	[self adjustMachinePos: touchLocation];
	[self shootNewBall: touchLocation];
	
}


// Before shooting ball, the position of the machine is adjusted such a way that they shoot the ball exactly in the middle of the grid. And not anywhere overlapping two grids

-(void) adjustMachinePos: (CGPoint) curLocation
{
	int numSlots = 4;
	
	BOOL isLeft = [self isLeftMachineSelected: curLocation];
	
	for (int i = 160 - 30*(numSlots - 1); i <= 160 + 30*numSlots; i += 30) {
		
		if (curLocation.y < i) {
			
			if (curLocation.y >= i - 15) {
				
				if (isLeft) {
					machineL.position = ccp(machineL.position.x,i);
				}
				else {
					machineR.position = ccp(machineR.position.x,i);
				}

			}
			else {
				
				if (isLeft) {
					machineL.position = ccp(machineL.position.x,i - 30);
				}
				else {	
					machineR.position = ccp(machineR.position.x,i - 30);
				}
			}

			break;
		}
	}
}


// For arrBall reference

// |------LEFT SIDE-------|SQAURES|------RIGHT SIDE------| 
// (0,8) (1,8) (2,8) (3,8) [[4,8]] (5,8) (6,8) (7,8) (8,8)
// (0,8) (1,7) (2,7) (3,7) [[4,7]] (5,7) (6,7) (7,7) (8,7)
// (0,8) (1,6) (2,6) (3,6) [[4,6]] (5,6) (6,6) (7,6) (8,6)
// (0,8) (1,5) (2,5) (3,5) [[4,5]] (5,5) (6,5) (7,5) (8,5)
// (0,8) (1,4) (2,4) (3,4) [[4,4]] (5,4) (6,4) (7,4) (8,4)
// (0,8) (1,3) (2,3) (3,3) [[4,3]] (5,3) (6,3) (7,3) (8,3)
// (0,8) (1,2) (2,2) (3,2) [[4,2]] (5,2) (6,2) (7,2) (8,2)
// (0,8) (1,1) (2,1) (3,1) [[4,1]] (5,1) (6,1) (7,1) (8,1)
// (0,8) (1,0) (2,0) (3,0) [[4,0]] (5,0) (6,0) (7,0) (8,0)


// After the position being adjusted for machine, following function calculates the new position of the ball on the board

-(void) shootNewBall: (CGPoint) curLocation
{
	// needs to calculate ball position, y is found but needs restrictions and x to be calculated
	
	int newXPos = -1;
	int newYPos = 0;
	BOOL isLeft = [self isLeftMachineSelected: curLocation];
	
	//add new ball each click, change it to fire ball
	if (isLeft) {
		
		
		// first find the newYpos for new ball's y position
		newYPos = (machineL.position.y - bottomOffset) / 30;
		
		// now check which position is available for given Y
		for (int i=3; i >= 0; i--) {
			
			if (arrBall[i][newYPos] == NULL) {
				newXPos = i;
				break;
			}
		}
		
		if (newXPos == -1) {
			// if newXPos is not being set in above for loop means game is over
			
			// GAME OVER
			
			[self gameOver];
			return;
		}
		
		// also call function to shoot ball from  previous machine to designated positions
		[self moveNewBall:ccp(newXPos, newYPos) Machine:LEFT];
		[self createBallAt:LEFT];
	}
	else {
		
		// first find the newYpos for new ball's y position
		newYPos = (machineR.position.y - bottomOffset) / 30;
		
		// now check which position is available for given Y
		for (int i=5; i <= 8; i++) {
			
			if (arrBall[i][newYPos] == NULL) {
				newXPos = i;
				break;
			}
		}
		
		if (newXPos == -1) {
			// if newXPos is not being set in above for loop means game is over
			
			// GAME OVER
			
			[self gameOver];
			return;
		}
		
		[self moveNewBall:ccp(newXPos, newYPos) Machine:RIGHT];
		[self createBallAt:RIGHT];
	}
	
}



// Following function adds the new ball on board and moves it to the required position "newPos", Machine gives parameter for which machine shot the ball

-(void) moveNewBall: (CGPoint) newPos Machine : (BOOL) isLeft
{
	int iColor = 1;
	if (isLeft) {
		iColor = prevLeftBall.iColorIndex;
	}
	else {
		iColor = prevRightBall.iColorIndex;
	}
	
	Ball *ball = [Ball spriteWithFile:[NSString stringWithFormat:@"circle%d.png",iColor]];
	ball.position = ccp(leftOffset + newPos.x * 30 , bottomOffset + newPos.y * 30);
	ball.iColorIndex = iColor;
	ball.iQuadrant = 2;
	ball.iPositionIndex = newPos;
	ball.isChecked = FALSE;
	ball.toBeRemoved = FALSE;
	
	arrBall[(int)newPos.x][(int)newPos.y] = ball;
	// adding ball to the array
	[oBalls addObject:ball];
	
	// adding ball to layer
	[self addChild:ball];
	
	
	// After the ball has been placed check for 3 same color balls
	[self burstAlgorithm];
	
	
	
	//NSLog(@"Total checks : %d",tempInt);
	//tempInt = 0;
}



// Following function is heart of the game. Here matching of 3/more same color balls are detected

-(void) burstAlgorithm
{
	[self unschedule:@selector(burstAlgorithm)];

	for (int i = 0; i < NUMGRID; i++) {
		for (int j = 0; j < NUMGRID; j++) {
			
			// if ball is present at current position then only check or skip position and move to next
			
			if (arrBall[i][j] != NULL) {
					
				// if present ball is not not check before then only check it
				
				if (arrBall[i][j].isChecked == FALSE) {
				
					// now check the color of the current ball and run color fill algorithm to find out its neighbours
					
					[self colorMatchingAlgorithm: arrBall[i][j].iColorIndex ballPosition:ccp(i,j)];
					
					if ([ballsWithSameColor count] > 2) {
						NSLog(@"Comes Here");
						[ballsToBeBursted addObjectsFromArray:ballsWithSameColor];
					}
					[ballsWithSameColor removeAllObjects];
				}
			}
		
		}
	}
	
	// after the algorithm is run now make all the balls to unchecked
	for (int i = 0; i < NUMGRID; i++) {
		for (int j = 0; j < NUMGRID; j++) {
			if (arrBall[i][j] != NULL) {
				arrBall[i][j].isChecked = FALSE;
			}
		}
	}
	
	if ([ballsToBeBursted count] > 2) {
		[self manageScores];
		[self schedule:@selector(burstAlgorithm) interval:fMovingAnimation];
	}
	else {
		[ballsToBeBursted removeAllObjects];
	}


}



// Following function is algorithm to find out the balls with the same color

-(void) colorMatchingAlgorithm: (int) iColor ballPosition: (CGPoint) pos
{
	//check if pos is valid ball position
	if (pos.x >= NUMGRID || pos.x < 0 || pos.y >= NUMGRID || pos.y < 0) {
		return;
	}
	
	Ball *curBall = arrBall[(int)pos.x][(int)pos.y];
	
	if (curBall == NULL) {
		return;
	}
	
	// check if given ball has the required color
	if (curBall.iColorIndex == iColor && curBall.isChecked == FALSE) {
		
		curBall.isChecked = TRUE;
		
		// if ball does have require color add it to array and check for its surrounding balls
		
		//1. add to array
		[ballsWithSameColor addObject:curBall];
		
		
		//2. Check for surrounding balls
	
		//right ball
		[self colorMatchingAlgorithm:iColor ballPosition:ccp(pos.x + 1, pos.y)];
			
		//top ball
		[self colorMatchingAlgorithm:iColor ballPosition:ccp(pos.x, pos.y + 1)];
		
		//left ball
		[self colorMatchingAlgorithm:iColor ballPosition:ccp(pos.x - 1, pos.y)];
		
		//bottom ball
		[self colorMatchingAlgorithm:iColor ballPosition:ccp(pos.x, pos.y - 1)];
		
	}
	else {
		return;
	}

}


// Following function checks whether are there balls to be removed from the board and how the scoring should be done
-(void) manageScores
{
	// if we have more then 2 balls of same color then only do scoring
	
	if ([ballsToBeBursted count] > 2) {
		
		NSLog(@"Burst successful");
		
		// do somthing for scoring depending on the number of balls
		

		for (Ball *b in ballsToBeBursted) {
			
			CGPoint pos = b.iPositionIndex;
			
			if (pos.x < 4) {
				//ball from left half
				
				for (int i = pos.x; i > 0; i--) {
					
					Ball *curBall = arrBall[i - 1][(int)pos.y];
					
					if (curBall != NULL) {
						[curBall runAction:[CCMoveTo actionWithDuration:fMovingAnimation position:ccp(leftOffset + i * 30,curBall.position.y)]];
					}
					
					curBall.iPositionIndex = ccp(i,curBall.iPositionIndex.y);
					
					arrBall[i][(int)pos.y] = curBall;
					
				}
				arrBall[0][(int)pos.y] = NULL;
				
			}
			else if (pos.x > 4) {
				//ball from right half
				
				for (int i = pos.x; i < NUMGRID - 1; i++) {
					
					Ball *curBall = arrBall[i + 1][(int)pos.y];
					
					if (curBall != NULL) {
						[curBall runAction:[CCMoveTo actionWithDuration:fMovingAnimation position:ccp(leftOffset + i * 30,curBall.position.y)]];
					}
					
					curBall.iPositionIndex = ccp(i,curBall.iPositionIndex.y);
					
					arrBall[i][(int)pos.y] = curBall;
					
				}
				arrBall[NUMGRID - 1][(int)pos.y] = NULL;
			}
			else { // pos.x == 4
				//squares from middle line
				
				for (int i = pos.y; i < NUMGRID - 1; i++) {
					Ball *curSqaure = arrBall[4][i + 1];
					
					if (curSqaure != NULL) {
						[curSqaure runAction:[CCMoveTo actionWithDuration:fMovingAnimation position:ccp(curSqaure.position.x, bottomOffset + 30 * i)]];
					}
					
					curSqaure.iPositionIndex = ccp(4, i);
					
					arrBall[4][i] = curSqaure;
				}
				
				// add new square at the top.
				
				int randColor = 0;
				int min = 1;
				int max = 5;
				
				randColor =  (arc4random() % (max-min+1)) + min ;
				
				Ball *square = [Ball spriteWithFile:[NSString stringWithFormat:@"square%d.png",randColor]];
				
				square.position = ccp(leftOffset + 30 * 4, 350);
				square.iQuadrant = 0; // no specific quadrant hence 0
				square.iColorIndex = randColor;
				square.iPositionIndex = ccp(4,NUMGRID - 1); // In this case this number shows the position in middle line
				square.isChecked = FALSE;
				square.toBeRemoved = FALSE;
				
				[self addChild:square];
				
				[square runAction:[CCMoveTo actionWithDuration:fMovingAnimation position:ccp(square.position.x, bottomOffset + 30 * (NUMGRID - 1))]];
				
				arrBall[4][NUMGRID - 1] = square;
			}

			[b runAction:[CCScaleTo actionWithDuration:fMovingAnimation]];
			
			// removed each ball from the board
			//[self removeChild:b cleanup:NO];
			
		}
		
		
		
	}
	
	// Clear the mutable array for next ball
	[ballsToBeBursted removeAllObjects];
}


// Following function is called when game is over

-(void) gameOver
{
	[self resetBalls];
}


#define kFilterFactor 0.05
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration{
	static float prevX=0, prevY=0;
	int machineCantMove = 0;
	float vel = 0.0f;
	float velFactor = 700.0f;
	
	float accelX = acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	float diffX = accelX - prevX;
	float diffY = accelY - prevY;
	
	//NSLog(@"%f %f",diffX,diffY);
	
	if (diffX > 0.005) {
		vel = velFactor * diffX;
	}
	else {
		if (diffX < -0.005) {
			vel = velFactor * diffX;
		}
		
	}
	
	//NSLog(vel)
	float newYPosL = machineL.position.y + vel;
	
	// move left machine
	if (newYPosL < 58) {
		machineL.position = ccp(machineL.position.x,58);
		machineCantMove = 1;
	}
	if (newYPosL > 262) {
		machineL.position = ccp(machineL.position.x,262);
		machineCantMove = 1;
	}
	if (machineCantMove == 0) {
		machineL.position = ccp(machineL.position.x,newYPosL);
	}	
	
	machineCantMove = 0;
	
	float newYPosR = machineR.position.y + vel;
	// move right machine
	if (newYPosR < 58) {
		machineR.position = ccp(machineR.position.x,58);
		machineCantMove = 1;
	}
	if (newYPosR > 262) {
		machineR.position = ccp(machineR.position.x,262);
		machineCantMove = 1;
	}
	if (machineCantMove == 0) {
		machineR.position = ccp(machineR.position.x,newYPosR);
	}

	

	
	static BOOL fireLeft = FALSE;
	static BOOL fireRight = FALSE;
	
	

	if (diffY > 0.02) {
		
		if (fireLeft == FALSE) {
			
			//shoot left
			[self moveNewBall:ccp(264,machineR.position.y) Machine:RIGHT];
			[self createBallAt:RIGHT];
			fireLeft = TRUE;
		}
	}
	else {
		fireLeft = FALSE;
		if (diffY < -0.02) {
			
			if (fireRight == FALSE) {
				
				// shoot right
				[self moveNewBall:ccp(216,machineL.position.y) Machine:LEFT];
				[self createBallAt:LEFT];
				fireRight = TRUE;
			}
		
		}
		else {
			fireRight = FALSE;
		}
	}

	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	
	
	//NSLog(@"%f %f",accelX,accelY);
}

@end
