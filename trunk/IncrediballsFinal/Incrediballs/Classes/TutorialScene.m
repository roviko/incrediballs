//
//  TutorialScene.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/6/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "TutorialScene.h"
#import "Globals.h"
#import "TutorialMultiLayer.h"
#import "DatabaseManager.h"
#import "User.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "Tutorial.h"

@implementation TutorialScene

NSMutableArray *arrBgButtonSprite;
NSMutableArray *arrTutMenuBG;
NSMutableArray *arrTutHeading;
NSMutableArray *arrTutDescription;
NSMutableArray *arrTutScreenShot;
NSMutableArray *arrTutScreenShotButton;


int currentTutOnScreen;
int numOfTutorials;

CCMenuItemImage *tutLeftArrow;
CCMenuItemImage *tutRightArrow;
CCSprite *selectedTutListBG;

BOOL isMenuMoving;


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TutorialScene *layer = [TutorialScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		
		DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
		User *curUser = [dbInstance getCurrentUser];
		gUserId = [curUser userId];
		gUserName = [curUser userName];
		
		numOfTutorials = 12;
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *commonBG = [CCSprite spriteWithFile:@"commonBG.png"];
		commonBG.position = ccp(size.width/2,size.height/2);
		
		[self addChild:commonBG];
		
		CCSprite *backgroundImage = [CCSprite spriteWithFile:@"commonPopupBackground.png"];
		backgroundImage.position = ccp(size.width/2,size.height/2);
		
		[self addChild:backgroundImage];
		
		
		
		CCSprite *headerImage = [CCSprite spriteWithFile:@"rectWhiteButton.png"];
		headerImage.position = ccp(size.width/2,size.height/2 + 130);
		headerImage.scale = 0.5f;
		
		[self addChild:headerImage];
		
		CCLabelTTF* label=[CCLabelTTF labelWithString:@"Tutorials" fontName:@"Marker Felt" fontSize:29];
		label.position=ccp(size.width/2,size.height/2 + 130);
		label.color = ccc3(153, 0, 0);
		[self addChild:label];
		
		[self addTutMenuBG];
		[self addMapSelector];
		[self addMapSelectorSprite];
		[self addTutorialList];
		[self addTutorialButtons];
		[self setGlobleVariables];
		// aligning is important, so the menu items don’t occupy the same location 
		//[menu alignItemsVerticallyWithPadding:40];
		
		
	}
	
	return self;
}

-(void) setGlobleVariables
{
	giMapType = 1;
	gBallID = 1;
	gBallMass = 1;
	gBallElasticity = 0.85;
	gBallFriction = 0.15;
	gIsTutorialSelected = TRUE;
}

