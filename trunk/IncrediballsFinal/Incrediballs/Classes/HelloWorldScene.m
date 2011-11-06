//
//  HelloWorldScene.m
//  Incrediballs
//
//  Created by student on 2/16/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldScene.h"
#import "game_map.h"
#import "CCTouchDispatcher.h"
#import "TutorialScene.h"
#import "HighScoreScene.h"
#import "OptionScene.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"

CCSprite *preLoader;
CCSprite *cpLogo;
CCSprite *cocosLogo;
CCSprite *platformArray[17];
CCSprite *backBackground[2];
CCSprite *foreBackground[2];
CCSprite *bouncingBall;
float moveDirection;
CCSprite *traceMark[40];
BOOL tracePathActive = FALSE;
const int sizeOfPlatformArray = (sizeof platformArray) / (sizeof platformArray[0]);

// menu text
CCMenuItemLabel *item1Text;
CCMenuItemLabel *item2Text;
CCMenuItemLabel *item3Text;
CCMenuItemLabel *item4Text;

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mainTheme.wav"];
		
		//add bouncing ball
		moveDirection = -0.1;
		bouncingBall = [CCSprite spriteWithFile:@"headerBall.png"];
		bouncingBall.position = ccp(-57,230);
		[self addChild:bouncingBall];
		tracePathActive = FALSE;
		
		
		[self addMenuButtons];
			
		[self addBackgroundwithPlateform];
		[self schedule:@selector(holdForBouncingBall) interval:1.4f];
		[self schedule:@selector(holdForBackground) interval:2.2f];
		
	}
	
	return self;
}

-(void) addBackgroundwithPlateform
{
	CCSprite *fixedBackground = [CCSprite spriteWithFile:@"commonBG.png"];
	fixedBackground.position = ccp(fixedBackground.contentSize.width/2,fixedBackground.contentSize.height/2);
	[self addChild:fixedBackground z:-2];
	
	for(int i = 0; i < 2; i++)
	{
	
		backBackground[i] = [CCSprite spriteWithFile:@"bg_back_1.png"];
		foreBackground[i] = [CCSprite spriteWithFile:@"bg_front_1.png"];
		
		backBackground[i].position = ccp( (2*i + 1) * backBackground[i].contentSize.width/2,backBackground[i].contentSize.height/2);
		foreBackground[i].position = ccp( (2*i + 1) * foreBackground[i].contentSize.width/2,foreBackground[i].contentSize.height/2);
	
	
		[self addChild:backBackground[i] z:-4];
		[self addChild:foreBackground[i] z:-3];
	}
		 
	for (int i = 0; i < sizeOfPlatformArray; i++) {
		
		platformArray[i] = [CCSprite spriteWithFile:@"platform_center_1.png"];
		platformArray[i].position = ccp(16 + i * 32, 28);
		[self addChild:platformArray[i] z:-1];
		
		
	
	}
}

-(void) addMenuButtons
{
	float menuItemLeft = 335.0f;
	float menuItemTop = 38.0f;
	
	CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"menu_1a.png" selectedImage:@"menu_1b.png"
														   target:self
														 selector:@selector(arcadeModeScene:)];
	item1.position = ccp(menuItemLeft,menuItemTop);
	
	
	
	CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"menu_2a.png" selectedImage:@"menu_2b.png"
														   target:self
														 selector:@selector(tutorialModeScene:)];
	item2.position = ccp(menuItemLeft,menuItemTop - 43);
	
	
	
	CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"menu_3a.png" selectedImage:@"menu_3b.png"
														   target:self
														 selector:@selector(highScoreScene:)];
	item3.position = ccp(menuItemLeft,menuItemTop - 86);
	
	
	CCMenuItemImage *item4 = [CCMenuItemImage itemFromNormalImage:@"menu_4a.png" selectedImage:@"menu_4b.png"
														   target:self
														 selector:@selector(optionScene:)];
	item4.position = ccp(menuItemLeft,menuItemTop - 129);
	
	CCMenu *menu = [CCMenu menuWithItems:item1,item2,item3,item4,nil];
	
	[self addChild:menu];
		
	[item1 runAction:[CCMoveBy actionWithDuration:1 position:ccp(-210,0)]];
	[item2 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.6f position:ccp(0,0)],[CCMoveBy actionWithDuration:1 position:ccp(-210,0)],nil]];
	[item3 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:1.2f position:ccp(0,0)],[CCMoveBy actionWithDuration:1 position:ccp(-210,0)],nil]];
	[item4 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:1.8f position:ccp(0,0)],[CCMoveBy actionWithDuration:1 position:ccp(-210,0)],nil]];
	
}

