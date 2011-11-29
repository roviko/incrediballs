//
//  BallInventoryScene.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/23/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "BallInventoryScene.h"
#import "game_map.h"
#import "MultipleLayer.h"
#import "BallSelector.h"
#import "Globals.h"
#import "AlertPopup.h"
#import "User.h"
#import "Ball.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "Power.h"
#import "Globals.h"

BallSelector *ballButton[8];
float arrBallPosition[8][3]; //stores three values 0: x , 1 : y and 2: scale
int mappingBetweenBallandPosition[8]; // index = position and value at index = ball number(ID) 

//variables for scrolling ball menu
float touchStartTime;
float touchEndTime;
float touchStartX;
float touchEndX;
float timeDiff;
CGPoint prevTouchLocation;
id moveAction[8];
id scaleAction[8];
CCMenuItemImage *playBuyButton;
CCLabelTTF *playBuyName;

// variables for display description
CCLabelTTF *lBallName;
CCLabelTTF *lMass;
CCLabelTTF *lFriction;
CCLabelTTF *lElasticity;

// power related variables
CCSprite *powerSprite1;
CCSprite *powerSprite2;
CCLabelTTF *powerName1;
CCLabelTTF *powerName2;
CCLabelTTF *powerDesc1;
CCLabelTTF *powerDesc2;


//user related variable
int userSelectionStatus; // 0 for play game, 1 for new ball bought and 2 for ball can't be bought


@implementation BallInventoryScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BallInventoryScene *layer = [BallInventoryScene node];
	
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
		
		NSLog(@"Ball menu created");
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *commonBG = [CCSprite spriteWithFile:@"commonBG.png"];
		commonBG.position = ccp(size.width/2,size.height/2);
		
		[self addChild:commonBG];
		
		CCSprite *backgroundImage = [CCSprite spriteWithFile:@"commonPopupBackground.png"];
		backgroundImage.position = ccp(size.width/2,size.height/2);
		
		[self addChild:backgroundImage];
		
		CCSprite *ballDescBg1 = [CCSprite spriteWithFile:@"ballDesc1.png"];
		ballDescBg1.position = ccp(116,218);
		ballDescBg1.scaleY = 0.9f;
		//ballDescBg1.color =ccc3(153, 0, 0);
		
		CCSprite *ballDescBg2 = [CCSprite spriteWithFile:@"ballDesc2.png"];
		ballDescBg2.position = ccp(240,87);
		ballDescBg2.scaleY = 0.9f;
		//ballDescBg2.scaleX = 0.9f;
		
		CCSprite *ballBg = [CCSprite spriteWithFile:@"ballDesc1.png"];
		ballBg.position = ccp(334,218);
		ballBg.scaleX = 1.32f;
		ballBg.scaleY = 0.9f;
		
		[self addChild:ballDescBg1];
		[self addChild:ballDescBg2];
		[self addChild:ballBg];
		// code for displaying data about ball
		
		[self setBallDescriptionLayOut];
		
		
		
		// backbutton menu item
	
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"close_a.png" selectedImage:@"close_b.png"
																	target:self
																  selector:@selector(goBack)];
		backButton.position = ccp(215,132);
		
		
		playBuyButton = [CCMenuItemImage itemFromNormalImage:@"playBuyButton.png" selectedImage:@"playBuyButton.png" 
													  target:self
													selector:@selector(setSelectedBallVariables)];
		
		playBuyButton.position = ccp(140,45);
		
		/*
		CCMenuItemImage *playButton = [CCMenuItemImage itemFromNormalImage:@"next.png" selectedImage:@"next.png"
																	target:self
																  selector:@selector(playGame)];
		
		playButton.position = ccp(200,-120);
		
		 */
		CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
		
		
		
		[self addChild:menu];
	
		[self setGlobalVariables];
		
		[self createBallMenu];
		
		[self schedule:@selector(step:)];
	}
	return self;
}

-(void) setGlobalVariables
{
	touchStartTime = 0;
	touchEndTime = 0;
	touchStartX = 0;
	touchEndX = 0;
	timeDiff = 0;
	prevTouchLocation = CGPointZero;
	//DatabaseInstance = NULL;
	
	NSLog(@"Inside Set global variable");
}

