//
//  BackgroundMap.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/5/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundMap : CCSprite {

	int iBackgroundIndex; // 0 for front black background and 1 for back gray background
}

@property int iBackgroundIndex;

- (id)initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect;

- (void)update:(ccTime)dt;

@end
