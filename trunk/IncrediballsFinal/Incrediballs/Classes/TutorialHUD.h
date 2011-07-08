//
//  TutorialHUD.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/15/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TutorialHUD : CCLayer {
	
	CCLabelTTF * distance;
	
	CCMenu *ballTurnMenu;
	NSMutableArray *ballLeftItem; // 2 because total there are 3 chances and at the start 2 left
	BOOL isTutorialFinished;
	BOOL isBeginOccur;
	BOOL isMoveOccur;
	int eventID;
	
}


@property (nonatomic,retain) CCLabelTTF * distance;
@property (nonatomic, retain) CCMenu *ballTurnMenu;
@property (nonatomic, retain) NSMutableArray *ballLeftItem;
@property (readwrite) BOOL isTutorialFinished;
@property (readwrite) BOOL isBeginOccur;
@property (readwrite) BOOL isMoveOccur;
@property (readwrite) int eventID;

-(void) setGlobalVariables;
-(void) generalInit;

-(void) callTutorialSpecificInit;
-(void) tut1Init;
-(void) tut2Init;
-(void) tut3Init;
-(void) tut4Init;
-(void) tut5Init;
-(void) tut6Init;
-(void) tut7Init;
-(void) tut8Init;
-(void) tut9Init;
-(void) tut10Init;
-(void) tut11Init;
-(void) tut12Init;

-(void) addTutTouch: (CGPoint) location;
-(void) removeTutTouch;

-(void) callEveryFrame;
-(void) tut1EveryFrame;
-(void) tut2EveryFrame;
-(void) tut3EveryFrame;
-(void) tut4EveryFrame;
-(void) tut5EveryFrame;
-(void) tut6EveryFrame;
-(void) tut7EveryFrame;
-(void) tut8EveryFrame;
-(void) tut9EveryFrame;
-(void) tut10EveryFrame;
-(void) tut11EveryFrame;
-(void) tut12EveryFrame;

-(void) addShootButtonInMenu;
-(void) addPowerButton;
- (void) animateButton: (ccTime) delta;
- (void) animateTouchImage: (ccTime) delta;
- (void) callShootFunction;
-(void) hideShootButton;
- (void) showShootButton;
-(void) showBallsLeft;
-(void) startNextTurn;
-(void) displayTouchImage: (CGPoint) position;

@end
