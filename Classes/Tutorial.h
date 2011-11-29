//
//  Tutorial.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/24/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Tutorial : CCLayer {
	int tutorialId;
	NSString* title;
	NSString* description;
}

@property (nonatomic) int tutorialId;
@property (copy) NSString* title;
@property (copy) NSString* description;


@end
