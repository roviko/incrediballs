//
//  MenuLevelSelector.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/9/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuLevelSelector : CCMenuItemImage {

	int mapType;
	int levelNumber;
	int worldId;
	int minItemsToCollect;
}

@property (readwrite) int mapType;
@property (readwrite) int levelNumber;
@property (readwrite) int worldId;
@property (readwrite) int minItemsToCollect;

@end
