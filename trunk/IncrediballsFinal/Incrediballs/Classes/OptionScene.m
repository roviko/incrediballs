//
//  OptionScene.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/6/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "OptionScene.h"
#import "DatabaseManager.h"
#import "Globals.h"
#import "allUserScene.h"
#import "HelloWorldScene.h"
#import "CreditScene.h"

@implementation OptionScene

UITextField *newUserTextField;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OptionScene *layer = [OptionScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *commonBG = [CCSprite spriteWithFile:@"commonBG.png"];
		commonBG.position = ccp(size.width/2,size.height/2);
		
		[self addChild:commonBG];
		
		CCSprite *backgroundImage = [CCSprite spriteWithFile:@"commonPopupBackground.png"];
		backgroundImage.position = ccp(size.width/2,size.height/2);
		
		[self addChild:backgroundImage];
		
		CCSprite *headerImage = [CCSprite spriteWithFile:@"rectWhiteButton.png"];
		headerImage.position = ccp(size.width/2,size.height/2 + 130);
		headerImage.scale = 0.5f;
		
		[self addChild:headerImage];
		
		CCLabelTTF* label=[CCLabelTTF labelWithString:@"Options" fontName:@"Marker Felt" fontSize:29];
		label.position=ccp(size.width/2,size.height/2 + 130);
		label.color = ccc3(153, 0, 0);
		[self addChild:label];
		
		
		int menuListTop = 20;
		
		CCMenuItemImage *newUserButton = [CCMenuItemImage itemFromNormalImage:@"rectWhiteButton.png"
																selectedImage:@"rectGreenButton.png"
																	   target:self
																	 selector:@selector(showNewUser)];
		newUserButton.position = ccp(0,menuListTop);
		newUserButton.scaleY = 0.5;

		
		CCLabelTTF* newUserLabel=[CCLabelTTF labelWithString:@"NEW USER" fontName:@"Marker Felt" fontSize:29];
		newUserLabel.position=ccp(size.width/2,size.height/2 + menuListTop);
		newUserLabel.color = ccc3(153, 0, 0);		
		
		
		CCMenuItemImage *loadGameButton = [CCMenuItemImage itemFromNormalImage:@"rectWhiteButton.png"
																 selectedImage:@"rectGreenButton.png"
																		target:self
																	  selector:@selector(showLoadGame)];
		loadGameButton.position = ccp(0,menuListTop - 50);
		loadGameButton.scaleY = 0.5;
		
		CCLabelTTF* loadGameLabel=[CCLabelTTF labelWithString:@"LOAD GAME" fontName:@"Marker Felt" fontSize:29];
		loadGameLabel.position=ccp(size.width/2,size.height/2 + menuListTop - 50);
		loadGameLabel.color = ccc3(153, 0, 0);
		
		
		//CCMenuItemImage *introButton = [CCMenuItemImage itemFromNormalImage:@"rectWhiteButton.png"
//															  selectedImage:@"rectGreenButton.png"
//																	 target:self
//																   selector:@selector(showIntroduction)];
//		introButton.position = ccp(0,menuListTop - 100);
//		introButton.scaleY = 0.5;
//		
//		CCLabelTTF* introLabel=[CCLabelTTF labelWithString:@"INTRODUCTION" fontName:@"Marker Felt" fontSize:29];
//		introLabel.position=ccp(size.width/2,size.height/2 + menuListTop - 100);
//		introLabel.color = ccc3(153, 0, 0);
		
		

		CCMenuItemImage *creditButton = [CCMenuItemImage itemFromNormalImage:@"rectWhiteButton.png"
															  selectedImage:@"rectGreenButton.png"
																	 target:self
																   selector:@selector(showCredit)];
		creditButton.position = ccp(0,menuListTop - 100);
		creditButton.scaleY = 0.5;	

		CCLabelTTF* creditLabel=[CCLabelTTF labelWithString:@"CREDIT" fontName:@"Marker Felt" fontSize:29];
		creditLabel.position=ccp(size.width/2,size.height/2 + menuListTop - 100);
		creditLabel.color = ccc3(153, 0, 0);
		
		
		
		
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"close_a.png" selectedImage:@"close_b.png"
															   target:self
															 selector:@selector(backButtonTouched)];
		backButton.position = ccp(215,132);		
		
		
		CCMenu* menu = [CCMenu menuWithItems:creditButton,newUserButton,loadGameButton,backButton,nil];
		//menu.position = CGPointMake(size.width/2, size.height/2); 
		[self addChild:menu];
		[self addChild:newUserLabel];
		[self addChild:loadGameLabel];
		//[self addChild:introLabel];
		[self addChild:creditLabel];
		
		// aligning is important, so the menu items don’t occupy the same location 
		//[menu alignItemsVerticallyWithPadding:40];
		
		
	}
	
	return self;
}

-(void)showIntroduction
{

}

-(void)showCredit
{
	[[CCDirector sharedDirector] replaceScene:[CreditScene node]];
}

-(void)showNewUser
{
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	
	[dialog setTitle:@"Enter Your Name"];
	[dialog setMessage:@"\n\n"];
	[dialog addButtonWithTitle:@"OK"];
	[dialog addButtonWithTitle:@"CANCEL"];
	//[dialog setFrame:CGRectMake(0.0f, 160.0f, 160.0f, 50.0f)];

	newUserTextField = [[UITextField alloc] init];
	[newUserTextField setFrame:CGRectMake(12.0f, 40.0f, 260.0f, 25.0f)];
	//[newUserTextField setBackgroundColor:[UIColor whiteColor]];
	[newUserTextField setText:@"UserName"];
	newUserTextField.borderStyle = UITextBorderStyleRoundedRect;
	//newUserTextField.highlighted = YES;
	newUserTextField.clearsOnBeginEditing = YES;
	
	[dialog addSubview:newUserTextField];
	
	[dialog show];
	[dialog release];
	
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    alertView.frame = CGRectMake(240.0f - 142.0f, 160.0f - 70.0f, 284.f, 140.f);
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0) {
		
		NSString *newUserName = [[newUserTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		int i = [newUserName length];
		
		if (i > 0) {
			
			gUserName = newUserName;

		}
		else {
			gUserName = @"UserName";
		}

		DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
		[dbInstance insertAnotherUser];
		
	}
	
}

-(void)showLoadGame
{
	[[CCDirector sharedDirector] replaceScene:[allUserScene node]];
}

-(void) backButtonTouched{
	[[CCDirector sharedDirector] popScene];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
