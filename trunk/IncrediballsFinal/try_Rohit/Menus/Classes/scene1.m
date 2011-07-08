//
//  scene1.m
//  Menus
//
//  Created by student on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "scene1.h"



@implementation scene1
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	scene1 *layer = [scene1 node];
	
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
	
}

@end