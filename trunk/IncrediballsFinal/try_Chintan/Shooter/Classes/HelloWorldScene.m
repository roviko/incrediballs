//
//  HelloWorldLayer.m
//  Shooter
//
//  Created by CHINTANKUMAR PATEL on 2/24/11.
//  Copyright USC 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "BoardLayer.h"
#import "CCTouchDispatcher.h"
#import "Globals.h"

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

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Shooter" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"Icon.png" selectedImage:@"Icon.png"
															   target:self
															 selector:@selector(startBoard:)];
	
		item1.position = ccp(0,-80);
		
		CCMenu *menu = [CCMenu menuWithItems:item1,nil];
	
		[self addChild:menu];
		[self setGlobalVariables];
	}
	return self;
}

-(void) setGlobalVariables
{
	LEFT = TRUE;
	RIGHT = FALSE;
	NUMGRID = 9;
}

-(void) startBoard:(id)sender{

	[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:1 scene:[BoardLayer node]]];

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
