//
//  thirdScene.m
//  firstTry
//
//  Created by student on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "thirdScene.h"
#import "Ham.h"
#import "HelloWorldScene.h"
#import "touchdetect.h"

CCSprite *cocosIcon1;
CCSprite *cocosIcon2;
CCSprite *cocosIcon3;
CCSprite *cocosIcon11;
CCSprite *cocosIcon12;
CCSprite *cocosIcon13;
CCSprite *cocosIcon21;
CCSprite *cocosIcon22;
CCSprite *cocosIcon23;

@implementation thirdScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	
	thirdScene *layer = [thirdScene node];
	
	[scene addChild:layer];
	
	return scene;
}

-(id) init
{
	if((self=[super init])){
		
		CCSprite *bgImage = [CCSprite spriteWithFile:@"Red_gradient.png"];
		bgImage.position = ccp(240,160);
		[self addChild:bgImage];
		
		cocosIcon1 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon1.position = ccp(160,280);
		cocosIcon2 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon2.position = ccp(240,280);
		cocosIcon3 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon3.position = ccp(320,280);
		cocosIcon11 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon11.position = ccp(160,200);
		cocosIcon12 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon12.position = ccp(240,200);
		cocosIcon13 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon13.position = ccp(320,200);
		cocosIcon21 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon21.position = ccp(160,120);
		cocosIcon22 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon22.position = ccp(240,120);
		cocosIcon23 = [CCSprite spriteWithFile:@"button.png"];
		cocosIcon23.position = ccp(320,120);
		
		[self addChild:cocosIcon1];
		[self addChild:cocosIcon2];
		[self addChild:cocosIcon3];
		[self addChild:cocosIcon11];
		[self addChild:cocosIcon12];
		[self addChild:cocosIcon13];
		[self addChild:cocosIcon21];
		[self addChild:cocosIcon22];
		[self addChild:cocosIcon23];
		
		
		CCMenuItemImage *button1 = [CCMenuItemImage itemFromNormalImage:@"backButton.png" selectedImage:@"backButton.png"
																 target:self
															   selector:@selector(goBack)];
		
		
		
		
		button1.position = ccp(-200,-120);
		
		CCMenuItemImage *button2 = [CCMenuItemImage itemFromNormalImage:@"menuButton.jpg" selectedImage:@"menuButton.jpg"
																 target:self
															   selector:@selector(goMenu)];
		
		button2.position = ccp(-150,-120);
		
		CCMenuItemImage *button3 = [CCMenuItemImage itemFromNormalImage:@"rotate.png" selectedImage:@"rotate.png"
																 target:self
															   selector:@selector(rotateImages)];
		
		button3.position = ccp(0,-120);
		
		
		
		CCMenuItemImage *button4 = [CCMenuItemImage itemFromNormalImage:@"next.png" selectedImage:@"next.png"
																 target:self
															   selector:@selector(goNext)];
		button4.position = ccp(210,-120);
		
		CCMenu *menu = [CCMenu menuWithItems:button1,button2,button3,button4,nil];
		
		[self addChild:menu];
		
	}
	return self;
}

-(void) goBack{
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:1 scene:[Ham node] backwards:TRUE]];
	
}

-(void) goNext{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionJumpZoom transitionWithDuration:1 scene:[touchdetect node]]];
}

-(void) goMenu{
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:1 scene:[HelloWorld node]]];
}

-(void)rotateImages{
	
	id rotOnce = [CCRotateBy actionWithDuration:2 angle:360];
	id rotAction = [CCRotateBy actionWithDuration:2 angle:360];
	id rotAction2 = [CCRotateBy actionWithDuration:2 angle:360];
	id rotTwice = [CCRepeat actionWithAction:rotAction times:2];
	id rotInf = [CCRepeatForever actionWithAction:rotAction2];
	
	id ease1 = [CCRotateBy actionWithDuration:2 angle:360];
	id ease2 = [CCRotateBy actionWithDuration:2 angle:360];
	id ease3 = [CCRotateBy actionWithDuration:2 angle:360];
	id ease4 = [CCRotateBy actionWithDuration:2 angle:360];
	id ease5 = [CCRotateBy actionWithDuration:2 angle:360];
	id ease6 = [CCRotateBy actionWithDuration:2 angle:360];
	
	
	id easeAction11 = [CCEaseInOut actionWithAction:ease1 rate:4]; 
	id easeAction12 = [CCEaseBounceInOut actionWithAction:ease2];
	id easeAction13 = [CCEaseElasticInOut actionWithAction:ease3 period:4];
	id easeAction21 = [CCEaseExponentialInOut actionWithAction:ease4];
	id easeAction22 = [CCEaseSineInOut actionWithAction:ease5];
	id easeAction23 = [CCEaseBackInOut actionWithAction:ease6];
	
	[cocosIcon1 runAction:rotOnce];
	[cocosIcon2 runAction:rotTwice];
	[cocosIcon3 runAction:rotInf];
	[cocosIcon11 runAction:easeAction11];
	[cocosIcon12 runAction:easeAction12];
	[cocosIcon13 runAction:easeAction13];
	[cocosIcon21 runAction:easeAction21];
	[cocosIcon22 runAction:easeAction22];
	[cocosIcon23 runAction:easeAction23];
	
}

@end

