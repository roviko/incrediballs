//
//  iAdManager.m
//  Incrediballs
//
//  Created by student on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iAdManager.h"


@implementation iAdManager

@synthesize addView;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iAdManager *layer = [iAdManager node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



-(id) initWithIAD
{
	if( (self=[super init])) {
        NSLog(@"Init add");
    }
	
	return self;
}

-(void)onEnter
{
    NSLog(@"iAD:On Enter");
    // Call the super enter function
    [super onEnter];
    
    addView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    addView.delegate = self;
    addView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    addView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    
    [[[CCDirector sharedDirector] openGLView] addSubview:addView];
    
    // Transform iAD
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    // Add the iAD in the bottom on the Home screen
    addView.center = CGPointMake(addView.frame.size.width/2, windowSize.height/2+145);
    addView.hidden = YES;
    
}


-(void) onExit
{
    NSLog(@"On exit");
    addView.delegate = nil;
    [addView removeFromSuperview];
    [addView release];
    addView = nil;
    
    [super onExit];
}


-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"banner view did load ad");
    addView.hidden = NO;
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"banner view : did fail to receieve ad with error");
    addView.hidden = YES;
}


-(void) bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"banner view : did view action did finish");
    //[[UIApplication sharedApplication] setStatusBarStyle:(UIInterfaceOrientation)[[CCDirector sharedDirector]deviceOrientation]];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyle)[[CCDirector sharedDirector] deviceOrientation]];
}

-(void) dealloc
{
    [addView release];
    
    [super dealloc];
}


@end