-(void) addTutMenuBG
{
	
	
	isMenuMoving = FALSE;
	
	//Getting all data from database about tutorials
	DatabaseManager *dbInstance = [[DatabaseManager alloc]init];
    NSMutableDictionary *arrTutorialContent = [dbInstance getAllTutorialInformation];
	
	// Adding highlighter for bottom list of 12 buttons
	
	selectedTutListBG = [CCSprite spriteWithFile:@"sqOrangeButton.png"];
	selectedTutListBG.position = ccp(48,20);
	selectedTutListBG.scale = 0.55f;
	
	[self addChild:selectedTutListBG];
	
	
	//adding tutorial transparent background to add menu item on it 
	
	CCSprite *tutBG1 = [CCSprite spriteWithFile:@"tutMenuBg.png"];
	tutBG1.position = ccp(240 - 480,134);
	
	CCSprite *tutBG2 = [CCSprite spriteWithFile:@"tutMenuBg.png"];
	tutBG2.position = ccp(240,134);
	
	CCSprite *tutBG3 = [CCSprite spriteWithFile:@"tutMenuBg.png"];
	tutBG3.position = ccp(240 + 480,134);
	
	arrTutMenuBG = [[NSMutableArray alloc] init];
	
	[arrTutMenuBG addObject:tutBG1];
	[arrTutMenuBG addObject:tutBG2];
	[arrTutMenuBG addObject:tutBG3];
	
	[self addChild:tutBG1];
	[self addChild:tutBG2];
	[self addChild:tutBG3];
	
	
	
	// adding menu item holder
	
	CCMenuItemImage *bgScreenShot1 = [CCMenuItemImage itemFromNormalImage:@"tutScreenShotBgWhite.png" selectedImage:@"tutScreenShotBgGreen.png" target:self selector:@selector(startTutorial:)];
	bgScreenShot1.position = ccp(85,-80);
	bgScreenShot1.userData = 0;
	//bgScreenShot1.scaleX = 0.85;
	//bgScreenShot1.scaleY = 2.25;
	
	CCMenuItemImage *bgScreenShot2 = [CCMenuItemImage itemFromNormalImage:@"tutScreenShotBgWhite.png" selectedImage:@"tutScreenShotBgGreen.png" target:self selector:@selector(startTutorial:)];
	bgScreenShot2.position = ccp(85,-80);
	bgScreenShot2.userData = 0;
	//bgScreenShot2.scaleX = 0.85;
	//bgScreenShot2.scaleY = 2.25;
	
	CCMenuItemImage *bgScreenShot3 = [CCMenuItemImage itemFromNormalImage:@"tutScreenShotBgWhite.png" selectedImage:@"tutScreenShotBgGreen.png" target:self selector:@selector(startTutorial:)];
	bgScreenShot3.position = ccp(85,-80);
	bgScreenShot3.userData = 0;
	//bgScreenShot3.scaleX = 0.85;
	//bgScreenShot3.scaleY = 2.25;

	CCMenu *menu1 = [CCMenu menuWithItems:bgScreenShot1,nil];
	CCMenu *menu2 = [CCMenu menuWithItems:bgScreenShot2,nil];
	CCMenu *menu3 = [CCMenu menuWithItems:bgScreenShot3,nil];
	
	[tutBG1 addChild:menu1];
	[tutBG2 addChild:menu2];
	[tutBG3 addChild:menu3];
	
	
	
	arrTutScreenShotButton = [[NSMutableArray alloc] init];
	
	[arrTutScreenShotButton addObject:bgScreenShot1];
	[arrTutScreenShotButton addObject:bgScreenShot2];
	[arrTutScreenShotButton addObject:bgScreenShot3];

	
	// add screen shot
	
	
	CCSprite *screenShot1 = [CCSprite spriteWithFile:@"tutScreenShot12.png"];
	screenShot1.position = ccp(325,80);
	screenShot1.scaleY = 0.7;
	screenShot1.scaleX = 0.75;
	
	CCSprite *screenShot2 = [CCSprite spriteWithFile:@"tutScreenShot1.png"];
	screenShot2.position = ccp(325,80);
	screenShot2.scaleY = 0.7;
	screenShot2.scaleX = 0.75;
	
	CCSprite *screenShot3 = [CCSprite spriteWithFile:@"tutScreenShot2.png"];
	screenShot3.position = ccp(325,80);
	screenShot3.scaleY = 0.7;
	screenShot3.scaleX = 0.75;
	
	[tutBG1 addChild:screenShot1];
	[tutBG2 addChild:screenShot2];
	[tutBG3 addChild:screenShot3];
	
	arrTutScreenShot = [[NSMutableArray alloc] init];
	
	[arrTutScreenShot addObject:screenShot1];
	[arrTutScreenShot addObject:screenShot2];
	[arrTutScreenShot addObject:screenShot3];
	
	// add tutorial header
	int fontSize = 28;
	
	Tutorial *tutData12 = (Tutorial *)[arrTutorialContent objectForKey:[NSNumber numberWithInt:12]];
	NSString *tutTitle12 = [tutData12 title];
	CCLabelTTF *tutorialHeader1 = [CCLabelTTF labelWithString:tutTitle12 fontName:@"Marker felt" fontSize:fontSize];
	tutorialHeader1.color = ccc3(153,0,0);
	tutorialHeader1.position = ccp(240,170);
	
	Tutorial *tutData1 = (Tutorial *)[arrTutorialContent objectForKey:[NSNumber numberWithInt:1]];
	NSString *tutTitle1 = [tutData1 title];
	CCLabelTTF *tutorialHeader2 = [CCLabelTTF labelWithString:tutTitle1 fontName:@"Marker felt" fontSize:fontSize];
	tutorialHeader2.color = ccc3(153,0,0);
	tutorialHeader2.position = ccp(240,170);
	
	Tutorial *tutData2 = (Tutorial *)[arrTutorialContent objectForKey:[NSNumber numberWithInt:2]];
	NSString *tutTitle2 = [tutData2 title];
	CCLabelTTF *tutorialHeader3 = [CCLabelTTF labelWithString:tutTitle2 fontName:@"Marker felt" fontSize:fontSize];
	tutorialHeader3.color = ccc3(153,0,0);
	tutorialHeader3.position = ccp(240,170);
	
	[tutBG1 addChild:tutorialHeader1];
	[tutBG2 addChild:tutorialHeader2];
	[tutBG3 addChild:tutorialHeader3];
	
	arrTutHeading = [[NSMutableArray alloc] init];
	
	[arrTutHeading addObject:tutorialHeader1];
	[arrTutHeading addObject:tutorialHeader2];
	[arrTutHeading addObject:tutorialHeader3];
	
	// add tutorial description
	fontSize = 20;
	
	
	
	NSString *tutDesc12 = [tutData12 description];
	CCLabelTTF *DescText1 = [CCLabelTTF labelWithString:tutDesc12 dimensions:CGSizeMake(170, 140) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:fontSize];
	DescText1.position = ccp(140,68);
	DescText1.color = ccc3(153, 0, 0);
	
	NSString *tutDesc1 = [tutData1 description];
	CCLabelTTF *DescText2 = [CCLabelTTF labelWithString:tutDesc1 dimensions:CGSizeMake(170, 140) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:fontSize];
	DescText2.position = ccp(140,68);
	DescText2.color = ccc3(153, 0, 0);
	
	NSString *tutDesc2 = [tutData2 description];
	CCLabelTTF *DescText3 = [CCLabelTTF labelWithString:tutDesc2 dimensions:CGSizeMake(170, 140) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:fontSize];
	DescText3.position = ccp(140,68);
	DescText3.color = ccc3(153, 0, 0);
	
	[tutBG1 addChild:DescText1];
	[tutBG2 addChild:DescText2];
	[tutBG3 addChild:DescText3];
	
	arrTutDescription = [[NSMutableArray alloc] init];
	
	[arrTutDescription addObject:DescText1];
	[arrTutDescription addObject:DescText2];
	[arrTutDescription addObject:DescText3];
}



