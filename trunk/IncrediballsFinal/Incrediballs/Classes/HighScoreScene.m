//
//  HighScoreScene.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/6/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "HighScoreScene.h"
#import "Globals.h"
#import "HighScoreMenu.h"
#import "HighScore.h"

@implementation HighScoreScene

const float accordianAnimationTime = 1;

HighScoreMenu *highScoreMenuItem[5];
NSMutableArray *arrBgButtonSprite;
CCMenuItemImage *wholeLevelMenu;
CCSprite *highScoreBGImage;
NSMutableDictionary *highScoreInfo;
CCLabelTTF *userNameText[5];
CCLabelTTF *userScoreText[5];

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HighScoreScene *layer = [HighScoreScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		
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
		
		highScoreBGImage = [CCSprite spriteWithFile:@"highScoreBGImage.png"];
		highScoreBGImage.position = ccp(195,130);
		[self addChild:highScoreBGImage];
		[self addChild:headerImage];
		
		CCLabelTTF* label=[CCLabelTTF labelWithString:@"HighScore" fontName:@"Marker Felt" fontSize:29];
		label.position=ccp(size.width/2,size.height/2 + 130);
		label.color = ccc3(153, 0, 0);
		[self addChild:label];
		
		[self SetHeaderText];
		
		// Set the current stage type to 1
		giMapType = 1;
		giLevelNumber = 1;
		
		[self addMenuItems];
		[self addMenuSprites];
		[self addLevelButtons];
		
		[self SetHighScoreLabel];
		
	}
	
	return self;
}


-(void)SetHeaderText
{
	ccColor3B colorForText = ccc3(153, 0, 0);
	
	// Name header
	CCLabelTTF *nameHeaderText = [CCLabelTTF labelWithString:@"Name" fontName:@"Marker Felt" fontSize:20];
	nameHeaderText.position = ccp(40,180);
	nameHeaderText.color = colorForText;
	
	
	CCLabelTTF *scoreHeaderText = [CCLabelTTF labelWithString:@"Score" fontName:@"Marker Felt" fontSize:20];
	scoreHeaderText.position = ccp(230,180);
	scoreHeaderText.color = colorForText;
	
	[highScoreBGImage addChild:nameHeaderText];
	[highScoreBGImage addChild:scoreHeaderText];
	
	for (int i = 0; i<5; i++) {
		userNameText[i] = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(180, 30) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:17];
		userNameText[i].position = ccp(nameHeaderText.position.x + 70,(nameHeaderText.position.y - (i+1) * 28 - 15));
		userNameText[i].color = colorForText;
		
		userScoreText[i] = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(60, 30) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:17];
		userScoreText[i].position = ccp(scoreHeaderText.position.x,(scoreHeaderText.position.y - (i+1) * 28 - 15));
		userScoreText[i].color = colorForText;
		
		[highScoreBGImage addChild:userNameText[i]];
		[highScoreBGImage addChild:userScoreText[i]];
	}
	
}

-(void) addMenuItems
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

-(void) addMenuSprites
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
	
	NSLog(@"Stage Id : %d and Level id : %d",giMapType, giLevelNumber);
	
	[self SetHighScoreLabel];
}