-(void)onEnter
{
    // Call the super enter function
    [super onEnter];
    
    // Initialize the iAD manager
    addView = [[iAdManager alloc] initWithIAD:isAppBougth];
    
    // Add it to the view
    [self addChild:addView];
    
}


-(void) onExit
{
    // Remove the add view
    [addView.addView removeFromSuperview];
    
    // Release the view
    [addView release];
    
    // Set the view to nil
    addView.addView = nil;
    
    // Call the super method
    [super onExit];
}

-(void) setBallDescriptionLayOut
{
	// display user information
	int top = 282;
	int left = 25;
	
	DatabaseManager* dbManagerInstance = [[DatabaseManager alloc] init];
	
	//User *currUser = [dbManagerInstance getCurrentUser];
	NSString *userName = gUserName;//[currUser userName];
	CCLabelTTF *userNameLabel = [CCLabelTTF labelWithString:userName fontName:@"Marker Felt" fontSize:26];
	userNameLabel.position = ccp(left + 90,top - 22);
	userNameLabel.color = ccc3(153.0f, 0.0f, 0.0f);
	
	int userScore = gUserHighScore;//[currUser userScore];
	CCLabelTTF *userScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$ %d",userScore] fontName:@"Marker Felt" fontSize:20];
	userScoreLabel.position = ccp(left + 90,top - 52);
	userScoreLabel.color = ccc3(153.0f, 0.0f, 0.0f);
	
	
	
	playBuyName = [CCLabelTTF labelWithString:@"PLAY" fontName:@"American Typewriter" fontSize:30];
	playBuyName.position = ccp(left + 90, top - 92);
	playBuyName.color = ccc3(255.0f, 255.0f, 255.0f);
	
	playBuyButton = [CCMenuItemImage itemFromNormalImage:@"playBuyButton.png" selectedImage:@"playBuyButton.png" 
												  target:self
												selector:@selector(setSelectedBallVariables)];
	
	playBuyButton.position = ccp(left - 150,top - 252);
	
	CCMenu *playBuyButtonMenu = [CCMenu menuWithItems:playBuyButton,nil];
	
	[self addChild:playBuyButtonMenu];
	[self addChild:userNameLabel];
	[self addChild:userScoreLabel];
	[self addChild:playBuyName];
	
	
	
	// display ball informations
	top = 145;
	left = 8;
	
	lBallName = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:26];
	lBallName.position = ccp(left + 162,top - 20);
	lBallName.color = ccc3(153.0f, 0.0f, 0.0f);
	
	CCLabelTTF *massLabel = [CCLabelTTF labelWithString:@"Mass :" fontName:@"Marker Felt" fontSize:14];
	massLabel.position = ccp(left + 345, top - 8);
	massLabel.color = ccc3(153.0f, 0.0f, 0.0f);
	
	
	CCLabelTTF *frictionLabel = [CCLabelTTF labelWithString:@"Friction :" fontName:@"Marker Felt" fontSize:14];
	frictionLabel.position = ccp(left + 345, top - 22);
	frictionLabel.color = ccc3(153.0f, 0.0f, 0.0f);	
	
	CCLabelTTF *elasticityLabel = [CCLabelTTF labelWithString:@"Elasticity :" fontName:@"Marker Felt" fontSize:14];
	elasticityLabel.position = ccp(left + 345, top - 36);
	elasticityLabel.color = ccc3(153.0f, 0.0f, 0.0f);
	
	
	lMass = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:14];
	lMass.position = ccp(left + 405,top - 8);
	lMass.color = ccc3(153.0f, 0.0f, 0.0f);
	
	lFriction = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:14];
	lFriction.position = ccp(left + 405,top - 22);
	lFriction.color = ccc3(153.0f, 0.0f, 0.0f);
	
	lElasticity = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:14];
	lElasticity.position = ccp(left + 405,top - 36);
	lElasticity.color = ccc3(153.0f, 0.0f, 0.0f);
	
	
	// display power details
	
	//currently I am displaying the power of first ball in the list hence passed 1 as ID but ideally the last ball used by the user should come here
	Ball *ballInstance = [dbManagerInstance getBallWithId:[NSNumber numberWithInt:1]];
	NSArray *powerArr = ballInstance.powers;
	Power *objPower1 = (Power *)[powerArr objectAtIndex:0];
	Power *objPower2 = (Power *)[powerArr objectAtIndex:1];
	
	int powerId1 = [objPower1 powerId];
	int powerId2 = [objPower2 powerId];
	
	powerSprite1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"power%d.png",powerId1]];
	powerSprite2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"power%d.png",powerId2]];
	
	powerSprite1.scale = 0.85;
	powerSprite2.scale = 0.85;
	
	powerSprite1.position = ccp(left + 40, top - 65);
	powerSprite2.position = ccp(left + 260, top - 65);
	
	powerName1 = [CCLabelTTF labelWithString:[objPower1 powerName] dimensions:CGSizeMake(170.0f, 30.0f) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:21];
	powerName1.position = ccp(left + 150, top - 68);
	powerName1.color = ccc3(153.0f, 0.0f, 0.0f);
	
	powerName2 = [CCLabelTTF labelWithString:[objPower2 powerName] dimensions:CGSizeMake(170.0f, 30.0f) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:21];
	powerName2.position = ccp(left + 370, top - 68);
	powerName2.color = ccc3(153.0f, 0.0f, 0.0f);
	
	powerDesc1 = [CCLabelTTF labelWithString:[objPower1 powerDescription] dimensions:CGSizeMake(200.0f, 70.0f) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:14];
	powerDesc1.position = ccp(left + 130, top - 115);
	powerDesc1.color = ccc3(153.0f,0.0f,0.0f);
	
	powerDesc2 = [CCLabelTTF labelWithString:[objPower2 powerDescription] dimensions:CGSizeMake(200.0f, 70.0f) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:14];
	powerDesc2.position = ccp(left + 350, top - 115);
	powerDesc2.color = ccc3(153.0f,0.0f,0.0f);
	
	[self addChild:lBallName];
	[self addChild:massLabel];
	[self addChild:frictionLabel];
	[self addChild:elasticityLabel];
	[self addChild:lMass];
	[self addChild:lFriction];
	[self addChild:lElasticity];
	[self addChild:powerSprite1];
	[self addChild:powerSprite2];
	[self addChild:powerName1];
	[self addChild:powerName2];
	[self addChild:powerDesc1];
	[self addChild:powerDesc2];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	//[DatabaseInstance dealloc];
	NSLog(@"Inside ball menu dealloc");
	
	[super dealloc];
}

