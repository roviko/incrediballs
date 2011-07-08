//
//  OptionScene.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/6/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OptionScene : CCLayer {

}

+(id)scene;

-(void)showIntroduction;
-(void)showCredit;
-(void)showNewUser;
-(void)showLoadGame;
-(void) backButtonTouched;

@end
