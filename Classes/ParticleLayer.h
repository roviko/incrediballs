//
//  ParticleLayer.h
//  Incrediballs
//
//  Created by student on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ParticleLayer : CCLayer {
    int currentLevel;
    int currentMap;
}

// Properties
#pragma mark - Properties
@property (nonatomic, readwrite) int currentLevel;
@property (nonatomic, readwrite) int currentMap;

@end
