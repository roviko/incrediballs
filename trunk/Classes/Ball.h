//
//  Ball.h
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Ball : NSObject {
	int ballId;
	NSString* ballName;
	NSString* ballDescription;
	float radius;
	float mass;
	float elasticity;
	float friction;
	NSMutableArray* powers;
	bool isBallUnlocked;
	float ballPrice;
}

@property (nonatomic) int ballId;
@property (copy) NSString* ballName;
@property (copy) NSString* ballDescription;
@property (nonatomic) float radius;
@property (nonatomic) float mass;
@property (nonatomic) float elasticity;
@property (nonatomic) float friction;
@property (nonatomic) float ballPrice;
@property (retain) NSArray* powers;
@property (nonatomic) bool isBallUnlocked;


-(void) getPowerIdForBall;
-(NSArray*) getPowerInfoForBall;

@end
