//
//  TutorialMultiLayer.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/15/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TutorialBuilder.h"
#import "TutorialHUD.h"
#import "SoundLayer.h"
#import "BackgroundMap.h"


@interface TutorialMultiLayer : CCScene {
	
}
//@property (readonly) Level1* gameLayer; 
//@property (readonly) HUD* uiLayer;

-(TutorialBuilder*) getLevelLayer;
-(TutorialHUD*) getHUDLayer;
-(SoundLayer*) getSoundLayer;
-(void) addStaticBackground;



@end
