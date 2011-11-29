//
//  HelloWorldScene.m
//  Incrediballs
//
//  Created by student on 2/16/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "iAdManager.h"


// HelloWorld Layer
@interface HelloWorld : CCLayer<ADBannerViewDelegate>
{
    //ADBannerView *addView;
    iAdManager *addView;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) addBackgroundwithPlateform;
-(void) addMenuButtons;
-(void) holdForBouncingBall;
-(void) holdForBackground;
-(void) makeBallBounce:(ccTime)dt;
-(void) moveBg:(ccTime)dt;

-(void)arcadeModeScene:(id)sender;
-(void)tutorialModeScene:(id)sender;
-(void)highScoreScene:(id)sender;
-(void)optionScene:(id)sender;

@end
