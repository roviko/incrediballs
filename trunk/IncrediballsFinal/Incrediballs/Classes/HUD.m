//
//  HUD.m
//  Incrediballs
//
//  Created by student on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"
#import "MultipleLayer.h"
#import "game_map.h"
#import "Globals.h"
#import "LevelBuilder.h"
#import "SoundLayer.h"

enum {
	
	
	kTagForDistance = 6
};


@implementation HUD

@synthesize distance;
@synthesize topBar;
@synthesize ballTurnMenu;
@synthesize ballLeftItem;

LevelBuilder *curLevel;
CCMenuItemImage *shootButton;
MultipleLayer *parent;
CCMenu* menuSprites;
CCSprite* HUDcontrol;
CGPoint menuP;
CGPoint spriteP;
int powerSpriteCount;
BOOL isTopBarOpen;

- (id) init
{
	//set offsets for menu and power sprites
	menuP.x=210;
	menuP.y=-132;
	spriteP.x=450;
	spriteP.y=28;
	
	
	// init power sprite count
	powerSpriteCount=0;
	
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		
		CGSize wins = [[CCDirector sharedDirector] winSize];
		
		
		isTopBarOpen = TRUE;
		
		topBar = [CCSprite spriteWithFile:@"HUDTopBar.png"];
		topBar.position = ccp(wins.width/2, wins.height - topBar.contentSize.height/2);
		//TopBar.color = ccc3(153, 0, 0);
		[self addChild:topBar];
		
		CCMenuItemImage *controlTopBar = [CCMenuItemImage itemFromNormalImage:@"HUDTopBarClose.png" selectedImage:@"HUDTopBarClose.png" target:self selector:@selector(SlideToolBar)];
		controlTopBar.position = ccp(-wins.width/2 + controlTopBar.contentSize.width/2,-wins.height/2 + controlTopBar.contentSize.height/2);
		
		HUDcontrol = [CCSprite spriteWithFile:@"HUDTopBarCloseArrow.png"];
		HUDcontrol.position = ccp(controlTopBar.contentSize.width/2,controlTopBar.contentSize.height/2);
		[controlTopBar addChild:HUDcontrol];
		
		CCMenuItemImage *pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(restartLevel)];
		pauseButton.position = ccp(wins.width/2 - pauseButton.contentSize.width/2 - 50,-wins.height/2 + controlTopBar.contentSize.height/2);
		
		CCMenu *controlMenu = [CCMenu menuWithItems:controlTopBar,pauseButton,nil];
		
		[topBar addChild:controlMenu];
		
		
		CCSprite *collectable = [CCSprite spriteWithFile:[NSString stringWithFormat:@"collectable_%d.png",giMapType]];
		collectable.position = ccp(wins.width/2,controlTopBar.contentSize.height/2);
		
		gLabelScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"0/%d",gMinItemsToCollect] fontName:@"American Typewriter" fontSize:16];
		gLabelScore.position=ccp(collectable.position.x + 45,collectable.position.y);
		gLabelScore.color=ccc3(153.0f, 0.0f, 0.0f);
		
		
		CCSprite *points = [CCSprite spriteWithFile:@"points.png"];
		points.position = ccp(100,controlTopBar.contentSize.height/2);
		
		gLabelDistance = [CCLabelTTF labelWithString:@"0" fontName:@"American Typewriter" fontSize:16];
		gLabelDistance.position=ccp(points.position.x + 45,points.position.y);
		gLabelDistance.color=ccc3(153.0f, 0.0f, 0.0f);
		
		[topBar addChild:collectable];
		[topBar addChild:gLabelScore];
		[topBar addChild:points];
		[topBar addChild:gLabelDistance];
		gLabelDistance.tag=kTagForDistance;
		
		
		shootButton = [CCMenuItemImage itemFromNormalImage:@"shoot.png" selectedImage:@"shoot.png"
																	 target:self
																   selector:@selector(callShootFunction)];
		shootButton.position = ccp(240 - [shootButton boundingBox].size.width/2,0);
		//shootButton.opacity = 235.0f;
		
		CCMenu *menu = [CCMenu menuWithItems:shootButton,nil];
		
		[self addChild:menu];
		
		
		[self showBallsLeft];
		[self schedule:@selector(getParent) interval:0.1];
		[self schedule:@selector(animateButton:)];
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	
}


