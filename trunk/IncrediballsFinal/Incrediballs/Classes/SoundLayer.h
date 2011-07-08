//
//  SoundLayer.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/8/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Globals.h"

@interface SoundLayer : CCLayer {
	CCMenuItemImage *muteButton;
	CCSprite *muteImage;
}

@property (nonatomic,retain) CCMenuItemImage *muteButton;
@property (nonatomic,retain) CCSprite *muteImage;

-(void) changeVolumeSetting;
-(void) playBackgroundMusic;
-(void) stopBackgroundMusic;
-(void) playBounceSound;
-(void) playShootSound;
-(void) playItemCollectedSound;
-(void) playPowerCollectedSound;
-(void) playVictorySound;
-(void) playTouchSound;
-(void) playJumpSound;
-(void) playReverseSound;

@end
