//
//  HelloWorldLayer.m
//  Menus
//
//  Created by student on 2/18/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "scene1.h"

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
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"alien.png" selectedImage:@"GNR2.png" target:self selector:@selector(doThis:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1, nil];
		
		[self addChild:menu];
	}
	return self;
}

-(void)doThis:(id)sender{
	[[CCDirector sharedDirector]replaceScene:[CCTransitionFlipX transitionWithDuration:1 scene:[scene1 node]]];
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