-(void) addMapSelector
{
	int buttonID = 0; // no background is selected
	int startX = -218;
	int startY = 110;
	int imageHeight = 30;
	int imageWidth = 99;
	int spacing = 8;
	float scalingFactor = 0.9f;
	
	
	CCMenuItemImage *bgButtonCity = [CCMenuItemImage itemFromNormalImage:@"transparent_110_30.png" selectedImage:@"transparent_110_30.png" 
																  target:self 
																selector:@selector(changeBG:)];
	buttonID = 0;
	bgButtonCity.userData = (id)buttonID;
	bgButtonCity.position = ccp(startX + imageWidth/2 + spacing,startY - imageHeight/2 - spacing);
	bgButtonCity.scale = scalingFactor;
	
	CCMenuItemImage *bgButtonJungle = [CCMenuItemImage itemFromNormalImage:@"transparent_110_30.png" selectedImage:@"transparent_110_30.png" 
																	target:self 
																  selector:@selector(changeBG:)];
	buttonID = 1;
	bgButtonJungle.userData = (id)buttonID;
	bgButtonJungle.position = ccp(startX + 3 * imageWidth/2 + 2*spacing,startY - imageHeight/2 - spacing);
	bgButtonJungle.scale = scalingFactor;
	
	CCMenuItemImage *bgButtonIce = [CCMenuItemImage itemFromNormalImage:@"transparent_110_30.png" selectedImage:@"transparent_110_30.png" 
																 target:self 
															   selector:@selector(changeBG:)];
	buttonID = 2;
	bgButtonIce.userData = (id)buttonID;
	bgButtonIce.position = ccp(startX + 5 * imageWidth/2 + 3*spacing,startY - imageHeight/2 - spacing);
	bgButtonIce.scale = scalingFactor;
	
	CCMenuItemImage *bgButtonDesert = [CCMenuItemImage itemFromNormalImage:@"transparent_110_30.png" selectedImage:@"transparent_110_30.png" 
																	target:self 
																  selector:@selector(changeBG:)];
	buttonID = 3;
	bgButtonDesert.userData = (id)buttonID;
	bgButtonDesert.position = ccp(startX + 7 * imageWidth/2 + 4*spacing,startY - imageHeight/2 - spacing);
	bgButtonDesert.scale = scalingFactor;
	
	CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"close_a.png" selectedImage:@"close_b.png"
														   target:self
														 selector:@selector(backButtonTouched)];
	backButton.position = ccp(215,132);		
	
	
	CCMenu* menu = [CCMenu menuWithItems:bgButtonCity,bgButtonJungle,bgButtonIce,bgButtonDesert,backButton,nil]; 
	//menu.position = CGPointMake(size.width/2, size.height/2); 
	[self addChild:menu z:10];
	
	
}

