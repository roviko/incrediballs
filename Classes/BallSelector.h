//
//  ballSelector.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/23/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface BallSelector : CCSprite {
	
	int iBallID;
	float fMass;
	float fElasticity;
	float fFriction;
	int iBallPrice;
	BOOL isUnlocked;
	int iPower1,iPower2;
}

@property (readwrite) int iBallID;
@property (readwrite) float fMass;
@property (readwrite) float fElasticity;
@property (readwrite) float fFriction;
@property (readwrite) int iBallPrice;
@property (readwrite) BOOL isUnlocked;
@property (readwrite) int iPower1;
@property (readwrite) int iPower2;

@end
