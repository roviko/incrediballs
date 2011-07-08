//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "LoopingMenu.h"

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
		CCBitmapFontAtlas *play = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Play" fntFile:@"Cracked.fnt"];
		CCBitmapFontAtlas *help = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Help" fntFile:@"Cracked.fnt"];
		CCBitmapFontAtlas *options = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Options" fntFile:@"Cracked.fnt"];
		CCMenuItemLabel *one = [CCMenuItemLabel itemWithLabel:play target:self selector:@selector(play:)];
		CCMenuItemLabel *two = [CCMenuItemLabel itemWithLabel:help target:self selector:@selector(help:)];
		CCMenuItemLabel *three = [CCMenuItemLabel itemWithLabel:options target:self selector:@selector(options:)];
		LoopingMenu *menu = [LoopingMenu menuWithItems: [CCMenuItemFont itemFromString:@"     " target:nil selector:nil], one,[CCMenuItemFont itemFromString:@"      " target:nil selector:nil], two,[CCMenuItemFont itemFromString:@"      " target:nil selector:nil], three, nil];
		menu.position = ccp(240, 160);
		[menu alignItemsHorizontally];
		[self addChild:menu];
	}
	return self;
}
-(void) play: (id) sender {
	
}
-(void) help: (id) sender {
	
}
-(void) options: (id) sender {
	
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
