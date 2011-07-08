//
//  touchdetect.m
//  CPGame1
//
//  Created by student on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "touchdetect.h"
#import "CCTouchDispatcher.h"
#import "thirdScene.h"
#import "HelloWorldScene.h"

CCSprite *cannon;
float touchBeginDist;

@implementation touchdetect

+(id) scene
{
	CCScene *scene = [CCScene node];
	
	touchdetect *layer = [touchdetect node];
	
	[scene addChild:layer];
	
	return scene;
}


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {


		// FOLLOWING 2 LINES ARE VERY IMPORTANT AS I WAS DEBUGGING WHY TOUCH FUNCTIONS FROM HAM.M WAS CALLED INSTEAD OF THIS FILES FUNCTIONS IN RESPONSE TO TOUCHES FOR 3 HOURS.....
		self.isTouchEnabled = YES;

		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		

		CCMenuItemImage *button2 = [CCMenuItemImage itemFromNormalImage:@"backButton.png" selectedImage:@"backButton.png"
														 target:self
													   selector:@selector(goBack)];


		button2.position = ccp(-200,-120);
		
		CCMenuItemImage *button3 = [CCMenuItemImage itemFromNormalImage:@"menuButton.jpg" selectedImage:@"menuButton.jpg"
														 target:self
													   selector:@selector(goMenu)];


		button3.position = ccp(-140,-120);


		CCMenu *menu = [CCMenu menuWithItems:button2,button3,nil];
		

		cannon = [CCSprite spriteWithFile:@"cannon1.png"];
		cannon.position = ccp(35,100);
		
		[self addChild:cannon];
		[self addChild:menu];
		
	}
	return self;
}

-(void) goBack{
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX  transitionWithDuration:1 scene:[thirdScene node]]];
	
}


-(void) goMenu{
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:1 scene:[HelloWorld node]]];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector]convertToGL:location];
	
	touchBeginDist = ccpDistance(convertedLocation, cannon.position);//(convertedLocation, cannon.position);
	
	
	NSLog(@"Distance : %f",touchBeginDist);
	//NSLog(@"Start Point x=> %f, y => %f",convertedLocation.x,convertedLocation.y);
	return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{

	CGPoint curLocation = [touch locationInView: [touch view]];
	curLocation = [[CCDirector sharedDirector] convertToGL:curLocation];
	
	//calculate the angle for rotation
	CGPoint distLine = ccpSub( curLocation,cannon.position);
	CGFloat angle = ccpToAngle(distLine);
	CGFloat convertedAngle = CC_RADIANS_TO_DEGREES(angle);
	
	if (convertedAngle <= 0) {
		convertedAngle = 0;
	}
	if (convertedAngle >= 90) {
		convertedAngle = 90;
	}
	
	float touchCurDist = ccpDistance(curLocation, cannon.position);
	float power = touchBeginDist - touchCurDist;

	if (power <= 0) {
		power = 0;
	}
	if (power >= 110) {
		power = 109;
	}
	
	int imageIndex = (power / 10) + 1;
	
	CGFloat cannonCurAngle = cannon.rotation;
	[self removeChild:cannon cleanup:YES];
	
	cannon = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cannon%d.png",imageIndex]];
	cannon.position = ccp(35,100);
	cannon.rotation = cannonCurAngle; 
	[self addChild:cannon];
	id rotCannon = [CCRotateTo actionWithDuration:0.1f angle:-convertedAngle];
	[cannon runAction:rotCannon];
	
	
	NSLog(@"angle => %f",convertedAngle);
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector]convertToGL:location];
	
	float touchEndDist = ccpDistance(convertedLocation, cannon.position);
	
	float power = touchBeginDist - touchEndDist;
	
	if (power <= 0) {
		power = 0;
	}
	if (power >= 110) {
		power = 110;
	}
	
	NSLog(@"Power : %f",power);
	//NSLog(@"End Point x=> %f, y => %f",convertedLocation.x,convertedLocation.y);
}



@end
