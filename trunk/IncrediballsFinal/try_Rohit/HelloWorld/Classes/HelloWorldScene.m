//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "TouchDispatcher.h"

Sprite *jesus;
Sprite *gnr;

// HelloWorld implementation
@implementation HelloWorld 

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
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
		jesus = [Sprite spriteWithFile:@"jesus.png"];
		jesus.position = ccp(240,160);
		[self addChild:jesus z:0];	
		
		gnr = [Sprite spriteWithFile:@"GNR2.png"];
		gnr.position = ccp(120,120);
		[self addChild:gnr z:0];
		
		[self schedule:@selector(callEveryFrame:)];
		
		[[TouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
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

-(void) callEveryFrame:(ccTime)dt{
	jesus.position = ccp(jesus.position.x + 100 * dt, jesus.position.y);
	if(jesus.position.x > 480 + 30)
	{
		jesus.position = ccp(-30, jesus.position.y);
	}
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[Director sharedDirector]convertToGL:location];
	
	[jesus stopAllActions];
	[jesus runAction:[MoveTo actionWithDuration:1 position:convertedLocation]];
}

@end
