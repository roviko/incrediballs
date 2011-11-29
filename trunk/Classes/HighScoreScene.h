//
//  HighScoreScene.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/6/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "iAdManager.h"

@interface HighScoreScene : CCLayer<ADBannerViewDelegate> {
    iAdManager *addView;
}

+(id)scene;
-(void) backButtonTouched;
-(void) addMenuItems;
-(void) addMenuSprites;
-(void) addLevelButtons;
-(void)SetHighScoreLabel;
-(void)SetHeaderText;


@end
