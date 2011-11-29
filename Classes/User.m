//
//  User.m
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User


@synthesize userId;
@synthesize userName;
@synthesize userScore;
@synthesize isCurrentUser;



//TODO remove this test class, make a constructor with proper city info
-(id) init
{
	if ((self = [super init])) {
	}
	return self;
}


@end
