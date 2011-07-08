 //
 //  LoopingMenu.h
 //  iCode
 //
 //  Created by Caleb Wren on 2/24/10.
 //  Copyright 2010 Wrensation. All rights reserved.
 //

 #import "cocos2d.h"
#import "SimpleAudioEngine.h"
@interface LoopingMenu : CCMenu
{	
	float hPadding;
	float lowerBound;
	float yOffset;
	bool moving;
	bool touchDown;
	float accelerometerVelocity;
}

@property float yOffset;

@end
