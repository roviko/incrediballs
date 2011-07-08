//
//  TutorialHUD.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/15/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "TutorialHUD.h"
#import "TutorialMultiLayer.h"
#import "TutorialScene.h"
#import "DatabaseManager.h"
#import "Tutorial.h"



@implementation TutorialHUD


@synthesize distance;
@synthesize ballTurnMenu;
@synthesize ballLeftItem;
@synthesize isTutorialFinished;
@synthesize isBeginOccur;
@synthesize isMoveOccur;
@synthesize eventID;

TutorialMultiLayer *parent;
TutorialBuilder *curLevel;


CCMenuItemImage *shootButton;
CCSprite *instructionWindow;
CCLabelTTF *instructionHeader;
CCLabelTTF *instructionText;
CCSprite *touchImage;
CCSprite *touchFinger;

BOOL isPowerPresent;
BOOL isTurnBallPresent;
BOOL isShootPresent;
BOOL isTouchImagePresent; 

- (id) init
{
	
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;

		[self setGlobalVariables];
		
		[self generalInit];
		
		[self callTutorialSpecificInit];
		
		[self schedule:@selector(getParent) interval:0.1];
		
		[self schedule:@selector(callEveryFrame) interval:0.1];
	}
	return self;
}

-(void) setGlobalVariables
{
	isPowerPresent = FALSE;
	isTurnBallPresent = FALSE;
	isShootPresent = FALSE;
	isTutorialFinished = FALSE;
	isBeginOccur = FALSE;
	isMoveOccur = FALSE;
	isTouchImagePresent = FALSE;
	
	eventID = 0;
	//NSLog(@"Inside set global : %d",(int)isTutorialFinished);
}

-(void) generalInit
{
	shootButton = [CCMenuItemImage itemFromNormalImage:@"shoot.png" selectedImage:@"shoot.png"
												target:self
											  selector:@selector(callShootFunction)];
	shootButton.position = ccp(240 - [shootButton boundingBox].size.width/2,0);
	//shootButton.opacity = 235.0f;
	
	instructionWindow = [CCSprite spriteWithFile:@"commonPopupBackground.png"];
	instructionWindow.scale = 0.3f;
	instructionWindow.color = ccc3(153, 0, 0);
	instructionWindow.position = ccp(240,273);
	
	DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
	NSMutableDictionary *arrTutInfo = [dbInstance getAllTutorialInformation];
	
	Tutorial *tutInfo = (Tutorial *)[arrTutInfo objectForKey:[NSNumber numberWithInt:gTutNumber]];
	
	NSString *title = [tutInfo title];
	NSString *desc = [tutInfo description];
	
	//NSLog(title);
									 
	instructionHeader = [CCLabelTTF labelWithString:title fontName:@"Marker Felt" fontSize:60];
	instructionHeader.position = ccp(240,250);
	//instructionHeader.color = ccc3(204, 204, 0);
	
	instructionText = [CCLabelTTF labelWithString:desc dimensions:CGSizeMake(instructionWindow.contentSize.width - 90, instructionWindow.contentSize.height - 140) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:45];
	instructionText.position = ccp(250,100);
	//instructionText.color = ccc3(204, 204, 0);
	
	
	touchImage = [CCSprite spriteWithFile:@"tutTouch.png"];
	touchImage.scale = 0.6;
	
	touchFinger = [CCSprite spriteWithFile:@"finger.png"];
	touchFinger.scale = 0.6;
	
	[self addChild:instructionWindow];
	[instructionWindow addChild:instructionHeader];
	[instructionWindow addChild:instructionText];
	
}

-(void) callTutorialSpecificInit
{
	[self schedule:@selector(animateTouchImage:)];
	
	switch (gTutNumber) {
		case 1: // set angle
			[self tut1Init];
			break;
		case 2:	// set power
			[self tut2Init];
			break;
		case 3:	// how to shoot
			[self tut3Init];
			break;
		case 4: // scroll map
			[self tut4Init];
			break;
		case 5:
			[self tut5Init];
			break;
		case 6:
			[self tut6Init];
			break;
		case 7:
			[self tut7Init];
			break;
		case 8:
			[self tut8Init];
			break;
		case 9:
			[self tut9Init];
			break;
		case 10:
			[self tut10Init];
			break;
		case 11:
			[self tut11Init];
			break;
		case 12:
			[self tut12Init];
			break;
		default:
				break;
	}
}