-(void) addMapSelectorSprite
{
	
	int startX = 22;
	int startY = 270;
	int imageHeight = 30;
	int imageWidth = 99;
	int spacing = 8;
	float scalingFactor = 0.9f;
	int iFontSize = 18;
	
	arrBgButtonSprite = [[NSMutableArray alloc] init];
	
	CCSprite *bgSpriteCity = [CCSprite spriteWithFile:@"rectGreenButton_110_30.png"];
	bgSpriteCity.position = ccp(startX + imageWidth/2 + spacing,startY - imageHeight/2 - spacing);
	bgSpriteCity.scale = scalingFactor;
	CCLabelTTF *bgTextCity = [CCLabelTTF labelWithString:@"City" fontName:@"Marker Felt" fontSize:iFontSize];
	bgTextCity.position = ccp(startX + imageWidth/2 + spacing,startY - imageHeight/2 - spacing);
	
	CCSprite *bgSpriteJungle = [CCSprite spriteWithFile:@"rectOrangeButton_110_30.png"];
	bgSpriteJungle.position = ccp(startX + 3 * imageWidth/2 + 2 * spacing,startY - imageHeight/2 - spacing);
	bgSpriteJungle.scale = scalingFactor;
	CCLabelTTF *bgTextJungle = [CCLabelTTF labelWithString:@"Jungle" fontName:@"Marker Felt" fontSize:iFontSize];
	bgTextJungle.position = ccp(startX + 3 * imageWidth/2 + 2 * spacing,startY - imageHeight/2 - spacing);
	
	CCSprite *bgSpriteIce = [CCSprite spriteWithFile:@"rectOrangeButton_110_30.png"];
	bgSpriteIce.position = ccp(startX + 5 * imageWidth/2 + 3 * spacing,startY - imageHeight/2 - spacing);
	bgSpriteIce.scale = scalingFactor;
	CCLabelTTF *bgTextIce = [CCLabelTTF labelWithString:@"Ice" fontName:@"Marker Felt" fontSize:iFontSize];
	bgTextIce.position = ccp(startX + 5 * imageWidth/2 + 3 * spacing,startY - imageHeight/2 - spacing);
	
	CCSprite *bgSpriteDesert = [CCSprite spriteWithFile:@"rectOrangeButton_110_30.png"];
	bgSpriteDesert.position = ccp(startX + 7 * imageWidth/2 + 4 * spacing,startY - imageHeight/2 - spacing);
	bgSpriteDesert.scale = scalingFactor;
	CCLabelTTF *bgTextDesert = [CCLabelTTF labelWithString:@"Desert" fontName:@"Marker Felt" fontSize:iFontSize];
	bgTextDesert.position = ccp(startX + 7 * imageWidth/2 + 4 * spacing,startY - imageHeight/2 - spacing);

	[arrBgButtonSprite addObject:bgSpriteCity];
	[arrBgButtonSprite addObject:bgSpriteJungle];
	[arrBgButtonSprite addObject:bgSpriteIce];
	[arrBgButtonSprite addObject:bgSpriteDesert];
	
	[self addChild:bgSpriteCity];
	[self addChild:bgSpriteJungle];
	[self addChild:bgSpriteIce];
	[self addChild:bgSpriteDesert];
	
	[self addChild:bgTextCity];
	[self addChild:bgTextJungle];
	[self addChild:bgTextIce];
	[self addChild:bgTextDesert];
}

