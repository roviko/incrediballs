//
//  MultipleLayer.h
//  Incrediballs
//
//  Created by student on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelBuilder.h"
#import "HUD.h"
#import "SoundLayer.h"
#import "BackgroundMap.h"

@interface MultipleLayer : CCScene {
		

}
//@property (readonly) Level1* gameLayer; 
//@property (readonly) HUD* uiLayer;

-(LevelBuilder*) getLevelLayer;
-(HUD*) getHUDLayer;
-(SoundLayer*) getSoundLayer;
-(void) addStaticBackground;

@end
