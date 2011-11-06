//
//  iAdManager.h
//  Incrediballs
//
//  Created by student on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <iAd/iAd.h>

@interface iAdManager : CCLayer<ADBannerViewDelegate> {
    ADBannerView *addView;
}

@property (nonatomic, retain) ADBannerView *addView;


-(id) initWithIAD;

@end