-(void) addTutorialList
{
	
	currentTutOnScreen = 1;
	
	
	tutLeftArrow = [CCMenuItemImage itemFromNormalImage:@"tutArrowLeft.png" selectedImage:@"tutArrowLeft.png" target:self selector:@selector(moveTutorialLeft)];
	tutLeftArrow.position = ccp(-260,-26);
	tutLeftArrow.scaleY = 0.85f;
	
	tutRightArrow = [CCMenuItemImage itemFromNormalImage:@"tutArrowRight.png" selectedImage:@"tutArrowRight.png" target:self selector:@selector(moveTutorialRight)];
	tutRightArrow.position = ccp(220,-26);
	tutRightArrow.scaleY = 0.85f;
	
	CCMenu *moveMenu = [CCMenu menuWithItems:tutLeftArrow,tutRightArrow,nil];
	[self addChild:moveMenu];
		
}

-(void) moveTutorialLeft
{
	if (isMenuMoving == FALSE) {
		
		isMenuMoving = TRUE;
		[self schedule:@selector(enableMovement) interval:0.5f];
	
		currentTutOnScreen--;
		
		selectedTutListBG.position = ccp(48 + (currentTutOnScreen - 1)*35, selectedTutListBG.position.y);
		
		if (currentTutOnScreen == 1) {
			// remove left arrow
			tutLeftArrow.position = ccp(-260,tutLeftArrow.position.y);
			//selectedTutListBG.position = ccp(selectedTutListBG.position.x + 35, selectedTutListBG.position.y);
		}
		if (currentTutOnScreen <= (numOfTutorials - 1))
		{
			// add right arrow again
			tutRightArrow.position = ccp(220,tutRightArrow.position.y);
		}
		
		for (int i = 0; i < 3; i++) {
			CCSprite *curSprite = (CCSprite*)[arrTutMenuBG objectAtIndex:i];
			
			if (curSprite.position.x >= 720) {
				//NSLog(@"Inside first condition of move tutorial right");
				curSprite.position = ccp(-240,curSprite.position.y);
			}
			else if (curSprite.position.x >= 240) {
				[curSprite runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(720,curSprite.position.y)]];
			}
			else {
				[self changeTutorialDescription:currentTutOnScreen curBGID:i];
				[curSprite runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(240,curSprite.position.y)]];
			}
		}
	}
		
}

