//
//  HUD.h
//  Incrediballs
//
//  Created by student on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"




@interface HUD : CCLayer {
	
	//CCBitmapFontAtlas * level;
	CCLabelTTF * distance;
	//CCBitmapFontAtlas * bombs;
	//NSMutableArray * lives;
	
	CCSprite *topBar;
	CCMenu *ballTurnMenu;
	NSMutableArray *ballLeftItem; // 2 because total there are 3 chances and at the start 2 left

}

//@property (nonatomic,retain) CCBitmapFontAtlas * level;
@property (nonatomic,retain) CCLabelTTF * distance;
@property (nonatomic,retain) CCSprite *topBar;
@property (nonatomic, retain) CCMenu *ballTurnMenu;
@property (nonatomic, retain) NSMutableArray *ballLeftItem;
//@property (nonatomic,retain) CCBitmapFontAtlas * bombs;
//@property (nonatomic,retain) NSMutableArray * lives;

-(void) SlideToolBar;
-(void) restartLevel;
-(void) animationItemCollected:(float)yPos;
-(void) addPowerButton;
- (void) animateButton: (ccTime) delta;
- (void) callShootFunction;
-(void) hideShootButton;
- (void) showShootButton;
-(void) showBallsLeft;
-(void) startNextTurn;
-(void) displayTouchImage: (CGPoint) position;
-(void) addCollectedPowerButton:(int)pID;

@end
