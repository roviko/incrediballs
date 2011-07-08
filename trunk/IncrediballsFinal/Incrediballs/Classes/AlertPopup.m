//
//  AlertPopup.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 3/26/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "AlertPopup.h"


@implementation AlertPopup

@synthesize sTitle;
@synthesize sAlertDesc;
@synthesize sButtonText1;
@synthesize sButtonText2;
@synthesize isTextField;
@synthesize iButtonIndex;

-(id) init {

	if ((self == [super init])) {

		self.isTouchEnabled = YES;
		
		isTextField = FALSE;
	}

	return self;
}

-(void) displayAlert: (NSString *) title desc: (NSString *) alertDesc button1: (NSString *) bText1 button2: (NSString *) bText2 textFieldPresent: (BOOL) isTField
{

	self.sTitle = title;
	self.sAlertDesc = alertDesc;
	self.sButtonText1 = bText1;
	self.sButtonText2 = bText2;
	self.isTextField = isTField;

	[self showAlertOnScreen];
}

-(void)showAlertOnScreen {
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Ball Selected !!"];
	[dialog setMessage:@"Do you want to play with this ball?"];
	[dialog addButtonWithTitle:@"Play"];
	[dialog addButtonWithTitle:@"Change"];
	[dialog show];
	[dialog release];
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	iButtonIndex = buttonIndex;
}

-(int) getAlertResponse
{
	return iButtonIndex;
}

@end
