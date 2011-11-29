//
//  CreditScene.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/27/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "CreditScene.h"
#import "OptionScene.h"

@implementation CreditScene


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditScene *layer = [CreditScene node];
	
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
		
		CCSprite *commonBG = [CCSprite spriteWithFile:@"CREDITS.png"];
		commonBG.position = ccp(size.width/2,size.height/2);
		
		[self addChild:commonBG];
		
		// Create a back button, always present
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"back_a.png" selectedImage:@"back_b.png"
																	target:self
																  selector:@selector(goBack)];
		backButton.position = ccp(-215,-135);
		backButton.scale = 0.5;
		
		// Menu to go into the level
		CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
		
		[self addChild:menu];
		
		
	}
	
	return self;
}


-(void) goBack{
	[[CCDirector sharedDirector] replaceScene:[OptionScene node]];
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
