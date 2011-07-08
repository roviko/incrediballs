//
//  HelloWorldLayer.m
//  RPG
//
//  Created by student on 2/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

// HelloWorld implementation
@implementation HelloWorld
@synthesize theMap;
@synthesize bgLayer;
@synthesize ball;
@synthesize collideLayer;


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
		
		self.isTouchEnabled = YES;
		
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Jungle.wav"];
		
		
		self.theMap = [CCTMXTiledMap tiledMapWithTMXFile:@"ChitsMap.tmx"];
		self.bgLayer = [theMap layerNamed:@"bg"];
		self.collideLayer = [theMap layerNamed:@"collision"];
		collideLayer.visible = NO;
		
		CCTMXObjectGroup *ballObject = [theMap objectGroupNamed:@"ball"];
		
		NSMutableDictionary *startPoint = [ballObject objectNamed:@"StartPoint"];
		
		int x = [[startPoint valueForKey:@"x"]intValue];
		int y = [[startPoint valueForKey:@"y"]intValue];		
		
		self.ball = [CCSprite spriteWithFile:@"headerBall.png"];
		ball.position = ccp(x,y);
		
		[self addChild:ball];
		
		[self setCenterOfScreen:ball.position];
		
		[self addChild:theMap z:-1];
	}
	return self;
}

-(void) setCenterOfScreen:(CGPoint) position{

	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	
	int x = MAX(position.x , screenSize.width/2);
	int y = MAX(position.y , screenSize.height/2);
	
	x = MIN(x,theMap.mapSize.width * theMap.tileSize.width - screenSize.width/2);
	y = MIN(y, theMap.mapSize.height * theMap.tileSize.height - screenSize.height/2);
	
	CGPoint camPoint = ccp(x,y);
	
	CGPoint centerOfScreen = ccp(screenSize.width/2, screenSize.height/2);
	
	CGPoint difference = ccpSub(centerOfScreen, camPoint);
	
	
	///// added afterwards
	
	id MoveTo = [CCMoveTo actionWithDuration:1 position:difference];
	[self runAction:MoveTo];
	
	///// end
	
	//self.position = difference;
	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{

	self.theMap = nil;
	self.bgLayer = nil;
	self.ball = nil;
	self.collideLayer = nil;
	
	[super dealloc];
}

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	touchLocation = [self convertToNodeSpace:touchLocation];
	
	CGPoint ballPos = ball.position;
	
	NSString *str = [NSString stringWithCString:"123"];
	
	CCLabelTTF *label = [CCLabelTTF labelWithString:str fontName:@"Arial" fontSize:20];
	label.position = ccp(ballPos.x, ballPos.y + 50);
	[self addChild:label];
	
	return YES;
}


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{

	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	touchLocation = [self convertToNodeSpace:touchLocation];
	
	CGPoint ballPos = ball.position;
	
	CGPoint diff = ccpSub(touchLocation, ballPos);
	
	/*
	//move horizontal or vertical?
	if(abs(diff.x) > abs(diff.y)){
		if (diff.x > 0) {
			ballPos.x += theMap.tileSize.width;
		}
		else
		{
			ballPos.x -= theMap.tileSize.width;
		}
	}
	else {
		if (diff.y > 0) {
			ballPos.y += theMap.tileSize.height;
		}
		else
		{
			ballPos.y -= theMap.tileSize.height;
		}
	}
	 */

	ballPos.x += diff.x;
	ballPos.y += diff.y;
	
	
	//make sure the new position isnt off the map
	
	if (ballPos.x <= (theMap.mapSize.width * theMap.tileSize.width) &&
		ballPos.y <= (theMap.mapSize.height * theMap.tileSize.height) &&
		ballPos.x >= 0 &&
		ballPos.y >= 0 ) {
		[self setPlayerPosition:ballPos];
	}
	
	//move screen with same amount as ball is gonna move
	
	[self setCenterOfScreen:ballPos];
	

	
	
	//[ball runAction:<#(CCAction *)action#>];
	
}

-(void)setPlayerPosition:(CGPoint)position{

	CGPoint tileCoord = [self tileCoordForPosition:position];
	
	int tileGid = [collideLayer tileGIDAt:tileCoord];
	
	if (tileGid) {
		
		NSDictionary *properties = [theMap propertiesForGID:tileGid];
		
		if (properties) {
			NSString *sCollision = [properties valueForKey:@"Collidable"];
			
			if (sCollision && [sCollision compare:@"True"] == NSOrderedSame) {
				return;
			}
		}
		
	}
	
	id moveTo = [CCMoveTo actionWithDuration:1 position:position]; 
	
	[ball runAction:moveTo];
	
	//ball.position = position;
	
	
	//audio sound
	[[SimpleAudioEngine sharedEngine] playEffect:@"bloop3.wav"];
}

-(CGPoint)tileCoordForPosition:(CGPoint)position{

	int x = position.x/theMap.tileSize.width;
	int y = ((theMap.mapSize.height * theMap.tileSize.height) - position.y)/theMap.tileSize.height;

	return ccp(x,y);
}

@end