-(void) goBack
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1 scene:[game_map node]]];
}

-(void) playGame
{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1 scene:[MultipleLayer node]]];
}

-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	int deltaScalingFactor = 50000;
	float speedFactor = 0.01f;
	
	if ((touchEndX - touchStartX) < 0 && timeDiff < 0) {
		
		int diffToBeAdded = dt * deltaScalingFactor;
		CGPoint curLocation = ccp(prevTouchLocation.x,160);
		
		if (timeDiff + diffToBeAdded > 0) {
			timeDiff = 0;
			
			// call function to adjust the position here
			[self adjustBallPosition:-1];
		}
		else {
			timeDiff += diffToBeAdded;
			curLocation.x += speedFactor * timeDiff;
			
			// call scrolling menu function
			//[self scrollMenuWithTouch:curLocation];
		}
		
		//NSLog(@"step works!!!");
		
	}
	if ((touchEndX - touchStartX) > 0 && timeDiff > 0) {
		
		int diffToBeSubtracted = dt * deltaScalingFactor;
		CGPoint curLocation = ccp(prevTouchLocation.x,160);
		
		if (timeDiff - diffToBeSubtracted < 0) {
			timeDiff = 0;
			
			// call function to adjust the position here
			[self adjustBallPosition:1];
		}
		else {
			timeDiff -= diffToBeSubtracted;
			curLocation.x += speedFactor * timeDiff;
			
			
			// call scrolling menu function
			//[self scrollMenuWithTouch:curLocation];
		}
	}
	
}