-(void) tut1Init
{
	//[instructionHeader setString:@"Adjust Angle"];
	//[instructionText setString:@"Set angle to 60 degree"];
	
	[self addTutTouch:ccp(197,102)];
	
	CCSprite *arrowImg = [CCSprite spriteWithFile:@"downLeftArrow.png"];
	arrowImg.position = ccp(140,260);
	arrowImg.scale = 0.5;
	[self addChild:arrowImg];
}

-(void) tut2Init
{
	//[instructionHeader setString:@"Adjust Power"];
	//[instructionText setString:@"Set power to 90 percent"];
	
	[self addTutTouch:ccp(150,78)];
	
	CCSprite *arrowImg = [CCSprite spriteWithFile:@"downArrow.png"];
	arrowImg.position = ccp(94,142);
	arrowImg.scale = 0.5;
	[self addChild:arrowImg];
	
}

-(void) tut3Init
{
	
	//[instructionHeader setString:@"How To Shoot?"];
	//[instructionText setString:@"Set angle & power then touch on shoot"];
	
	[self addShootButtonInMenu];

	[self addTutTouch:ccp(445,160)];
}

-(void) tut4Init
{
	
}

-(void) tut5Init
{
	[self addShootButtonInMenu];
}

-(void) tut6Init
{
	
}

-(void) tut7Init
{
	
}

-(void) tut8Init
{
	
}

-(void) tut9Init
{
	
}

-(void) tut10Init
{
	
}

-(void) tut11Init
{
	
}

-(void) tut12Init
{
	
}

-(void) addShootButtonInMenu
{
	isShootPresent = TRUE;
	
	CCMenu *menu = [CCMenu menuWithItems:shootButton,nil];
	[self addChild:menu];
	
	[self schedule:@selector(animateButton:)];
}

- (void) dealloc
{
	
	NSLog(@"Inside tutorial HUD Dealloc");
	[super dealloc];
	
}


-(void) getParent {
	
	[self unschedule:@selector(getParent)];
	// get multipleLayer as a parent
	parent = (TutorialMultiLayer*)self.parent;
	
	// get the current level layer
	curLevel = [parent getLevelLayer];
	
	if (isPowerPresent == TRUE) {
		[self addPowerButton];
	}
	
}

-(void) callEveryFrame
{

	switch (gTutNumber) {
		case 1: // How to shoot
			[self tut1EveryFrame];
			break;
		case 2:	// Scrolling map
			[self tut2EveryFrame];
			break;
		case 3:	// Use next ball
			[self tut3EveryFrame];
			break;
		case 4: // collect Power
			[self tut4EveryFrame];
			break;
		case 5:
			[self tut5EveryFrame];
			break;
		case 6:
			[self tut6EveryFrame];
			break;
		case 7:
			[self tut7EveryFrame];
			break;
		case 8:
			[self tut8EveryFrame];
			break;
		case 9:
			[self tut9EveryFrame];
			break;
		case 10:
			[self tut10EveryFrame];
			break;
		case 11:
			[self tut11EveryFrame];
			break;
		case 12:
			[self tut12EveryFrame];
			break;
		default:
			break;
	}
	
	//[self unschedule:@selector(callEveryFrame)];
	//[self schedule:@selector(callEveryFrame)];
	
}

-(void) addTutTouch: (CGPoint) location
{
	touchImage.position = ccp(location.x,location.y);
	isTouchImagePresent = TRUE;
	[self addChild:touchImage];
	
	touchFinger.position = ccp(location.x,location.y);
	[self addChild:touchFinger];
}

