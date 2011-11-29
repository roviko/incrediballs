//
//  User.h
//  Incrediballs
//
//  Created by student on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface User : NSObject {
	int userId;
	NSString* userName;
	int userScore;
	bool isCurrentUser;
}

@property (nonatomic) int userId;
@property (copy) NSString* userName;
@property (nonatomic) int userScore;
@property (nonatomic) bool isCurrentUser;


// Methods definition


@end
