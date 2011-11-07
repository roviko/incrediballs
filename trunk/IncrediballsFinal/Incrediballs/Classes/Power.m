//
//  Power.m
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Power.h"
#import "Globals.h"


@implementation Power

@synthesize powerId;
@synthesize powerName;
@synthesize powerDescription;
@synthesize numberOfPowers, powerIntensity;

int powerWtCount=0;


//TODO remove this test class, make a constructor with proper city info
-(id) init
{
	if ((self = [super init])) {
	}
	return self;
}

-(int) executePower:(cpBody*) bodyP powerID:(int)iPowerID
{
	CGPoint velocity = bodyP->v;
	
	switch (iPowerID) {
		case 1:
            // Reverse power
			[self powerReverse:bodyP velBall:velocity];
			break;
		case 2:
            // Levitate power
			[self powerLevitate:bodyP velBall:velocity];
			break;
		case 3:
            // Boost the speed
			[self powerBooster:bodyP velBall:velocity];
			break;
		case 4:
            // Set the collision flag to zero
            // By doing this the level builder will by itself set ithe upper collision platforms to false
            // This is done in the the setup method of LevelBuilder.m
			collPowerFlag = 0;
			break;
		case 5:
            // Set the collision flag to one
            // By doing this the level builder check this flag in the callEveryFrame method and the pick
            // all the collectables from the platfroms
			shadPowerFlag=1;
			break;
		case 6:
            // Trace the path
			return -1;
			break;
		default:
			break;
	}
	return 0;
}

-(void) powerReverse:(cpBody*) bodyP velBall:(CGPoint)velB
{
    // Change the X-velocity in the reverse direction
	bodyP->v = ccp(-velB.x, velB.y);
}


-(void) powerLevitate:(cpBody*) bodyP velBall:(CGPoint)velB
{
	//Check if less than limit
	
	// else	
	bodyP->v=ccp(velB.x,velB.y+200);
	
}

-(void) powerBooster:(cpBody*) bodyP velBall:(CGPoint)velB
{
    // Power boost
	bodyP->v = (velB.x < 0) ? ccp(velB.x - 200,velB.y + 200) : ccp(velB.x + 200,velB.y + 200);	
}

-(void) powerWalkThrough{
	// Walkthrough power
	//NSLog(@"inside walk thru");
//	[self unschedule:@selector(powerWalkThrough) ] ;
//	powerWtCount++;
//	
//	if(powerWtCount<7)
//		[self schedule:@selector(powerWalkThrough) interval:0.6 ];
//	else 
//	{
//		[self unschedule:@selector(powerWalkThrough) ] ;
//		collPowerFlag=1;
//	}
		
	

	
}


@end
