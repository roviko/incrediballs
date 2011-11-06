//
//  SoundLayer.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/8/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "SoundLayer.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "MultipleLayer.h"

@implementation SoundLayer

@synthesize muteButton;
@synthesize muteImage; // this image is used as I didn't find way to change the image in menuItem dynamically
BOOL isMute = FALSE; // TRUE for mute and FALSE for unmute


- (id) init
{
	if ((self = [super init])) {

		if (!isMute) {
		
			muteButton = [CCMenuItemImage itemFromNormalImage:@"unmute.png" selectedImage:@"unmute.png"
													   target:self
													 selector:@selector(changeVolumeSetting)];
		
			muteImage = [CCSprite spriteWithFile:@"unmute.png"];
		}
		else {
			muteButton = [CCMenuItemImage itemFromNormalImage:@"mute.png" selectedImage:@"mute.png"
													   target:self
													 selector:@selector(changeVolumeSetting)];
			
			muteImage = [CCSprite spriteWithFile:@"mute.png"];
		}

		
		muteButton.position = ccp(215 + 480 - 50,135);
		

		muteImage.position = ccp(240 + 215 + 480 - 50, 160 + 135);
        
		CCMenu *menu = [CCMenu menuWithItems:muteButton,nil];
		
		[self addChild:menu];
		[self addChild:muteImage];
		
		[self playBackgroundMusic];
		
	}
	return self;
}

-(void) changeVolumeSetting {

	if (isMute) {
		isMute = FALSE;
		[self playBackgroundMusic];
		[muteImage setTexture:[[CCTextureCache sharedTextureCache] addImage:@"unmute.png"]];
		
	}
	else {
		[self stopBackgroundMusic];
		isMute = TRUE;
		[muteImage setTexture:[[CCTextureCache sharedTextureCache] addImage:@"mute.png"]];
	}


}

-(void) playBackgroundMusic {

	if (!isMute) {
		
	
		switch (giMapType) {
			case 1: // for city
				// playing background music
				[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backGround.mp3"];
				[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2f];
				break;
			default:
				break;
		}
	}
}

-(void) stopBackgroundMusic {

	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
}

-(void) playBounceSound {

	if (!isMute) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"bloop3.wav"];
	}
	
}

-(void) playShootSound {
	
	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"shoot.mp3"];
	}
	
}

-(void) playItemCollectedSound {
	
	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"coin.mp3"];
	}
	
}

-(void) playPowerCollectedSound {
	
	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"powerCollection.mp3"];
	}
	
}

-(void) playVictorySound {
	
	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"victory.mp3"];
	}
	
}

-(void) playTouchSound {
	
	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
	}
	
}

-(void) playJumpSound {
	
	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"Jump.mp3"];
	}
	
}

-(void) playReverseSound {
	
	if (!isMute) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"Reverse.mp3"];
	}
	
}

@end