-(void) createBallMenu
{
	//NSMutableString *menuList = [NSMutableString stringWithString:@""];
	
	for (int i = 0; i < numMenuBalls; i++) {
		
		ballButton[i] = [BallSelector spriteWithFile:[NSString stringWithFormat:@"ball_%d.png",i+1]];
		
		// ball ID is used to display ball in level builder
		ballButton[i].iBallID = i + 1;
		
		[self addChild:ballButton[i]];
		//[menuList appendFormat:@"ballButton[%d],",i];
	}
	
	//[menuList appendFormat:@"nil"];
	
	//NSLog(menuList);
	
	
	//set ball position
	[self addBallMenuPosition];
	
	NSLog(@"before assign value");
	
	//set all class variable for different ball, this function distinguish between different balls
	[self assignValues];

	NSLog(@"after assign value");
	
	//CCMenu *ballMenu = [CCMenu menuWithItems:ballButton[0],ballButton[1],ballButton[2],ballButton[3],ballButton[4],ballButton[5],ballButton[6],ballButton[7],nil];
	//CCMenu *ballMenu = [CCMenu menuWithItems:menuList];


	//[self addChild:ballMenu];
}


// This function is main function of the class as here are the global variables are being set, which are then used in different levels
-(void) setSelectedBallVariables
{
	int currBallId = mappingBetweenBallandPosition[0];
	
	// if ball has already been purchased
	gBallID = ballButton[currBallId].iBallID;
	gBallMass = ballButton[currBallId].fMass;
	gBallElasticity = ballButton[currBallId].fElasticity;
	gBallFriction = ballButton[currBallId].fFriction;
	gBallPower1 = ballButton[currBallId].iPower1;
	gBallPower2 = ballButton[currBallId].iPower2;
	
	
	//if ( == TRUE) {
				
		[self startGameAlert:currBallId isBuyRequest:!ballButton[currBallId].isUnlocked];
	
//	}
//	else {
//		// here logic will come to alert user that ball is not bought and also option for them to buy ball
//		[self startGameAlert:currBallId isBuyRequest:TRUE];
//	}

}

//// Following code is a try for alert

-(void)startGameAlert:(int)ballId isBuyRequest:(BOOL)buy {
	
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	
	if (buy == FALSE) {
	
		[dialog setTitle:@"Ball Selected !!"];
		[dialog setMessage:@"Do you want to play with this ball?"];
		[dialog addButtonWithTitle:@"Play"];
		[dialog addButtonWithTitle:@"Change"];
		userSelectionStatus = 0;
	
	}
	else {
		DatabaseManager* dbManagerInstance = [[DatabaseManager alloc] init];
		
		User *currUser = [dbManagerInstance getCurrentUser];
		
		if (ballButton[ballId].iBallPrice <= [currUser userScore]) {
			
			[dialog setTitle:@"Ball Selected !!"];
			[dialog setMessage:@"Do you want to buy this ball?"];
			[dialog addButtonWithTitle:@"Buy"];
			[dialog addButtonWithTitle:@"Cancel"];
			userSelectionStatus = 1;
		}
		else {
			NSLog(@"Check point 2");
			[dialog setTitle:@"Sorry !!!"];
			[dialog setMessage:@"You don't have enough money to buy this ball."];
			[dialog addButtonWithTitle:@"Ok"];
			userSelectionStatus = 2;
		}

	}

	
	//[dialog setBackgroundColor:[UIColor whiteColor]];
	//[dialog setAlpha:200.0f];
	
	//myTextField = [[UITextField alloc] init];
//	[myTextField setDelegate:self];
//	[myTextField setFrame:CGRectMake(12.0f, 45.0f, 260.0f, 25.0f)];
//	[myTextField setClearsOnBeginEditing:TRUE];
//	[myTextField setBackgroundColor:[UIColor whiteColor]];
//	[myTextField setHighlighted:TRUE];
//	[myTextField setSelected:TRUE];
//	[myTextField setText:@"Enter Name"]; 
//	
	
	[dialog show];
	[dialog release];

	
	/*
	int buttonIndex = [myPopup getAlertResponse];
	if(buttonIndex == 0) {
		[self playGame];
	}*/

}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0) {
		
		if (userSelectionStatus == 0) {
		
			[self playGame];
			
		}
		else if (userSelectionStatus == 1){
		
			// ball bought so money deduction and database update code should go here
			int currBallId = mappingBetweenBallandPosition[0];
			NSLog(@"ball iD = %d",currBallId);
			
			ballButton[currBallId].isUnlocked = TRUE;
			
			DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
			gUserHighScore = [dbInstance buyBall:(currBallId + 1) price:[ballButton[currBallId] iBallPrice] userScore:gUserHighScore];
			
			NSLog(@"ball iD = %d",currBallId);
			
			[self playGame];
		}
	}

}
 

