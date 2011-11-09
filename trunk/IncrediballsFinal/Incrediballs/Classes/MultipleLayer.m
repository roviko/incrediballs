//
//  MultipleLayer.m
//  Incrediballs
//
//  Created by student on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultipleLayer.h"
#import "HelloWorldScene.h"


MultipleLayer* multiLayerSceneInstance;

enum {
	LayerTagLevel=9,
	LayerTagHud=10,
	LayerTagSound=11
};

@implementation MultipleLayer

-(MultipleLayer*) sharedLayer {
	NSAssert(multiLayerSceneInstance != nil, @"MultiLayerScene not available!"); 
	return multiLayerSceneInstance;
}




-(LevelBuilder*) getLevelLayer
{
	CCNode* layer = [self getChildByTag:LayerTagLevel];
		NSAssert([layer isKindOfClass:[LevelBuilder class]], @"%@: not a GameLayer!",NSStringFromSelector(_cmd));
		return (LevelBuilder*)layer;
}


-(HUD*) getHUDLayer {
		CCNode* layer = [self getChildByTag:LayerTagHud]; 
		NSAssert([layer isKindOfClass:[HUD class]],@"%@: not a UILayer!", NSStringFromSelector(_cmd)); 
		return (HUD*)layer;
}

-(SoundLayer*) getSoundLayer {
	CCNode* layer = [self getChildByTag:LayerTagSound]; 
	NSAssert([layer isKindOfClass:[SoundLayer class]],@"%@: not a UILayer!", NSStringFromSelector(_cmd)); 
	return (SoundLayer*)layer;
}



-(id) init
{

if ((self = [super init])) {
	multiLayerSceneInstance = self;
	// The GameLayer will be moved, rotated and scaled independently 
	LevelBuilder* gameLayer = [LevelBuilder node]; 
	[self addChild:gameLayer z:1 tag:LayerTagLevel]; 
	
	// The UserInterfaceLayer remains static and relative to the screen area.
	HUD* uiLayer = [HUD node]; 
	[self addChild:uiLayer z:3 tag:LayerTagHud];
	
	SoundLayer* lSoundLayer = [SoundLayer node]; 
	[self addChild:lSoundLayer z:4 tag:LayerTagSound];
	
	[self addStaticBackground];
	
	}
	
	return self;
}

-(void) addStaticBackground {

	BackgroundMap *staticBackground = [BackgroundMap spriteWithFile:[NSString stringWithFormat:@"staticBg_%d.png",giMapType]];
	staticBackground.position = ccp([staticBackground boundingBox].size.width/2,[staticBackground boundingBox].size.height/2);
	
	[self addChild:staticBackground z:-10];

}

-(void) dealloc{
	// MultiLayerScene will be deallocated now, you must set it to nil 
	multiLayerSceneInstance = nil;
	// don't forget to call "super dealloc" 
	[super dealloc];
}

-(void) goToMainScreen
{
    NSLog(@"Multi layer go to main screen called!");
     [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1  scene:[HelloWorld node]]];
}

@end
