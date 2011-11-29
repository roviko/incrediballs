//
//  HighScoreMenu.h
//  Incrediballs
//
//  Created by student on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HighScoreMenu : CCMenuItemImage {
	int leftPositionX;
	int leftPositionY;
	int rightPositionX;
	int rightPositionY;
	int inRight;
	int itemNumber;
}

@property (readwrite) int leftPositionX;
@property (readwrite) int leftPositionY;
@property (readwrite) int rightPositionX;
@property (readwrite) int rightPositionY;
@property (readwrite) int inRight;
@property (readwrite) int itemNumber;


@end
