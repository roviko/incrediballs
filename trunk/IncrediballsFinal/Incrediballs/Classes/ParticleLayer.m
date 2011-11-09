//
//  ParticleLayer.m
//  Incrediballs
//
//  Created by student on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParticleLayer.h"


@implementation ParticleLayer

@synthesize currentLevel, currentMap;

#pragma mark - Scene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ParticleLayer *layer = [ParticleLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

#pragma mark - Initialization

-(id) init
{
	if( (self=[super init])) {
        
    }
	
	return self;
}

#pragma mark - User defined functions

#pragma mark - Deallocation

-(void) dealloc
{    
    [super dealloc];
}



@end
