
// Import the interfaces
#import "HelloWorldScene.h"
#import "Ham.h"
#import "CCTouchDispatcher.h"

CCSprite *preLoader;
CCSprite *cpLogo;
CCSprite *cocosLogo;

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
		
		
		// demo2 start //
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"golf_ball_spinning_md_wht.gif" selectedImage:@"lens16805611_1293091110unique_soccer_balls.jpg"
															   target:self
															 selector:@selector(doThis:)];
		
		CCMenu *menu = [CCMenu menuWithItems:item1,nil];
		
		[self addChild:menu];
		// demo2 end //
		
		
		// demo 1 start //
		/*  
		 preLoader = [CCSprite spriteWithFile:@"Red_gradient.png"];
		 preLoader.position = ccp(240,160);
		 [self addChild:preLoader];
		 
		 cpLogo = [CCSprite spriteWithFile:@"Icon.png"];
		 cpLogo.position = ccp(40,260);
		 [self addChild:cpLogo];
		 
		 cocosLogo = [CCSprite spriteWithFile:@"Icon3.png"];
		 cocosLogo.position = ccp(340,60);
		 [self addChild:cocosLogo];
		 
		 [self schedule:@selector(callEveryFrame:)];
		 
		 [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
		 
		 // create and initialize a Label
		 CCLabelTTF* label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		 
		 // ask director the the window size
		 CGSize size = [[CCDirector sharedDirector] winSize];
		 
		 // position the label on the center of the screen
		 label.position =  ccp( size.width /2 , size.height/2 );
		 
		 // add the label as a child to this Layer
		 [self addChild: label];
		 */
		// Demo1 end //
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



-(void)doThis:(id)sender{
	[[CCDirector sharedDirector]replaceScene:[CCTransitionMoveInL  transitionWithDuration:1 scene:[Ham node]]];
}




@end