-(void) moveTutorialRight
{
	if (isMenuMoving == FALSE) {
		
		isMenuMoving = TRUE;
		[self schedule:@selector(enableMovement) interval:0.5f];
		
		currentTutOnScreen++;
		
		selectedTutListBG.position = ccp(48 + (currentTutOnScreen - 1)*35, selectedTutListBG.position.y);
		
		if (currentTutOnScreen == numOfTutorials) {
			// remove right arrow
			tutRightArrow.position = ccp(260,tutRightArrow.position.y);
			//selectedTutListBG.position = ccp(48, selectedTutListBG.position.y);
		}
		if (currentTutOnScreen >= 2)
		{
			// add left arrow again
			tutLeftArrow.position = ccp(-220,tutLeftArrow.position.y);
		}
		
		for (int i = 0; i < 3; i++) {
			CCSprite *curSprite = (CCSprite *)[arrTutMenuBG objectAtIndex:i];
			
			if (curSprite.position.x <= -240) {
				//NSLog(@"Inside first condition of move tutorial right");
				curSprite.position = ccp(720,curSprite.position.y);
			}
			else if (curSprite.position.x <= 240) {
				[curSprite runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(-240,curSprite.position.y)]];
			}
			else {
				[self changeTutorialDescription:currentTutOnScreen curBGID:i];
				[curSprite runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(240,curSprite.position.y)]];
			}

		}
	}
}

-(void) changeTutorialDescription:(int)tutID curBGID:(int)curbgID
{
	//NSLog(@"tutID : %d bgID : %d",tutID,bgID);
	
	int prevbgID = curbgID - 1;
	int nextbgID = curbgID + 1;
	int prevtutID = tutID - 1;
	int nexttutID = tutID + 1;
	
	if (prevbgID == -1) {
		prevbgID = 2;
	}
	if (nextbgID == 3) {
		nextbgID = 0;
	}
	if (prevtutID == 0) {
		prevtutID = 12;
	}
	if (nexttutID == 13) {
		nexttutID = 1;
	}
	
	//NSLog(@" :%d :%d ",prevtutID,nexttutID);
	
	DatabaseManager *dbInstance = [[DatabaseManager alloc]init];
	NSMutableDictionary *arrTutContent = [dbInstance getAllTutorialInformation];
	
	id prevKey = [NSNumber numberWithInt:prevtutID];
	id curKey = [NSNumber numberWithInt:tutID];
	id nextKey = [NSNumber numberWithInt:nexttutID];
	
	//NSLog(@"Works till here.....");
	
	Tutorial *prevTutData = (Tutorial *)[arrTutContent objectForKey:prevKey];
	Tutorial *curTutData = (Tutorial *)[arrTutContent objectForKey:curKey];
	Tutorial *nextTutData = (Tutorial *)[arrTutContent objectForKey:nextKey];
	
	//NSLog(@"WOrks fine till here");
	
	NSString *prevTutTitle = [prevTutData title];
	CCLabelTTF *prevTitleLabel = (CCLabelTTF *)[arrTutHeading objectAtIndex:prevbgID];
	[prevTitleLabel setString:prevTutTitle];
	
	NSString *prevTutDesc = [prevTutData description];
	CCLabelTTF *prevDescLabel = (CCLabelTTF *)[arrTutDescription objectAtIndex:prevbgID];
	[prevDescLabel setString:prevTutDesc];
	
	NSString *curTutTitle = [curTutData title];
	CCLabelTTF *curTitleLabel = (CCLabelTTF *)[arrTutHeading objectAtIndex:curbgID];
	[curTitleLabel setString:curTutTitle];
	
	NSString *curTutDesc = [curTutData description];
	CCLabelTTF *curDescLabel = (CCLabelTTF *)[arrTutDescription objectAtIndex:curbgID];
	[curDescLabel setString:curTutDesc];

	NSString *nextTutTitle = [nextTutData title];
	CCLabelTTF *nextTitleLabel = (CCLabelTTF *)[arrTutHeading objectAtIndex:nextbgID];
	[nextTitleLabel setString:nextTutTitle];
	
	NSString *nextTutDesc = [nextTutData description];
	CCLabelTTF *nextDescLabel = (CCLabelTTF *)[arrTutDescription objectAtIndex:nextbgID];
	[nextDescLabel setString:nextTutDesc];
}

