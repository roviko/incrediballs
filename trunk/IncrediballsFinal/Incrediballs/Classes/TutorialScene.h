//
//  TutorialScene.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/6/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TutorialScene : CCLayer {

}

+(id)scene;
-(void) addTutMenuBG;
-(void) startTutorial: (id) sender;
-(void) enableMovement;
-(void) addMapSelector;
-(void) addMapSelectorSprite;
-(void) addTutorialList;
-(void) changeBG: (id) sender;
-(void) backButtonTouched;
-(void) addTutorialList;
-(void) addTutorialButtons;
-(void) setGlobleVariables;
-(void) changeTutorialDescription:(int)tutID curBGID:(int)bgID;

@end
