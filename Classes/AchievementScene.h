//
//  AchievementScene.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/30/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AchievementScene : CCLayer {

}

+(id)scene;

-(void) getDetailsFromDatabase;
-(void) insertInDatabase;
-(void) addBackgroundLayer;
-(void) backButtonTouched;
-(void) animateProgress;
-(void) animateMedal;
-(void) moveMedal;
-(void) moveMessage;
-(void) removeMessageBG;
-(void) unlockAnimation;
-(void) changeLevelSprite;
-(void) addMenuItem;

@end
