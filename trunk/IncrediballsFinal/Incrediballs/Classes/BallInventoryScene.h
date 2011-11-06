//
//  BallInventoryScene.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/23/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "iAdManager.h"

@interface BallInventoryScene : CCLayer<ADBannerViewDelegate> {
    iAdManager *addView;
}

+(id)scene;
-(void) setGlobalVariables;
-(void) setBallDescriptionLayOut;
-(void) goBack;
-(void) playGame;
-(void) step: (ccTime) dt;
-(void) createBallMenu; // just creating menu buttons
-(void) addBallMenuPosition; // adding menu buttons in the different location
-(void) assignValues; // assign different values to different balls to differentiate them
-(void) displayDescription: (int) iBallId;
-(void) setSelectedBallVariables;
-(void)startGameAlert:(int) ballId isBuyRequest:(BOOL)buy;
-(void)scrollMenuWithTouch : (CGPoint)touchLocation;
-(void)scrollMenuAfterTouch : (CGPoint)touchLocation;
-(void) adjustBallPosition: (int) direction;

@end