-(void) getParent {

	[self unschedule:@selector(getParent)];
	// get multipleLayer as a parent
	parent = (MultipleLayer*)self.parent;
	
	// get the current level layer
	curLevel = [parent getLevelLayer];
	
	[self addPowerButton];
}

-(void) SlideToolBar
{
	SoundLayer *soundLayer = [parent getSoundLayer];
	
	CCSprite *muteSprite = [soundLayer muteImage];
	CCMenuItemImage *muteButton = [soundLayer muteButton];
	
	if (isTopBarOpen) {
		[HUDcontrol setTexture:[[CCTextureCache sharedTextureCache] addImage:@"HUDTopBarOpenArrow.png"]];
		[topBar runAction:[CCMoveTo actionWithDuration:1 position:ccp(240  + 480 - 50,topBar.position.y)]];
		[muteSprite runAction:[CCMoveTo actionWithDuration:1 position:ccp(240 + 215 + 480 - 50,muteSprite.position.y)]];
		[muteButton runAction:[CCMoveTo actionWithDuration:1 position:ccp(215 + 480 - 50,muteButton.position.y)]];
		isTopBarOpen = FALSE;
	}
	else {
		[HUDcontrol setTexture:[[CCTextureCache sharedTextureCache] addImage:@"HUDTopBarCloseArrow.png"]];
		[topBar runAction:[CCMoveTo actionWithDuration:1 position:ccp(240,topBar.position.y)]];
		[muteSprite runAction:[CCMoveTo actionWithDuration:1 position:ccp(240 + 215,muteSprite.position.y)]];
		[muteButton runAction:[CCMoveTo actionWithDuration:1 position:ccp(215,muteButton.position.y)]];
		isTopBarOpen = TRUE;
	}

}

-(void) animationItemCollected:(float)yPos
{
	if (isTopBarOpen) {
		
		CCSprite *collectable = [CCSprite spriteWithFile:[NSString stringWithFormat:@"collectable_%d.png",giMapType]];
		collectable.position = ccp(240,yPos + 32);
		
		[self addChild:collectable];
		
		[collectable runAction:[CCMoveTo actionWithDuration:1 position:ccp(240,295)]];
		[collectable runAction:[CCSequence actions:[CCFadeTo  actionWithDuration:1 opacity:125],[CCFadeOut actionWithDuration:0],nil]];
	}
}

-(void) restartLevel
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:0 scene:[MultipleLayer node]]];
}

-(void) addPowerButton {
	
	
	
	// initialize power used array
	for (int i=0; i<3; i++) {
		powerUsedArray[i]=FALSE;
	}
	int bid=0;
	bid++;
	gPowerButton1 = [CCMenuItemImage itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"
												  target:self
												selector:@selector(powerUsed1) ];
	
	gPowerButton1.position = ccp(menuP.x-60*powerSpriteCount,menuP.y);
	gPowerButton1.scale = 1.5f;
	gPowerButton1.tag=1;
	
	
	//NSLog(@"8957834758klkldhfgkljd98w95ijlk89yiosdfh8rmnsfh %d %d ", gBallPower1,gBallPower2);
	
	
	powerArray[powerSpriteCount]=[CCSprite spriteWithFile:[NSString stringWithFormat:@"power%d.png",gBallPower1]];
	powerArray[powerSpriteCount].position=ccp(spriteP.x-60*powerSpriteCount,spriteP.y);
	powerArray[powerSpriteCount].scale=1.5f;
	
	
	// incerement count sprite
	powerSpriteCount++;
	gPowerButton2 = [CCMenuItemImage  itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"
												   target:self
												 selector:@selector(powerUsed2)];
	
	
	gPowerButton2.position = ccp(menuP.x-60*powerSpriteCount,menuP.y);
	gPowerButton2.scale = 1.5f;
	gPowerButton2.tag = 2;
	
	powerArray[powerSpriteCount]=[CCSprite spriteWithFile:[NSString stringWithFormat:@"power%d.png",gBallPower2]];
	powerArray[powerSpriteCount].position=ccp(spriteP.x-60*powerSpriteCount,spriteP.y);
	powerArray[powerSpriteCount].scale=1.5f;
	
	
	
	
	menuSprites = [CCMenu menuWithItems:gPowerButton1,gPowerButton2,nil];

	[self addChild:powerArray[0]];
	[self addChild:powerArray[1]];
	[self addChild:menuSprites];
	
}


