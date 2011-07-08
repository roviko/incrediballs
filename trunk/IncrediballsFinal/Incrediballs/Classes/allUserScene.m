//
//  allUser.m
//  Incrediballs
//
//  Created by CHINTANKUMAR PATEL on 4/13/11.
//  Copyright 2011 USC. All rights reserved.
//

#import "allUserScene.h"
#import "DatabaseManager.h"
#import "User.h"
#import "OptionScene.h"


@implementation allUserScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	allUserScene *layer = [allUserScene node];
	
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
		
		CCLabelTTF* label=[CCLabelTTF labelWithString:@"Load Game" fontName:@"Marker Felt" fontSize:29];
		label.position=ccp(size.width/2,size.height/2 + 130);
		label.color = ccc3(153, 0, 0);
		[self addChild:label];
		
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"close_a.png" selectedImage:@"close_b.png"
																	target:self
																  selector:@selector(goBack)];
		backButton.position = ccp(215,132);	

		
		CCMenu *menu = [CCMenu menuWithItems:backButton,nil];
		
		[self addChild:menu];
		
		
		DatabaseManager *dbInstance = [[DatabaseManager alloc] init];
		NSMutableDictionary *arrUsers = [dbInstance getAllUsers];
		
		int i = 0;
		
		for (id key in arrUsers) {
			
			User *currUser = [arrUsers objectForKey:key];
			
			CCMenuItemImage *userNameButton = [CCMenuItemImage itemFromNormalImage:@"rectWhiteButton.png"
																	 selectedImage:@"rectGreenButton.png"
																			target:self
																		  selector:@selector(loadUser:)];
			
			userNameButton.position = ccp(0,60 - i * 50);
			userNameButton.scaleY = 0.5;
			userNameButton.userData = (id)[currUser userId];
			
			[menu addChild:userNameButton];
			
			CCLabelTTF* userNameLabel=[CCLabelTTF labelWithString:[currUser userName]  fontName:@"Marker Felt" fontSize:29];
			userNameLabel.position=ccp(240,220 - i * 50);
			userNameLabel.color = ccc3(153, 0, 0);
			
			[self addChild:userNameLabel];
			
			i++;
		}
		
		
		
		
	}
	
	return self;
}

-(void) loadUser: (id) sender
{
	int userID = (int)[sender userData];
	
	DatabaseManager *dbInstance = [[DatabaseManager alloc] init];

	[dbInstance setCurrentUser:userID];
	
	[[CCDirector sharedDirector] popScene];

}

-(void) goBack
{
	[[CCDirector sharedDirector] replaceScene:[OptionScene node]];
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