-(void) addLevelButtons
{
	// Local variables
	float scalingFactorYForButton = 0.4f;
	float scalingFactorXForButton = 0.7f;
	id rotate1 = [CCRotateBy actionWithDuration:0 angle:270];
	id rotate2 = [CCRotateBy actionWithDuration:0 angle:270];
	id rotate3 = [CCRotateBy actionWithDuration:0 angle:270];
	id rotate4 = [CCRotateBy actionWithDuration:0 angle:270];
	id rotate5 = [CCRotateBy actionWithDuration:0 angle:270];
	
	// Level 1
	highScoreMenuItem[0] = [HighScoreMenu itemFromNormalImage:@"rectWhiteButton.png"
															selectedImage:@"rectGreenButton.png"
																   target:self
																 selector:@selector(showHighScoreForLevel:)];
	highScoreMenuItem[0].position = ccp(-195,-30);
	highScoreMenuItem[0].scaleX = scalingFactorXForButton;
	highScoreMenuItem[0].scaleY = scalingFactorYForButton;
	highScoreMenuItem[0].leftPositionX = -195;
	highScoreMenuItem[0].leftPositionY = -30;
	highScoreMenuItem[0].rightPositionX = -195;
	highScoreMenuItem[0].rightPositionY = -30;
	highScoreMenuItem[0].inRight = 0;
	highScoreMenuItem[0].itemNumber = 0;
	[highScoreMenuItem[0] runAction:rotate1 ];
	
	
	CCLabelTTF* level1Label=[CCLabelTTF labelWithString:@"Level 1" fontName:@"Marker Felt" fontSize:29];
	level1Label.position=ccp(highScoreMenuItem[0].contentSize.width/2,highScoreMenuItem[0].contentSize.height/2);
	level1Label.color = ccc3(153, 0, 0);		
	[highScoreMenuItem[0] addChild:level1Label];
	
	
	// Level 2
	highScoreMenuItem[1] = [HighScoreMenu itemFromNormalImage:@"rectWhiteButton.png"
															 selectedImage:@"rectGreenButton.png"
																	target:self
																  selector:@selector(showHighScoreForLevel:)];
	highScoreMenuItem[1].position = ccp(195-90,-30);
	highScoreMenuItem[1].scaleX = scalingFactorXForButton;
	highScoreMenuItem[1].scaleY = scalingFactorYForButton;
	highScoreMenuItem[1].leftPositionX = -195 + 30;
	highScoreMenuItem[1].leftPositionY = -30;
	highScoreMenuItem[1].rightPositionX = 195 - 90;
	highScoreMenuItem[1].rightPositionY = -30;
	highScoreMenuItem[1].inRight = 1;
	highScoreMenuItem[1].itemNumber = 1;
	[highScoreMenuItem[1] runAction:rotate2 ];
	
	CCLabelTTF* level2Label=[CCLabelTTF labelWithString:@"Level 2" fontName:@"Marker Felt" fontSize:29];
	level2Label.position=ccp(highScoreMenuItem[1].contentSize.width/2,highScoreMenuItem[1].contentSize.height/2);
	level2Label.color = ccc3(153, 0, 0);
	[highScoreMenuItem[1] addChild:level2Label];
	
	
	// Level 3
	highScoreMenuItem[2] = [HighScoreMenu itemFromNormalImage:@"rectWhiteButton.png"
														  selectedImage:@"rectGreenButton.png"
																 target:self
															   selector:@selector(showHighScoreForLevel:)];
	highScoreMenuItem[2].position = ccp(195-60,-30);
	highScoreMenuItem[2].scaleX = scalingFactorXForButton;
	highScoreMenuItem[2].scaleY = scalingFactorYForButton;
	highScoreMenuItem[2].leftPositionX = -195 + 60;
	highScoreMenuItem[2].leftPositionY = -30;
	highScoreMenuItem[2].rightPositionX = 195 - 60;
	highScoreMenuItem[2].rightPositionY = -30;
	highScoreMenuItem[2].inRight = 1;
	highScoreMenuItem[2].itemNumber = 2;
	[highScoreMenuItem[2] runAction:rotate3 ];
	
	
	CCLabelTTF* level3Label=[CCLabelTTF labelWithString:@"Level 3" fontName:@"Marker Felt" fontSize:29];
	level3Label.position=ccp(highScoreMenuItem[2].contentSize.width/2,highScoreMenuItem[2].contentSize.height/2);
	level3Label.color = ccc3(153, 0, 0);
	[highScoreMenuItem[2] addChild:level3Label];
	
	// Level 4
	highScoreMenuItem[3] = [HighScoreMenu itemFromNormalImage:@"rectWhiteButton.png"
														   selectedImage:@"rectGreenButton.png"
																  target:self
																selector:@selector(showHighScoreForLevel:)];
	highScoreMenuItem[3].position = ccp(195-30,-30);
	highScoreMenuItem[3].scaleX = scalingFactorXForButton;
	highScoreMenuItem[3].scaleY = scalingFactorYForButton;
	highScoreMenuItem[3].leftPositionX = -195 + 90;
	highScoreMenuItem[3].leftPositionY = -30;
	highScoreMenuItem[3].rightPositionX = 195 - 30;
	highScoreMenuItem[3].rightPositionY = -30;
	highScoreMenuItem[3].inRight = 1;
	highScoreMenuItem[3].itemNumber = 3;
	[highScoreMenuItem[3] runAction:rotate4 ];
	
	CCLabelTTF* level4Label=[CCLabelTTF labelWithString:@"Level 4" fontName:@"Marker Felt" fontSize:29];
	level4Label.position=ccp(highScoreMenuItem[3].contentSize.width/2,highScoreMenuItem[3].contentSize.height/2);
	level4Label.color = ccc3(153, 0, 0);
	[highScoreMenuItem[3] addChild:level4Label];
	
	
	// Total 
	highScoreMenuItem[4] = [HighScoreMenu itemFromNormalImage:@"rectWhiteButton.png"
													 selectedImage:@"rectGreenButton.png"
															target:self
														  selector:@selector(showHighScoreForLevel:)];
	highScoreMenuItem[4].position = ccp(195,-30);
	highScoreMenuItem[4].scaleX = scalingFactorXForButton;
	highScoreMenuItem[4].scaleY = scalingFactorYForButton;
	highScoreMenuItem[4].leftPositionX = -195 + 120;
	highScoreMenuItem[4].leftPositionY = -30;
	highScoreMenuItem[4].rightPositionX = 195;
	highScoreMenuItem[4].rightPositionY = -30;
	highScoreMenuItem[4].inRight = 1;
	highScoreMenuItem[4].itemNumber = 4;
	[highScoreMenuItem[4] runAction:rotate5 ];
	
	
	CCLabelTTF* totalLabel=[CCLabelTTF labelWithString:@"Total" fontName:@"Marker Felt" fontSize:29];
	totalLabel.position=ccp(highScoreMenuItem[4].contentSize.width/2,highScoreMenuItem[4].contentSize.height/2);
	totalLabel.color = ccc3(153, 0, 0);		
	[highScoreMenuItem[4] addChild:totalLabel];
	
	// Menu to go into the level
	CCMenu *menu = [CCMenu menuWithItems:highScoreMenuItem[0], highScoreMenuItem[1], highScoreMenuItem[2], highScoreMenuItem[3],highScoreMenuItem[4], nil];
	[self addChild:menu];
}