-(void) enableMovement
{
	isMenuMoving = FALSE;
	[self unschedule:@selector(enableMovement)];
}

-(void) addTutorialButtons
{
	int iFontSize = 20;
	int startX = -192;
	int startY = -140;
	int xDist = 35;
	float imgScale = 0.4;
	
	NSString *whiteImage = @"sqWhiteButton.png";
	NSString *greenImage = @"sqGreenButton.png";
	NSString *orangeImage = @"sqOrangeButton.png";
	NSString *normalImage = whiteImage;
	NSString *selectedImage = greenImage;
	
	DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
	NSMutableDictionary *playedTutorials = [dbInstance getPlayedTutorials];
	
	CCMenu *menu = [CCMenu menuWithItems:nil];
	
	for (int i = 0; i < numOfTutorials; i++) {

		Tutorial *curTutorial = (Tutorial *)[playedTutorials objectForKey:[NSNumber numberWithInt:(i+1)]];
		
		normalImage = whiteImage;
		selectedImage = greenImage;
		
		if(curTutorial != nil)
		{
			normalImage = greenImage;
			selectedImage = orangeImage;
		}
		
		CCLabelTTF *tutorialText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",(i+1)] fontName:@"Marker Felt" fontSize:iFontSize];
		CCMenuItemLabel *tutorialLabel = [CCMenuItemLabel itemWithLabel:tutorialText target:self selector:@selector(displayTutorial:)];
		tutorialLabel.position = ccp(startX + i * xDist, startY - 2);
		tutorialLabel.color = ccc3(153, 0, 0);
		tutorialLabel.userData = (id)(i + 1);
		
		CCMenuItemImage *tutImg = [CCMenuItemImage itemFromNormalImage:normalImage selectedImage:selectedImage target:self selector:@selector(displayTutorial:)];
		tutImg.position = ccp(startX + i * xDist, startY);
		tutImg.scale = imgScale;
		tutImg.userData = (id)(i + 1);
	
		[menu addChild:tutImg];
		[menu addChild:tutorialLabel];
	}
	
	[self addChild:menu];
	
}

-(void) displayTutorial: (id) sender
{
	int clickButtonID  = (int)[sender userData];
	
	NSLog(@"Current ID : %d",clickButtonID);
	
	if (clickButtonID < currentTutOnScreen) {
		
		currentTutOnScreen = clickButtonID + 1;
		NSLog(@"Tut ID : %d",currentTutOnScreen);
		[self moveTutorialLeft];
	}
	else if (clickButtonID > currentTutOnScreen)
	{
		currentTutOnScreen = clickButtonID - 1;
		NSLog(@"Tut ID : %d",currentTutOnScreen);
		[self moveTutorialRight];
	}
}

-(void) startTutorial: (id) sender
{
	int clickButtonID = (int)[sender userData];
	if(clickButtonID == 0)
	{
		gTutNumber = currentTutOnScreen;
	}
	else {
		gTutNumber = clickButtonID;
	}
	
	if (gTutNumber > 3) {
		gTutNumber = 3;
	}
	
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[[CCDirector sharedDirector] replaceScene:[TutorialMultiLayer node]];

}

-(void) changeBG: (id) sender
{
	int clickedButtonID = (int)[sender userData];
	
	//gTutBGSelected = clickedButtonID;
	giMapType = clickedButtonID + 1;
	
	for (int i = 0; i < 4; i++) {
	
		CCSprite *ButtonSprite = (CCSprite *)[arrBgButtonSprite objectAtIndex:i];
		
		if (i == clickedButtonID) {
		
			[ButtonSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"rectGreenButton_110_30.png"]];
		}
		else {
			[ButtonSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"rectOrangeButton_110_30.png"]];
		}
	}
	
}

-(void) backButtonTouched{
	[[CCDirector sharedDirector] popScene];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
