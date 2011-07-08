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
			[self powerReverse:bodyP velBall:velocity];
			break;
		case 2:
			[self powerLevitate:bodyP velBall:velocity];
			//return -1;
			break;
		case 3:
			[self powerBooster:bodyP velBall:velocity];
			break;
		case 4:
			collPowerFlag = 0;
			//[self schedule:@selector(powerWalkThrough)];
			break;
		case 5:
			shadPowerFlag=1;
			break;
		case 6:
			return -1;
			break;
		default:
			break;
	}
	return 0;
}

-(void) powerReverse:(cpBody*) bodyP velBall:(CGPoint)velB
{
	//NSLog(@"^^^@@@@!!!!!!!!!!!!!!!!!!!!!!power function working");
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
	
	if (velB.x < 0) {
		bodyP->v = ccp(velB.x - 200,velB.y + 200);
	}
	else {
		bodyP->v = ccp(velB.x + 200,velB.y + 200);
	}
	
}

-(void) powerWalkThrough{
	
	//NSLog(@"inside walk thru");
	[self unschedule:@selector(powerWalkThrough) ] ;
	powerWtCount++;
	
	if(powerWtCount<7)
		[self schedule:@selector(powerWalkThrough) interval:0.6 ];
	else 
	{
		[self unschedule:@selector(powerWalkThrough) ] ;
		collPowerFlag=1;
	}
		
	

	
}


@end