-(void) addCollectedPowerButton:(int)pID{
	
	
	//NSLog(@"aldmas;ljd;asjdjasdkjaslkdjkljlkkhhhhhhkjhjkhg hhhghg working!!!");
	
	//increment power sprite count
	powerSpriteCount++;
	
	
	gPowerButton3 = [CCMenuItemImage itemFromNormalImage:@"transparent_32_32.png" selectedImage:@"transparent_32_32.png"
												  target:self
												selector:@selector(powerUsed3)];
	
	gPowerButton3.position = ccp(menuP.x-60*powerSpriteCount,menuP.y);
	gPowerButton3.scale = 1.5f;
	
	//NSLog(@"8957834758klkldhfgkljd98w95ijlk89yiosdfh8rmnsfh %d %d", gPowerButton3.position.x,gPowerButton3.position.y);
	
	
	powerArray[powerSpriteCount]=[CCSprite spriteWithFile:[NSString stringWithFormat:@"power%d.png",pID]];
	powerArray[powerSpriteCount].position=ccp(spriteP.x-60*powerSpriteCount,spriteP.y);
	powerArray[powerSpriteCount].scale=1.5f;
	
	[self addChild:powerArray[powerSpriteCount]];
	[menuSprites addChild:gPowerButton3];
	
}

-(void) powerClickMenu :(id)v1 myTag: (int) mytag{
	
	NSLog(@"^^^@@@@!!!!!!!!!!!!!!!!!!!!!!power function working   %d", ((CCNode*)v1).tag);
	
	
}

-(void) powerUsed1 {
	NSLog(@"^^^@@@@!!!!!!!!!!!!!!!!!!!!!!power function working");
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
	
	id hideAction = [CCMoveTo actionWithDuration:1 position:ccp(240 + [shootButton boundingBox].size.width/2,0)];

	[shootButton runAction:hideAction];
}

- (void) showShootButton {
	
	id doNothing = [CCMoveBy actionWithDuration:3 position:CGPointZero];
	id showAction = [CCMoveTo actionWithDuration:1 position:ccp(240 - [shootButton boundingBox].size.width/2,0)];
	
	[shootButton runAction:[CCSequence actions:doNothing,showAction,nil]];
	NSLog(@"INside show shoot button");
}

-(void) showBallsLeft
{
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
	if(curLevel.ballFired == TRUE)
	{
		[curLevel reAttempt];
	}
}


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
	CCSprite *touchImage = [CCSprite spriteWithFile:@"redTouch.png"];
	touchImage.position = position;
	touchImage.scale = 0.7f;
	[self addChild:touchImage];
	
	float animationTime = 1.0f;
	
	id scaleDownAction = [CCScaleTo actionWithDuration:animationTime scale:0.3f]; 
	id fadeOutAction = [CCFadeOut actionWithDuration:animationTime];
	[touchImage runAction:[CCSpawn actions:fadeOutAction,scaleDownAction,nil]];
	
}

@end
