//
//  Ham.m
//  Untitled
//
//  Created by student on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ham.h"
#import "CCTouchDispatcher.h"
#import "HelloWorldScene.h"
#import "thirdScene.h"

CCSprite *preLoader;
CCSprite *cpLogo;
CCSprite *cocosLogo;


@implementation Ham

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Ham *layer = [Ham node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		
		
		// demo 1 start //
		
		
		CCMenuItemImage *button1 = [CCMenuItemImage itemFromNormalImage:@"button.png" selectedImage:@"button.png"
																 target:self
															   selector:@selector(doThis)];
		
		button1.position = ccp(150,-120);
		
		CCMenuItemImage *button2 = [CCMenuItemImage itemFromNormalImage:@"backButton.png" selectedImage:@"backButton.png"
																 target:self
															   selector:@selector(goBack)];
		
		
		button2.position = ccp(-200,-120);
		
		CCMenuItemImage *button3 = [CCMenuItemImage itemFromNormalImage:@"50px_up.png" selectedImage:@"50px_up.png"
																 target:self
															   selector:@selector(jumpUP)];
		
		
		button3.position = ccp(-140,-120);
		
		CCMenuItemImage *button4 = [CCMenuItemImage itemFromNormalImage:@"next.png" selectedImage:@"next.png"
																 target:self
															   selector:@selector(goNext)];
		
		
		button4.position = ccp(210,-120);
		
		CCMenu *menu = [CCMenu menuWithItems:button1,button2,button3,button4, nil];
		
		
		
		preLoader = [CCSprite spriteWithFile:@"long_bg.png"];
		preLoader.position = ccp(1000,160);
		[self addChild:preLoader];
		
		// create and initialize a Label
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		cpLogo = [CCSprite spriteWithFile:@"Icon.png"];
		cpLogo.position = ccp(40,260);
		[self addChild:cpLogo];
		
		cocosLogo = [CCSprite spriteWithFile:@"Icon-Small.png"];
		cocosLogo.position = ccp(340,60);
		[self addChild:cocosLogo];
		
		[self addChild:menu];
		
		[self schedule:@selector(callEveryFrame:)];
		
		[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
		
		
		
		// Demo1 end //
		
	}
	return self;
}

-(void) doThis{
	id rotAction = [CCRotateBy actionWithDuration:3 angle:360];
	id scaleAction = [CCScaleBy actionWithDuration:3 scale:2.0];
	id revScale = [scaleAction reverse];
	
	[cpLogo runAction:[CCSequence actions:[CCSpawn actions:rotAction,scaleAction,nil],revScale,nil]];
}

-(void) goBack{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipY transitionWithDuration:1 scene:[HelloWorld node]]];
}

-(void) goNext{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1 scene:[thirdScene node]]];
}

-(void) jumpUP{
	id jumpAction = [CCJumpBy actionWithDuration:3 position:ccp(0,0) height:150 jumps:4];
	//id moveAction = [CCMoveBy actionWithDuration:3 position:ccp(-30,0)];
	id scaleAction = [CCScaleBy actionWithDuration:1 scale:2.0];
	id rotateAction = [CCRotateBy actionWithDuration:1 angle:120];
	
	
	id revScaleAction = [scaleAction reverse];
	id revRotateAction = [CCRotateBy actionWithDuration:1 angle:-120];
	
	
	[cpLogo runAction:scaleAction];
	// CC Sequence for one after the other and CCspawn for all action together
	[cpLogo runAction:[CCSequence actions:rotateAction, [CCSpawn actions: revScaleAction, revRotateAction,nil],nil ]];
	[cocosLogo runAction:jumpAction];
	//[cocosLogo runAction:moveAction];
}

-(void) callEveryFrame:(ccTime)dt{
	cpLogo.position = ccp(cpLogo.position.x + 100*dt,cpLogo.position.y);
	if (cpLogo.position.x > 480 + 20) {
		cpLogo.position = ccp(-20, cpLogo.position.y);
	}
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector]convertToGL:location];
	
	[cocosLogo stopAllActions];
	[cocosLogo runAction:[CCMoveTo actionWithDuration:1 position:convertedLocation]];
	
}


@end