-(void) removeTutTouch
{
	id fadeOut = [CCFadeOut actionWithDuration:0.1f];
	[touchImage runAction:fadeOut];
	
	id fadeOut2 = [CCFadeOut actionWithDuration:0.1f];
	[touchFinger runAction:fadeOut2];
}

-(void) tut1EveryFrame
{
	float curAngle = [curLevel angleOfShoot];	

	if (curAngle > 0 && isTouchImagePresent) {
		
		[self unschedule:@selector(animateTouchImage:)];
		[self removeTutTouch];
		
		
		isTouchImagePresent = FALSE;
	}
	
	if (curAngle > 60) {
		curLevel.isTutorialFinished = TRUE;
		
		[self unschedule:@selector(callEveryFrame)];
	}
}

-(void) tut2EveryFrame
{
	float curPower = [curLevel firePower];	
	curPower /= 1.1f;
	
	if (curPower > 0 && isTouchImagePresent) {
		
		[self unschedule:@selector(animateTouchImage:)];
		
		[self removeTutTouch];
		
		isTouchImagePresent = FALSE;
	}
	
	if (curPower > 71) {
		curLevel.isTutorialFinished = TRUE;
		
		[self unschedule:@selector(callEveryFrame)];
	}
}

-(void) tut3EveryFrame
{
	BOOL isBallFired = [curLevel isBallFired];
	
	if (isBallFired && isTouchImagePresent) {
		
		[self unschedule:@selector(animateTouchImage:)];
		
		[self removeTutTouch];
		
		curLevel.isTutorialFinished = TRUE;
		
		isTouchImagePresent = FALSE;
		
		[self unschedule:@selector(callEveryFrame)];
	}
}

-(void) tut4EveryFrame
{
	
}

-(void) tut5EveryFrame
{
	
}

-(void) tut6EveryFrame
{
	
}

-(void) tut7EveryFrame
{
	
}

-(void) tut8EveryFrame
{
	
}

-(void) tut9EveryFrame
{
	
}

-(void) tut10EveryFrame
{
	
}

-(void) tut11EveryFrame
{
	
}

-(void) tut12EveryFrame
{
	
}

- (void) animateTouchImage: (ccTime) delta {
	
	static float opacityCounter = 100.0f;
	static int incrementDirection = 1; // 1 means the value is increasing -1 means the value is decreasing
	int deltaScalingFactor1 = 250;
	int deltaScalingFactor2 = 150;
	
	if (opacityCounter >= 250.0f) {
		incrementDirection = -1 * deltaScalingFactor2;
	}
	if (opacityCounter <= 100.0f) {
		incrementDirection = 1 * deltaScalingFactor1;
	}
	opacityCounter += incrementDirection * delta;
	
	//NSLog(@"Opacity :  %f",opacityCounter);
	
	touchImage.opacity = opacityCounter;
	
}

-(void) addPowerButton {
	
	
	
	// initialize power used array
	for (int i=0; i<3; i++) {
		powerUsedArray[i]=FALSE;
	}
	
	gPowerButton1 = [CCMenuItemImage itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"
												  target:self
												selector:@selector(powerUsed1)];
	
	gPowerButton1.position = ccp(150,-132);
	gPowerButton1.scale = 1.5f;
	
	powerArray[0]=[CCSprite spriteWithFile:@"power1.png"];
	powerArray[0].position=ccp(150+240,-132+160);
	powerArray[0].scale=1.5f;
	
	gPowerButton2 = [CCMenuItemImage  itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"
												   target:self
												 selector:@selector(powerUsed2)];
	
	
	gPowerButton2.position = ccp(210,-132);
	gPowerButton2.scale = 1.5f;
	
	powerArray[1]=[CCSprite spriteWithFile:@"power2.png"];
	powerArray[1].position=ccp(210+240,-132+160);
	powerArray[1].scale=1.5f;
	
	
	gPowerButton3 = [CCMenuItemImage itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"
												  target:self
												selector:@selector(powerUsed3)];
	
	gPowerButton3.position = ccp(90,-132);
	gPowerButton3.scale = 1.5f;
	
	powerArray[2]=[CCSprite spriteWithFile:@"transparent_32_32.png"];
	powerArray[2].position=ccp(90+240,-132+160);
	powerArray[2].scale=1.5f;
	
	CCMenu *menu = [CCMenu menuWithItems:gPowerButton1,gPowerButton2,gPowerButton3,nil];
	
	[self addChild:powerArray[0]];
	[self addChild:powerArray[1]];
	[self addChild:powerArray[2]];
	[self addChild:menu];
	
}

