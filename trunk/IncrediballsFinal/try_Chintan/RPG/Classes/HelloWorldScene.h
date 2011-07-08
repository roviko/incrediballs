//
//  HelloWorldLayer.h
//  RPG
//
//  Created by student on 2/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	
	CCTMXTiledMap *theMap;
	CCTMXLayer *bgLayer;
	CCSprite *ball;
	CCTMXLayer *collideLayer;
	
}

@property (nonatomic, retain) CCTMXTiledMap *theMap;
@property (nonatomic, retain) CCTMXLayer *bgLayer;
@property (nonatomic, retain) CCSprite *ball;
@property (nonatomic, retain) CCTMXLayer *collideLayer;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) setCenterOfScreen:(CGPoint) position;
-(void)setPlayerPosition:(CGPoint) position;
-(CGPoint)tileCoordForPosition:(CGPoint)position;

@end
