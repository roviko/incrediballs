//
//  Power.h
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface Power : CCLayer {
	int powerId;
	NSString* powerName;
	NSString* powerDescription;
	int powerIntensity;
	int numberOfPowers;
	
}

@property (nonatomic) int powerId;
@property (nonatomic) int powerIntensity;
@property (copy) NSString* powerName;
@property (copy) NSString* powerDescription;
@property (readonly) int numberOfPowers;

-(int) executePower:(cpBody*) bodyP powerID:(int)iPowerID;
-(void) powerReverse:(cpBody*) bodyP velBall:(CGPoint)velB;
-(void) powerLevitate:(cpBody*) bodyP velBall:(CGPoint)velB;
-(void) powerBooster:(cpBody*) bodyP velBall:(CGPoint)velB;
-(void) powerWalkThrough;

@end