-(void) holdForBouncingBall
{
	// add tracepath images
	int numTracePath = (sizeof traceMark)/(sizeof traceMark[0]);
	
	for(int i = 0; i < numTracePath; i++)
	{
		traceMark[i] = [CCSprite spriteWithFile:@"tracePath_10_10.png"];
		traceMark[i].scale = 0.5;
		traceMark[i].position = ccp(10,-50);
		traceMark[i].opacity = 0.0f;
		[self addChild:traceMark[i] z:-1];
	}
	
	[self schedule:@selector(makeBallBounce:)];
	[self unschedule:@selector(holdForBouncingBall)];
}

-(void) holdForBackground
{
	[self schedule:@selector(moveBg:)];
	[self unschedule:@selector(holdForBackground)];
}

-(void) makeBallBounce:(ccTime)dt
{
	float addPosY = 100*dt;
	float addPosX = sqrt(addPosY/2.0);
	float newX, newY;
	float maxX = 140;
	
	//if (moveDirection > 0.2 || moveDirection < - 0.1) {
		moveDirection -= 0.1;
	//}
	
	
	if (bouncingBall.position.y + moveDirection * addPosY < 60) {
		newY = 60;
		moveDirection = -moveDirection;
	}
	else if (bouncingBall.position.y + moveDirection * addPosY > 220) {
		newY = 220;
		moveDirection = -moveDirection;
		//NSLog(@"factor : %f",moveDirection);
	}
	else {
		newY = bouncingBall.position.y + moveDirection * addPosY;
	}

	if (bouncingBall.position.x + addPosX >= maxX) {
		newX = maxX;
	}
	else {
		newX = bouncingBall.position.x + addPosX;
	}
	
	bouncingBall.position = ccp(newX, newY);
	
	
	// traceMark position
	int numTracePath = (sizeof traceMark)/(sizeof traceMark[0]);
	
	
	for(int i = 0 ; i < numTracePath; i++)
	{
		
		if (traceMark[i].position.x <= 0) {
			
			traceMark[i].position = ccp(bouncingBall.position.x - maxX/numTracePath - 1, bouncingBall.position.y);
			
		}
		else {
			
			if (newX < maxX && i != 0) {
				traceMark[i].position = ccp(traceMark[i - 1].position.x + maxX/numTracePath, traceMark[i].position.y);
			}
			else {
					if (traceMark[i].position.x - addPosX < 0) {
						traceMark[i].position = ccp(0, traceMark[i].position.y);
					}
					else {
						traceMark[i].position = ccp(traceMark[i].position.x - addPosX, traceMark[i].position.y);
					}
			}

		}
		
		if (tracePathActive == TRUE) {
			traceMark[i].opacity = 255.0f;
		}
		else if(newX >= maxX) {
			if (traceMark[i].position.x <= 0) {
				traceMark[i].opacity = 255.0f;
			}
			
			if (traceMark[numTracePath - 1].position.x <= 0) {
				tracePathActive = TRUE;
			}
		}


	}
}

-(void) moveBg:(ccTime)dt
{
	int subPlateformPos = 100*dt;
	float subForegroundPos = subPlateformPos/3.0;
	float SubBackgroundPos = subForegroundPos/3.0;
	
	for(int i = 0; i < 2; i++)
	{
		foreBackground[i].position = ccp(foreBackground[i].position.x - subForegroundPos, foreBackground[i].position.y);
		backBackground[i].position = ccp(backBackground[i].position.x - SubBackgroundPos, backBackground[i].position.y);
		
		if (foreBackground[i].position.x < -foreBackground[i].contentSize.width/2) {
			foreBackground[i].position = ccp(foreBackground[i].position.x + foreBackground[i].contentSize.width * 2,foreBackground[i].position.y);
		}
		
		if (backBackground[i].position.x < -backBackground[i].contentSize.width/2) {
			backBackground[i].position = ccp(backBackground[i].position.x + backBackground[i].contentSize.width * 2, backBackground[i].position.y);
		}
	}
		
	for (int i = 0; i < sizeOfPlatformArray; i++) {
		
		platformArray[i].position = ccp(platformArray[i].position.x - subPlateformPos , platformArray[i].position.y);
	
		if (platformArray[i].position.x <= -16) {
			platformArray[i].position = ccp(platformArray[i].position.x + 32*(sizeOfPlatformArray - 1), platformArray[i].position.y);
		}
	
	}

	
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



-(void)arcadeModeScene:(id)sender{
	[[CCDirector sharedDirector]replaceScene:[CCTransitionSplitRows transitionWithDuration:1  scene:[game_map node]]];
}

-(void)tutorialModeScene:(id)sender{
	[[CCDirector sharedDirector] pushScene:[TutorialScene node]];
}

-(void)highScoreScene:(id)sender{
	[[CCDirector sharedDirector] pushScene:[HighScoreScene node]];
}

-(void)optionScene:(id)sender{
	[[CCDirector sharedDirector] pushScene:[OptionScene node]];
}

-(void)onEnter
{
    // Call the super enter function
    [super onEnter];
    
    // Initialize the iAD manager
    addView = [[iAdManager alloc] initWithIAD];
    
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

@end