///// try ends

-(void) addBallMenuPosition
{
	int startPointX = 335;
	int startPointY = 210;
	
	arrBallPosition[0][0] = startPointX + 0;
	arrBallPosition[0][1] = startPointY + -20;
	arrBallPosition[0][2] = 2.0f;
	
	arrBallPosition[1][0] = startPointX + 80;
	arrBallPosition[1][1] = startPointY + -10;
	arrBallPosition[1][2] = 1.5f;
	
	arrBallPosition[2][0] = startPointX + 100;
	arrBallPosition[2][1] = startPointY + 22;
	arrBallPosition[2][2] = 1.0f;
	
	arrBallPosition[3][0] = startPointX + 70;
	arrBallPosition[3][1] = startPointY + 40;
	arrBallPosition[3][2] = 0.8f;
	
	arrBallPosition[4][0] = startPointX + 0;
	arrBallPosition[4][1] = startPointY + 50;
	arrBallPosition[4][2] = 0.5f;
	
	arrBallPosition[5][0] = startPointX + -70;
	arrBallPosition[5][1] = startPointY + 40;
	arrBallPosition[5][2] = 0.8f;
	
	arrBallPosition[6][0] = startPointX + -100;
	arrBallPosition[6][1] = startPointY + 22;
	arrBallPosition[6][2] = 1.0f;
	
	arrBallPosition[7][0] = startPointX + -80;
	arrBallPosition[7][1] = startPointY + -10;
	arrBallPosition[7][2] = 1.5f;
	
	for (int i = 0; i < numMenuBalls; i++) {
		mappingBetweenBallandPosition[i] = i;
		ballButton[i].position = ccp(arrBallPosition[i][0],arrBallPosition[i][1]);
		ballButton[i].scale = arrBallPosition[i][2];
	}
	
}

-(void) assignValues
{
	// assign value for each ball separately
	
	//DatabaseInstance = gDbManager;//[DatabaseManager getInstance];
	DatabaseManager* dbManagerInstance = [[DatabaseManager alloc] init];
	NSLog(@"Instance successfully created");
	
	// currently all the balls are having same value but they should assigned separately inside this function only
	for (int i = 0; i < numMenuBalls; i++) {

		Ball *ballInstance = [dbManagerInstance getBallWithId:[NSNumber numberWithInt:i + 1]]; // ball id are saved from 1 to 8 not 0 to 7
		NSLog(@"Ball %d : Mass %f, Elasticity %f, Friction %f",i + 1,ballInstance.mass,ballInstance.elasticity,ballInstance.friction);
		
		ballButton[i].isUnlocked = ballInstance.isBallUnlocked;
		ballButton[i].fMass = ballInstance.mass;
		ballButton[i].fElasticity = ballInstance.elasticity;
		ballButton[i].fFriction = ballInstance.friction;
		ballButton[i].iBallPrice = (int)ballInstance.ballPrice;
		
		
		NSArray *powerArr = ballInstance.powers;
		Power *objPower1 = (Power *)[powerArr objectAtIndex:0];
		Power *objPower2 = (Power *)[powerArr objectAtIndex:1];
		
		ballButton[i].iPower1 = [objPower1 powerId];
		ballButton[i].iPower2 = [objPower2 powerId];
		
		gBallPower1 = [objPower1 powerId];
		gBallPower2 = [objPower2 powerId];
		
		// also add lock image on balls which are locked
		if (ballButton[i].isUnlocked == FALSE) {
			CCSprite *lock = [CCSprite spriteWithFile:@"ball_locked.png"];
			lock.position = ccp(16,16); // basically half of ball width and height
			[ballButton[i] addChild:lock];
		}
	}
	
	// Assign default values to global variables
	
	gBallID = ballButton[0].iBallID;
	gBallMass = ballButton[0].fMass;
	gBallElasticity = ballButton[0].fElasticity;
	gBallFriction = ballButton[0].fFriction;
	gBallPower1 = 1;
	gBallPower2 = 2;
	//[self setSelectedBallVariables:];
	
	//Call display function for default ball
	[self displayDescription:1];
	
}

