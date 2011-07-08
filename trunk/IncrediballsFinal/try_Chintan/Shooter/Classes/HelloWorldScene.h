//
//  HelloWorldLayer.h
//  Shooter
//
//  Created by CHINTANKUMAR PATEL on 2/24/11.
//  Copyright USC 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) setGlobalVariables;
-(void) startBoard:(id)sender;

@end