-(void)showHighScoreForLevel:(HighScoreMenu *)sender
{
	// Set the level
	giLevelNumber = sender.itemNumber + 1;
	if(sender.inRight)
	{
	   
										
		for(int i = 0; i<=sender.itemNumber; i++) {
			[highScoreMenuItem[i] runAction:[CCMoveTo actionWithDuration:accordianAnimationTime position:ccp(highScoreMenuItem[i].leftPositionX, highScoreMenuItem[i].leftPositionY)]];
			highScoreMenuItem[i].inRight = 0;
		}
	}
	else {
		for(int i = sender.itemNumber + 1; i<=4; i++) {
			[highScoreMenuItem[i] runAction:[CCMoveTo actionWithDuration:accordianAnimationTime position:ccp(highScoreMenuItem[i].rightPositionX, highScoreMenuItem[i].rightPositionY)]];
			highScoreMenuItem[i].inRight = 1;
		}
	}
	
	
	
	
	[highScoreBGImage runAction:[CCMoveTo actionWithDuration:accordianAnimationTime position:ccp(sender.leftPositionX + 15 + highScoreBGImage.contentSize.width/2 + 240, highScoreBGImage.position.y)]];
	
	NSLog(@"Stage Id : %d and Level id : %d",giMapType, giLevelNumber);
	
	[self SetHighScoreLabel];
	
}

-(void)SetHighScoreLabel
{
	DatabaseManager* dbManagerInstance = [[DatabaseManager alloc] init];
	highScoreInfo = [dbManagerInstance getAllHighScoreForLevel];
	int i = 0;
	
	for (int k = 0; k<5; k++) {
		[userNameText[k] setString:@""];
		[userScoreText[k] setString:@""];
	}
	
	for (i=0;i<[highScoreInfo count]; i++) {
		HighScore *highScore = [highScoreInfo objectForKey:[NSNumber numberWithInt:i]];
		
		[userNameText[i] setString:highScore.userName];
		[userNameText[i] runAction:[CCFadeIn actionWithDuration:accordianAnimationTime]];
		[userScoreText[i] setString:[NSString stringWithFormat:@"%d", highScore.levelScore]];
		[userScoreText[i] runAction:[CCFadeIn actionWithDuration:accordianAnimationTime]];
		
		
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