-(void) powerUsed1 {
	[curLevel powerUsed];
}

-(void) powerUsed2 {
	[curLevel powerUsed2];
}

-(void) powerUsed3 {
	
	[curLevel powerUsed3];
}

- (void) animateButton: (ccTime) delta {
	
	static float opacityCounter = 100.0f;
	static int incrementDirection = 1; // 1 means the value is increasing -1 means the value is decreasing
	int deltaScalingFactor1 = 150;
	int deltaScalingFactor2 = 150;
	
	if (opacityCounter >= 170.0f) {
		incrementDirection = -1 * deltaScalingFactor2;
	}
	if (opacityCounter <= 100.0f) {
		incrementDirection = 1 * deltaScalingFactor1;
	}
	opacityCounter += incrementDirection * delta;
	
	//NSLog(@"Opacity :  %f",opacityCounter);
	
	shootButton.opacity = opacityCounter;
	
}

- (void) callShootFunction {
	
	[curLevel shootBall];
	
}

-(void) hideShootButton {
	
	id hideAction = [CCMoveTo actionWithDuration:0.1 position:ccp(240 + [shootButton boundingBox].size.width/2,0)];
	
	[shootButton runAction:hideAction];
}

- (void) showShootButton {
	
	id doNothing = [CCMoveBy actionWithDuration:1 position:CGPointZero];
	id showAction = [CCMoveTo actionWithDuration:1 position:ccp(240 - [shootButton boundingBox].size.width/2,0)];
	
	[shootButton runAction:[CCSequence actions:doNothing,showAction,nil]];
	NSLog(@"INside show shoot button");
}

-(void) showBallsLeft
{
	isTurnBallPresent = TRUE;
	
	NSString *ballSprite = [NSString stringWithFormat:@"ball_%d.png",gBallID];
	ballLeftItem = [[NSMutableArray alloc] init];
	CCMenuItemImage *ballItem[2];
	
	for (int i = 0; i < 2; i++) {
		
		ballItem[i] = [CCMenuItemImage itemFromNormalImage:ballSprite 
											 selectedImage:ballSprite
													target:self
												  selector:@selector(startNextTurn)];
		
		ballItem[i].position = ccp(-240 + 18 + i*36,-160 + 18);
		
		[ballLeftItem addObject:ballItem[i]];
	}
	
	ballTurnMenu = [CCMenu menuWithItems:ballItem[0],ballItem[1],nil];
	[self addChild:ballTurnMenu];
}

-(void) startNextTurn
{
	if(curLevel.isBallFired == TRUE)
	{
		[curLevel reAttempt];
	}
}


///////////////////////////////////////////////////
///												///
///		Following code is for touch image		///
///												///
///////////////////////////////////////////////////

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	[self displayTouchImage: touchLocation];
	
	return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	[self displayTouchImage:touchLocation];
}

-(void) displayTouchImage: (CGPoint) position
{
	CCSprite *touchAnywhereImage = [CCSprite spriteWithFile:@"redTouch.png"];
	touchAnywhereImage.position = position;
	touchAnywhereImage.scale = 0.7f;
	[self addChild:touchAnywhereImage];
	
	float animationTime = 1.0f;
	
	id scaleDownAction = [CCScaleTo actionWithDuration:animationTime scale:0.3f]; 
	id fadeOutAction = [CCFadeOut actionWithDuration:animationTime];
	[touchAnywhereImage runAction:[CCSpawn actions:fadeOutAction,scaleDownAction,nil]];	
}

///////////////////////////////////////////////////
///												///
///			End of touch image code				///
///												///
///////////////////////////////////////////////////


@end
