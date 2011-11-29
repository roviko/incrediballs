//
//  AlertPopup.h
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/26/11.
//  Copyright 2011 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AlertPopup : CCLayer {

	NSString *sTitle;
	NSString *sAlertDesc;
	NSString *sButtonText1;
	NSString *sButtonText2;
	BOOL isTextField;
	int iButtonIndex;
	
}

@property (nonatomic, retain) NSString *sTitle;
@property (nonatomic, retain) NSString *sAlertDesc;
@property (nonatomic, retain) NSString *sButtonText1;
@property (nonatomic, retain) NSString *sButtonText2;
@property (readwrite) BOOL isTextField;
@property (readwrite) int iButtonIndex;

-(void) displayAlert: (NSString *) title desc: (NSString *) alertDesc button1: (NSString *) bText1 button2: (NSString *) bText2 textFieldPresent: (BOOL) isTField;
-(void)showAlertOnScreen;
-(int) getAlertResponse;

@end
