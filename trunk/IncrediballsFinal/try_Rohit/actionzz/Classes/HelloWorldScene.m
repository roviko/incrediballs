//
//  HelloWorldLayer.m
//  actionzz
//
//  Created by student on 2/18/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
CCSprite *alien;

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
		
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"glass.button_45.png" selectedImage:@"glass.button_45.png" target:self selector:@selector(doThis)];
		CCMenu *menu = [CCMenu menuWithItems:item1, nil];
		[self addChild:menu];
		
		alien = [CCSprite spriteWithFile:@"alien.png"];
		alien.position = ccp(50,50);
		[self addChild:alien];
	}
	return self;
}

-(void)doThis{
	
	id a1 = [CCRotateBy actionWithDuration:1 angle:360];
	//id repAct = [CCRepeatForever actionWithAction:a1];
	id ease = [CCEaseInOut actionWithAction:a1 rate:4];
	[alien runAction:ease];
	
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
