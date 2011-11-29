//
//  Ball.m
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "Power.h"

@implementation Ball


@synthesize ballId;
@synthesize ballName;
@synthesize ballDescription;
@synthesize radius, mass, elasticity, friction, powers, isBallUnlocked, ballPrice;


//TODO remove this test class, make a constructor with proper city info
-(id) init
{
	if ((self = [super init])) {
	}
	return self;
}

-(void) getPowersForBall
{
	
}


-(void) getPowerIdForBall
{
	
}

-(NSArray*) getPowerInfoForBall
{
	NSMutableArray *power = [[NSArray alloc] init];
	
	for(int i=0; i<2;i++)
	{
		Power *p = [[Power alloc] init];
		[p setPowerId:i];
		[p setPowerName:@"My Power Name"];
		[p setPowerDescription:@"My Power Desc"];
		
		[power addObject:p];
		[p release];
	}
	return [power autorelease];
}



@end