-(void) displayDescription: (int) iBallId
{

	DatabaseManager* dbManagerInstance = [[DatabaseManager alloc] init];
	Ball *ballInstance = [dbManagerInstance getBallWithId:[NSNumber numberWithInt:iBallId]];
	
	NSString *ballName = ballInstance.ballName;
	int ballMass = (int)ballInstance.mass;
	int ballFriction = (int)(ballInstance.friction * 100);
	int ballElasticity = (int)(ballInstance.elasticity * 100);
	int ballPrice = (int)(ballInstance.ballPrice);
	//Power *arrPower = (Power *)ballInstance.powers;
	
	//[arrPower obje].powerName
	
	[lBallName setString:ballName];
	[lMass setString:[NSString stringWithFormat:@"%d",ballMass]];
	[lFriction setString:[NSString stringWithFormat:@"%d%%",ballFriction]];
	[lElasticity setString:[NSString stringWithFormat:@"%d%%",ballElasticity]];
	
	NSArray *powerArr = ballInstance.powers;
	Power *objPower1 = (Power *)[powerArr objectAtIndex:0];
	Power *objPower2 = (Power *)[powerArr objectAtIndex:1];
	
	int powerId1 = [objPower1 powerId];
	int powerId2 = [objPower2 powerId];
	
	[powerSprite1 setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d.png",powerId1]]];
	[powerSprite2 setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d.png",powerId2]]];
	
	[powerName1 setString:[objPower1 powerName]];
	[powerName2 setString:[objPower2 powerName]];
	[powerDesc1 setString:[objPower1 powerDescription]];
	[powerDesc2 setString:[objPower2 powerDescription]];
	
	if (ballButton[iBallId - 1].isUnlocked == TRUE) {
		[playBuyName setString:@"PLAY"];
	}
	else {
		[playBuyName setString:[NSString stringWithFormat:@"$ %d",ballPrice]];
	}
}

// Following function is very important as it over writes the parent touch function
-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	//NSLog(@"Touch begin");
	
	// tracking the current time when touch begin
	touchStartTime = [event timestamp];
	touchStartX = touchLocation.x;
	
	//setting the start of the touch location
	prevTouchLocation = touchLocation;
	
	return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint curLocation = [touch locationInView: [touch view]];
	curLocation = [[CCDirector sharedDirector] convertToGL:curLocation];
	
	
	//NSLog(@"Touch moving");
	
	// call scroll function with current location
	[self scrollMenuWithTouch:curLocation];
	
	prevTouchLocation = curLocation;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	// tracking the timestamp when touch ended 
	touchEndTime = [event timestamp];
	touchEndX = touchLocation.x;
	prevTouchLocation = touchLocation;
	
	timeDiff = (touchEndX - touchStartX)/(touchEndTime - touchStartTime);
}

-(void)scrollMenuWithTouch : (CGPoint)touchLocation
{
	float changeX = touchLocation.x - prevTouchLocation.x;
	int curPosX = ballButton[mappingBetweenBallandPosition[0]].position.x;
	int nextBallDirection = 1; // moving right
	
	if (changeX < 0) {
		nextBallDirection = -1; // moving left
	}
	
	// get the position difference for ball at 0th position as it will move by the exact distance as diff, this values will be used to scale other position down
	
	int xDiff0 = arrBallPosition[0][0] - arrBallPosition[(nextBallDirection + numMenuBalls) % (numMenuBalls)][0];
	

	// see if direction has changed
	/*
	if (nextBallDirection > 0) {
		
		if (curPosX < arrBallPosition[0][0]) {
			// change index - decrement
			
			for (int i = 0 ; i < numMenuBalls; i++) {
				mappingBetweenBallandPosition[i] = (mappingBetweenBallandPosition[i] - 1 + numMenuBalls) % numMenuBalls;
			}
			
		}
	}
	else {
		if (curPosX > arrBallPosition[0][0]) {
			/// change index - increment
			
			for (int i = 0 ; i < numMenuBalls; i++) {
				mappingBetweenBallandPosition[i] = (mappingBetweenBallandPosition[i] + 1 + numMenuBalls) % numMenuBalls;
			}
		}
	}
	 */
	
	
	//check if ball positions are inter changed
	
	int newPosX = curPosX + changeX;
	
	if (changeX < 0) {
		if (newPosX <= arrBallPosition[numMenuBalls - 1][0]) {
			
			//rotate left
			
			[self adjustBallPosition:-1];
			/*
			for (int i = 0; i < numMenuBalls; i++) {
				mappingBetweenBallandPosition[i] = (mappingBetweenBallandPosition[i] + 1 + numMenuBalls) % (numMenuBalls);
			
			}*/
			
		}
	}
	else {
		if (newPosX >= arrBallPosition[1][0]) {
			//rotate right
			
			[self adjustBallPosition:1];

		}
	}
	
	
	// now for all balls take its difference with its next position and scale it down and move the ball with scaling
	
	for (int i = 0; i < numMenuBalls; i++) {
		int ballIndex = mappingBetweenBallandPosition[i];
		int xDiff = arrBallPosition[i][0] - arrBallPosition[(i + nextBallDirection + numMenuBalls) % (numMenuBalls)][0];
		int yDiff = arrBallPosition[i][1] - arrBallPosition[(i + nextBallDirection + numMenuBalls) % (numMenuBalls)][1];
		float scaleDiff = arrBallPosition[i][2] - arrBallPosition[(i + nextBallDirection + numMenuBalls) % (numMenuBalls)][2];
		
		// scaling factor is used to scale down the move in x direction 
		float scalingFactor = xDiff / (float)xDiff0;
		
		//
		float changeY = (yDiff/ (float)xDiff)*changeX*scalingFactor;
		float changeScale = (scaleDiff/ (float)xDiff)*changeX*scalingFactor;
		
		if (ballButton[ballIndex].scale + changeScale < 0.5f) {
			break;
		}
		ballButton[ballIndex].scale += changeScale;
		
		
		ballButton[ballIndex].position = ccp(ballButton[ballIndex].position.x + scalingFactor * changeX,ballButton[ballIndex].position.y + changeY);
		
		
		//NSLog(@"xdiff = %d, y diff = %d",xDiff,yDiff);
		
	}
}


-(void)scrollMenuAfterTouch : (CGPoint)touchLocation
{
	float diff = touchLocation.x - prevTouchLocation.x;
	NSLog(@"Speed = %f",diff);
}

-(void) adjustBallPosition: (int) direction{

	int xDiff0 = ballButton[mappingBetweenBallandPosition[0]].position.x - arrBallPosition[0][0];
	int xMaxDiff = arrBallPosition[0][0] - arrBallPosition[1][0];
	
	float scaleFactor = xDiff0 / (float)xMaxDiff;
	
	if (scaleFactor < 0) {
		scaleFactor = - scaleFactor;
	}
	
	float actionTime = 1 * scaleFactor;
	
	if (scaleFactor > 0.4) {

		actionTime = 1 * (1 - scaleFactor);
		
		for (int i = 0; i < numMenuBalls; i++) {
			mappingBetweenBallandPosition[i] = (mappingBetweenBallandPosition[i] - direction + numMenuBalls) % numMenuBalls;
		}
	}
	
	for (int i = 0; i < numMenuBalls; i++) {
		
		int ballIndex = mappingBetweenBallandPosition[i];
	
		moveAction[i] = [CCMoveTo actionWithDuration:actionTime position:ccp(arrBallPosition[i][0],arrBallPosition[i][1])];
		scaleAction[i] = [CCScaleTo actionWithDuration:actionTime scale:arrBallPosition[i][2]];
		
		[ballButton[ballIndex] runAction:[CCSpawn actions:moveAction[i],scaleAction[i],nil]];
		
		
		//ballButton[ballIndex].position = ccp(arrBallPosition[i][0],arrBallPosition[i][1]);
		//ballButton[ballIndex].scale = arrBallPosition[i][2];
	}
	
	[self displayDescription:mappingBetweenBallandPosition[0] + 1];
	
}

@end
