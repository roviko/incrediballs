//
//  game_map.h
//  Incrediballs
//
//  Created by student on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface game_map : CCLayer {

}
+(id)scene;
-(void)setLevelMenuScreenDescription;
-(void) getUnlockedLevels;
-(void)setTheCurrentUserGlobally;
-(void)animateTheWorldMap:(float) posX yPosition:(float)posY duration:(float)dt arrowDuration:(float)arrowAnimation scale:(float)scalingFactor selectLevelFor:(int)inputStageId animateWorld:(BOOL)isAnimateWorld animateArrows:(BOOL)isAnimateArrow;
-(void)addAllLevelImagesOnTheWorldImage;
-(void)initializeTheStaticVariables;
-(void)animatePlayableLevel;



@end
