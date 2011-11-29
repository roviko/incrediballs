//
//  TutorialMultiLayer.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/15/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "TutorialMultiLayer.h"


TutorialMultiLayer* multiLayerSceneInstance;

enum {
	LayerTagLevel=9,
	LayerTagHud=10,
	LayerTagSound=11
};

@implementation TutorialMultiLayer

-(TutorialMultiLayer*) sharedLayer {
	NSAssert(multiLayerSceneInstance != nil, @"MultiLayerScene not available!"); 
	return multiLayerSceneInstance;
}




-(TutorialBuilder*) getLevelLayer
{
	CCNode* layer = [self getChildByTag:LayerTagLevel];
	NSAssert([layer isKindOfClass:[TutorialBuilder class]], @"%@: not a GameLayer!",NSStringFromSelector(_cmd));
	return (TutorialBuilder*)layer;
}


-(TutorialHUD*) getHUDLayer {
	CCNode* layer = [self getChildByTag:LayerTagHud]; 
	NSAssert([layer isKindOfClass:[TutorialHUD class]],@"%@: not a UILayer!", NSStringFromSelector(_cmd)); 
	return (TutorialHUD*)layer;
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
		TutorialBuilder* gameLayer = [TutorialBuilder node]; 
		[self addChild:gameLayer z:1 tag:LayerTagLevel]; 
		
		// The UserInterfaceLayer remains static and relative to the screen area.
		TutorialHUD* uiLayer = [TutorialHUD node]; 
		[self addChild:uiLayer z:2 tag:LayerTagHud];
		
		SoundLayer* lSoundLayer = [SoundLayer node]; 
		[self addChild:lSoundLayer z:3 tag:LayerTagSound];
		
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
	NSLog(@"Inside multilayer dealloc");
	// don't forget to call "super dealloc" 
	[super dealloc];
}
@end