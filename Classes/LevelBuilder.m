//
//  Level1.m
//  Incrediballs
//
//  Created by student on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "LevelBuilder.h"
#import "CCTouchDispatcher.h"
#import "game_map.h"
#import "MultipleLayer.h"
#import "Globals.h"
#import "Power.h"
#import "HUD.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "AchievementScene.h"
#import "CCDrawingPrimitives.h"
//For HUD layer



CCSprite *cannon;
CCSprite *cannonBall;
CGPoint cannonOrigin;
float touchBeginDist;
float maxPower;
float powerScalingFactor;
int dampingCounterX;
int dampingCounterY;
float previousYVel;
int powerIndex;
int collectable_X_Pos[16];
int collectable_Y_Pos[16];
BOOL targetHit[16];
float firePower;
float touchStartTime;
float touchEndTime;
float touchStartX;
float touchEndX;
float timeDiff;
CGPoint prevTouchLocation;
int iZoomOffsetX = 250;
CCSprite *spotlight;
BOOL shootStarted;
BOOL isTracerPowerUsed = NO;


enum {
	kTagBatchNode = 1,
	kTagForAngle = 2,
	kTagForPower = 3,
	kTagForVelocity =4, 
	kTagForVlayer =5
	
};

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		// TIP: cocos2d and chipmunk uses the same struct to store it's position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}


cpBody *body;
cpShape *bodyShape;
CCSprite *angleSelector;
CGRect ShootingArea;
int numCollectables;
int numObstacles;
int iEndOfMap;

MultipleLayer *parentLayer;
HUD *hudLayer;
SoundLayer *lSoundLayer;
NSMutableArray *oTracePoints;
int powerButtonAnimateCount[3];


// HelloWorld implementation
@implementation LevelBuilder
@synthesize theMap;
@synthesize bgLayer;
@synthesize revPower;
@synthesize spritePower1;
@synthesize ballFired, ballCount;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	
	LevelBuilder *layer = [LevelBuilder node];
	
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}


static int begin(cpArbiter *arb, cpSpace *space, void *unused)
{
	//NSLog(@"Inside presolve 12423423423423444444554546666661111111111111333334444444444");
	return collPowerFlag;
	
}


-(void) addNewSpriteX: (float)x y:(float)y power:(float)firePower angle:(float)fireAngle
{
	//NSLog(@"insprite");
	
	
	if(ballFired == TRUE)
	{
		// do nothing as ball as been fired already
	}
	else {
		
		ballFired = TRUE;
		ballCount++;
		
		
	
		CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];

	
		CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0, 0, 32, 32)];
		[batch addChild: sprite];
	
		sprite.position = ccp(x,y);

		float ballRadius = 16.0f;
		
		float mass = gBallMass;
		float inertia = cpMomentForCircle(mass,ballRadius,0.0f,CGPointZero);//100.0f;
	
		NSLog(@"Mass : %f, Inertia : %f",mass,inertia);
	
		body = cpBodyNew(mass,inertia);
	// TIP:
	// since v0.7.1 you can assign CGPoint to chipmunk instead of cpVect.
	// cpVect == CGPoint
		//body->p = ccp(x,y);
		body->p = ccp(maxPower*cos(fireAngle) + cannonOrigin.x, maxPower*sin(fireAngle) + cannonOrigin.y );
		
		NSLog(@"angle: %f",fireAngle);
		
		body->v = ccp(powerScalingFactor*firePower*cos(fireAngle),powerScalingFactor*firePower*sin(fireAngle));
		cpSpaceAddBody(space, body);
	
		// setting previous Y velocity for the first time
		previousYVel = powerScalingFactor*firePower*sin(fireAngle);
		
		bodyShape = cpCircleShapeNew(body, ballRadius, CGPointZero);
		bodyShape->e = gBallElasticity; bodyShape->u = gBallFriction;

		
		bodyShape->data = sprite;
		
		
		//add collision type to identify in collsion call back handler
		bodyShape->collision_type=1;
		cpSpaceAddShape(space, bodyShape);
		
		
		[self removeTracePath];
		[self schedule:@selector(callEveryFrame:)];
		
	}
	
}

-(void) reAttempt{
	
	
	
	// reset all powers
	powerIndex=0;
	
	// initialize power used count array
	for (int i=0; i<3; i++) {
		powerUsedCount[i]=0;
		if(powerButtonAnimateCount[i]>0)
		powerButtonAnimateCount[i]=6;
		else 
		powerButtonAnimateCount[i]=0;

		
	}
    
    
	// initialize power used array
	for (int i=0; i<3; i++) {
		powerUsedArray[i]=FALSE;
	}
    
	
    
    // Disable the power if it is a tracer power for the first index only if it used, else enable it once again
    if (gBallPower1 == POWER_TRACER && isTracerPowerUsed) 
    {
        [powerArray[0] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"power4_disabled_1.png"]];
        powerUsedCount[0] = 3;
        powerUsedArray[0] = TRUE;
    }
    else
    {
       	[powerArray[0] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"power%d.png",gBallPower1]]];
    }

    // Disable the power if it is a tracer power for the second index only if it used, else enable it once again
    if(gBallPower2 == POWER_TRACER && isTracerPowerUsed)
    {
        [powerArray[1] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"power4_disabled_1.png"]];
        powerUsedCount[1] = 3;
        powerUsedArray[1] = TRUE;
    }
    else
    {
        [powerArray[1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"power%d.png",gBallPower2]]];
    }
	
	if(targetHit[0] == TRUE)
	{
        if(gBallPower3 == POWER_TRACER && isTracerPowerUsed)
        {
            [powerArray[2] setTexture:[[CCTextureCache sharedTextureCache] addImage:@"power4_disabled_1.png"]];
            powerUsedCount[2] = 3;
            powerUsedArray[2] = TRUE;
        }
        else
        {
            [powerArray[2] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d.png",gBallPower3]]];
        }
	}
	
	//Adjust camera to default view
	[self.camera setCenterX:0 centerY:0 centerZ:0];
	[self.camera setEyeX:0 eyeY:0 eyeZ:1];
	
	//NSLog(@"Works!!!");
	
	// Score label reset to 0/15
	//[gLabelScore setString:@"0/15"];
	
	//Distance label reset to 0
	//[gLabelDistance setString:[NSString stringWithFormat:@"%d",0]];
	
	
	
	[self unschedule:@selector(callEveryFrame:)];
	
	
	dampingCounterX = 0;
	dampingCounterY = 0;
	
	/*
	gPowerButton1.position = ccp(180, -145);
	gPowerButton2.position = ccp(220, -145);
	gPowerButton3.position = ccp(140, -145);
	*/
	 
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	[batch removeAllChildrenWithCleanup:TRUE];
	
	cpBodyDestroy(body);
	cpShapeDestroy(bodyShape);
	cpSpaceRemoveBody(space,body);
	cpSpaceRemoveShape(space,bodyShape);
	
	
	// if still attempts are left
	if (ballCount < 3) {
		
		ballFired = FALSE;
		shootStarted = FALSE;
		
		
		// remove ball left from the HUD
		if (ballCount == 1) {
			NSArray *tempBallItem = [hudLayer ballLeftItem];
			CCMenuItemImage *ballItem1 = (CCMenuItemImage *)[tempBallItem objectAtIndex:1];
			CCMenuItemImage *ballItem0 = (CCMenuItemImage *)[tempBallItem objectAtIndex:0];
			ballItem1.position = ballItem0.position;
		}
		else if (ballCount == 2) {
			[hudLayer removeChild:hudLayer.ballTurnMenu cleanup:YES];
		}
		else {
			NSLog(@"Error: HUD ball left menu error. Ball count is not proper");
		}
		
		firePower = 0.0f;
		//[self setCenterOfScreen:ccp(240,160)];
		id moveAction = [CCMoveTo actionWithDuration:3 position:CGPointZero];
		id moveFrontBackground = [CCMoveTo actionWithDuration:3 position:ccp([frontBackground boundingBox].size.width/2 - iZoomOffsetX,160)];
		id moveBackBackground = [CCMoveTo actionWithDuration:3 position:ccp([backBackground boundingBox].size.width/2 - iZoomOffsetX,160)];		
		
		[self runAction:moveAction];
		[frontBackground runAction:moveFrontBackground];
		[backBackground runAction:moveBackBackground];
		
		// reseting the cannon image to image with ball
		[cannon setTexture:[[CCTextureCache sharedTextureCache] addImage:@"cannon1.png"]];
		cannonBall.position = ccp(227,cannon.contentSize.height/2 + 2);
		
		// bringing in the shoot button
		[hudLayer showShootButton];
	}
	else {
		//[self removeAllChildrenWithCleanup:YES];
		
		
		
		
		// Stop background music
		[lSoundLayer stopBackgroundMusic];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mainTheme.wav"];
		
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeDown transitionWithDuration:1 scene:[AchievementScene node]]];
	}

}

-(void) callEveryFrame:(ccTime)dt{
	
	
	//Update score label of HUD layer
	[gLabelScore setString:[NSString stringWithFormat:@"%d/%d",giItemCollected,gMinItemsToCollect]];
	if (giItemCollected >= gMinItemsToCollect) {
		gLabelScore.color = ccc3(0.0f, 153.0f, 0.0f);;
	}
	
	giScoreRecieved = giItemCollected * 50;
	
	//Update distance label of HUD layer
	//[gLabelDistance setString:[NSString stringWithFormat:@"%d",(int)(body->p.x-cannonOrigin.x)]];
	[gLabelDistance setString:[NSString stringWithFormat:@"%d",giScoreRecieved]];
	
	CGPoint velocity = body->v;
	CGPoint bodyPos = body->p;
	
	float currYVel = velocity.y;
	
	//CGPoint temp = ccp(10.0f,10.0f);
	
	//NSLog(@"X vel : %f",velocity.x);
	
	
	
	// spotlight position update
	spotlight.position=ccp(bodyPos.x,(bodyPos.y-64)/2+64);
	
	//spotlight scale update
	spotlight.scaleY=(bodyPos.y+64)/100;
	// handling all powers
	if (ballFired == TRUE) {
		if (powerIndex == 1 && powerUsedArray[0] == FALSE) {
            if (powerUsedCount[0]<3) {
				NSLog(@"The power used is : %d", gBallPower1);
				
				Power *p1=[[Power alloc] init];
				int oneup=[p1 executePower:body powerID:gBallPower1];
				ballCount+=oneup;
				//body->v = ccp(-velocity.x, velocity.y);
				powerIndex = 0;
				powerUsedArray[0] = TRUE;
				[self schedule:@selector(animatePowerButton1)];
				powerUsedCount[0]++;
                if(gBallPower1 == POWER_TRACER)
                {
                    powerUsedCount[0] = 3;
                    isTracerPowerUsed = YES;
                }
				
			}
			else {
				[powerArray[0] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d_disabled_1.png",gBallPower1]]];
			}

		}
		if (powerIndex == 2 && powerUsedArray[1] == FALSE) {
			
			
			
			if (powerUsedCount[1]<3 ) {
				Power *p2=[[Power alloc] init];
				int oneup=[p2 executePower:body powerID:gBallPower2];
				ballCount+=oneup;
				//body->v = ccp(velocity.x, velocity.y + 200);				
				powerIndex = 0;
				powerUsedArray[1] = TRUE;
				[self schedule:@selector(animatePowerButton2)];
				powerUsedCount[1]++;
                if(gBallPower2 == POWER_TRACER)
                {
                    powerUsedCount[1] = 3;
                    isTracerPowerUsed = YES;
                }
			}
			else {
				[powerArray[1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d_disabled_1.png",gBallPower2]]];
			}
		
		}
		if (powerIndex == 3 && targetHit[0] == TRUE && powerUsedArray[2] == FALSE) {
			
			if (powerUsedCount[2] < 3) {
				
				
				Power *p3=[[Power alloc] init];
				int oneup=[p3 executePower:body powerID:gBallPower3];
				ballCount+=oneup;
				
				powerIndex = 0;
				powerUsedArray[2] = TRUE;
				[self schedule:@selector(animatePowerButton3)];
				powerUsedCount[2]++;
                if(gBallPower3 == POWER_TRACER)
                {
                    powerUsedCount[2] = 3;
                    isTracerPowerUsed = YES;
                }
			}
			else {
				[powerArray[2] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d_disabled_1.png",gBallPower3]]];
			}

		}
	}
	
	
	if (velocity.y < 0.1f && velocity.y > -0.1f) {
		dampingCounterY++;
	}
	
	if (velocity.x < 40 && velocity.x >= -0.1f) {
		dampingCounterX++;
		//NSLog(@"Velocity : %f",velocity.x);
	}
	
	if (velocity.x > -40 && velocity.x <= 0.1f) {
		dampingCounterX++;
		//NSLog(@"Velocity : %f",velocity.x);
	}
	
	if (dampingCounterX >= 100) {
		body->v = ccp(velocity.x - 2, velocity.y);
	
		if (velocity.x <= 0) {
			body->v = ccp(0,velocity.y);
		
		}
		if (dampingCounterY >= 100) {
			[self reAttempt];

		}
	}
	
	// check if the ball is colliding with the collectible power
	
	if(((collectable_X_Pos[0] < bodyPos.x + 20 && collectable_Y_Pos[0] > bodyPos.y - 20) && 
	   (collectable_X_Pos[0] > bodyPos.x - 20 && collectable_Y_Pos[0] > bodyPos.y - 20) &&
	   (collectable_X_Pos[0] < bodyPos.x + 20 && collectable_Y_Pos[0] < bodyPos.y + 20) && 
	   (collectable_X_Pos[0] > bodyPos.x - 20 && collectable_Y_Pos[0] < bodyPos.y + 20) &&
	   targetHit[0] == FALSE) || (shadPowerFlag && (collectable_X_Pos[0] < bodyPos.x + 20) && (collectable_X_Pos[0] > bodyPos.x - 20) && (collectable_Y_Pos[0] < bodyPos.y) && targetHit[0] == FALSE)
	   ){
		targetHit[0] = TRUE;
		
		
		[hudLayer addCollectedPowerButton:gBallPower3];
		// remove the current power from the map
		[self removeChild:revPower cleanup:FALSE];
		
		//powerArray[2].position=ccp(240,revPower.position.y);
		//[powerArray[2] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d.png",gBallPower1]]];
		//[hudLayer addChild:powerArray[2]];
		
		//id moveAction = [CCMoveTo actionWithDuration:1 position:ccp(gPowerButton3.position.x + 240, gPowerButton3.position.y + 160)];
		//[powerArray[2] runAction:moveAction];
		//revPower.scale = 1.5f;
		
		
	}
	
	// check if the ball is colliding with the other collectible objects
	for (int i = 1; i < numCollectables; i++) {
	
		if(((collectable_X_Pos[i] < bodyPos.x + 20 && collectable_Y_Pos[i] > bodyPos.y - 20) && 
		   (collectable_X_Pos[i] > bodyPos.x - 20 && collectable_Y_Pos[i] > bodyPos.y - 20) &&
		   (collectable_X_Pos[i] < bodyPos.x + 20 && collectable_Y_Pos[i] < bodyPos.y + 20) && 
		   (collectable_X_Pos[i] > bodyPos.x - 20 && collectable_Y_Pos[i] < bodyPos.y + 20) &&
		   targetHit[i] == FALSE) || (shadPowerFlag && (collectable_X_Pos[i] < bodyPos.x + 20) && (collectable_X_Pos[i] > bodyPos.x - 20) && (collectable_Y_Pos[i] < bodyPos.y) && targetHit[i] == FALSE)
		   ){
			targetHit[i] = TRUE;
			giItemCollected++;
			
			[lSoundLayer playItemCollectedSound];
			
			[hudLayer animationItemCollected:collectable_Y_Pos[i]];
			
			if (giItemCollected == gMinItemsToCollect) {
				CCSprite *levelCompleteBG = [CCSprite spriteWithFile:@"gray_bg_1.png"];
				levelCompleteBG.position = ccp(240,290);
				levelCompleteBG.scaleX = 4;
				
                if(hudLayer.isTopBarOpen)
                {
                    CCLabelTTF *levelCompleteText = [CCLabelTTF labelWithString:@"Level Cleared !!!" fontName:@"Marker Felt" fontSize:20];
                    levelCompleteText.position = ccp(240,290);
                    levelCompleteText.color = ccc3(0, 153, 0);
                    
                    [hudLayer addChild:levelCompleteText];
                    [levelCompleteText runAction:[CCFadeOut actionWithDuration:2]];
				}
				[hudLayer addChild:levelCompleteBG];
				
				
				[levelCompleteBG runAction:[CCFadeOut actionWithDuration:2]];
			}
			// remove the current power from the map
			[self removeChild:collectable[i] cleanup:FALSE];
		}	
			
	}

	CGPoint curBodyLoc = body->p;
	
	
	if (curBodyLoc.y < 18) {
		
		//Play bounce sound
		[lSoundLayer playBounceSound];
		
		
	}
	
	if (currYVel > 0 && previousYVel < 0) {
		
		//Play bounce sound
		[lSoundLayer playBounceSound];
		
	}
	previousYVel = currYVel;
	
	if (curBodyLoc.y < -32) {
		// do nothing ball felt down
		[self reAttempt];
	}
	else if(curBodyLoc.x > iEndOfMap){
		// do nothing ball crossed map boundary
		[self reAttempt];
	}
	else {

		[self setCenterOfScreen:curBodyLoc];
		[self setScaleOfScreen:curBodyLoc];
		[self addTracePath:curBodyLoc];
	}

	//Display velocity label
	//CCLabelTTF* velocityLabel=(CCLabelTTF*) [[ self getChildByTag:kTagForVlayer] getChildByTag:kTagForVelocity];
	
	//velocityLabel.position=CGPointMake(self.position.x+30, self.position.y+30);
	//[velocityLabel setString:[NSString stringWithFormat:@"%f",body->v.x]];

}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		CGSize wins = [[CCDirector sharedDirector] winSize];
		cpInitChipmunk();
		
		//NSLog(@"MAP Selected : %d",iMapType);
		
		//Power label
		CCLabelTTF* angleLabel=[CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:14];
		
		angleLabel.tag=kTagForAngle;
		angleLabel.position=CGPointMake(50.0f, 260.0f);
		//angleLabel.opacity=0.8;
		
		//Angle label
		CCLabelTTF* powerLabel=[CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:14];
		
		powerLabel.tag=kTagForPower;
		powerLabel.position=CGPointMake(50.0f, 230.0f);
		//powerLabel.opacity=0.8;
		
		// call function to set all the global varible required for the level
		[self setGlobalVariables];
		
		// add angle selector background
		angleSelector = [CCSprite spriteWithFile:@"angleSelector.png"];
		angleSelector.position = ccp(cannonOrigin.x + 90,cannonOrigin.y + 90);
		angleSelector.opacity = 50.0f;
		
		
		cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
		space = cpSpaceNew();
		cpSpaceResizeStaticHash(space, 400.0f, 40);
		cpSpaceResizeActiveHash(space, 100, 600);
		
		space->gravity = ccp(0, -300.0f);
		space->damping = 0.95f;
		//space->elasticIterations = space->iterations;
		space->iterations = 8;
		//NSLog(@"Iteration value = %f",space->iterations);
		
		
		// setup callback handler for collision
		cpSpaceAddCollisionHandler(space, 1, 2, begin, NULL, NULL, NULL, NULL);
		
		
		NSLog(@"Num of balls fired : %d",ballCount);
		
		
		//adding front and back background
		[self addBackground];
		
		
		[self addChild:angleLabel];
		[self addChild:powerLabel];
		
		
		// get map, render objects and apply collisions
		[self setLevelMap];
		
		
		
		
		
		
		
		// top
		//shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height), ccp(theMap.mapSize.width * theMap.tileSize.width,wins.height), 0.0f);
		//shape->e = 1.0f; shape->u = 1.0f;
		//cpSpaceAddStaticShape(space, shape);
		
		cpShape *shape;
		
		// left
		shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,2 * wins.height), 0.0f);
		shape->e = 1.0f; shape->u = 1.0f;
		cpSpaceAddStaticShape(space, shape);
		
		
		//right
		//shape = cpSegmentShapeNew(staticBody, ccp(3920,0), ccp(3920,wins.height), 0.0f);
		//shape->e = floorElasticity; shape->u = floorFriction;
		//cpSpaceAddStaticShape(space, shape);
		CCSprite *cannonBase = [CCSprite spriteWithFile:@"cannon_base.png"];
		cannonBase.position = ccp(cannonOrigin.x - 4,cannonOrigin.y - 13);
		
		
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"ball_%d.png",gBallID] capacity:100];
		
		[self addChild:batch z:1 tag:kTagBatchNode];
		
		
		[self schedule:@selector(getParent) interval:0.1];
		[self schedule: @selector(step:)];
		
		[self addChild:theMap z:0];
		[self addChild:angleSelector];
		[self addChild:cannon];
		[cannon addChild:cannonBall];
		[self addChild:cannonBase];
		
		
		
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
	}
	return self;
}

-(void) setGlobalVariables
{
	
	// spotlight init transparent
	spotlight=[CCSprite spriteWithFile:@"transparent_32_32.png"];
	[self addChild:spotlight z:5];
	
	//collisionpower flag initialize to 1
	collPowerFlag=1;
	shadPowerFlag=0;
	
	// power button animate count array init
	for(int i=0;i<3;i++)
		powerButtonAnimateCount[i]=0;
	
	
	// Globals.h poweUsedCount array initialize
	for(int i=0;i<3;i++)
		powerUsedCount[i]=0;
	
	
	cannonOrigin = ccp(45,100);	// origin of the cannon
	maxPower = 110.0f;			// maximum power allowed
	powerScalingFactor = 8.0f;
	dampingCounterX = 0;
	dampingCounterY = 0;
	ballFired=FALSE;			// if ball is not yet fired its false, if ball is in action its true
	ballCount = 0;
	powerIndex = 0;
	
	giItemCollected = 0;
	
	for (int i = 0; i < numCollectables; i++) {
		
		collectable_X_Pos[i] = 0;
		collectable_Y_Pos[i] = 0;
		targetHit[i] = FALSE;
	}
	
	shootStarted = FALSE;
	
	ShootingArea = CGRectMake(0, 0, cannonOrigin.x + 190, cannonOrigin.y + 190); // this contains angle selector red background
	firePower = 0;
	touchStartTime = 0;
	touchEndTime = 0;
	touchStartX = 0;
	touchEndX = 0;
	timeDiff = 0;
	prevTouchLocation = CGPointZero;
	oTracePoints = [[NSMutableArray alloc] init];
	
}

-(void) setLevelMap
{

	////////////
	// Get map from TMX file
	////////////
	
	self.theMap = [CCTMXTiledMap tiledMapWithTMXFile:[NSString stringWithFormat:@"level_%d_%d.tmx",giMapType,giLevelNumber]];
	
	self.bgLayer = [theMap layerNamed:@"bg"];
	
	
	////////////
	// get the object layer group for collectables
	////////////
	
	CCTMXObjectGroup *collectableGroup = [theMap objectGroupNamed:@"ogCollectable"];
	numCollectables = [collectableGroup.objects count];
	
	// save the x and y value of the objects in array
	for (int i = 0; i < numCollectables; i++) {
		
		NSMutableDictionary *objCollectable = [collectableGroup objectNamed:[NSString stringWithFormat:@"collectable%d",i]];
		collectable_X_Pos[i] = [[objCollectable valueForKey:@"x"]intValue];
		collectable_Y_Pos[i] = [[objCollectable valueForKey:@"y"]intValue];
		
	}
	
	////////
	// get power details
	////////
	
	CCTMXObjectGroup *powerGroup = [theMap objectGroupNamed:@"ogPowerDetail"];
	
	NSMutableDictionary *objPowerDetail = [powerGroup objectNamed:@"power0"];
	int iPowerID = 320 - [[objPowerDetail valueForKey:@"y"]intValue];
	
	// add power sprite in map
	self.revPower = [CCSprite spriteWithFile:[NSString stringWithFormat:@"power%d.png",iPowerID]];
	revPower.position = ccp(collectable_X_Pos[0], collectable_Y_Pos[0]);
	[self addChild:revPower];
	
	// create sprite array for all the other objects on the map
	for (int i = 1; i < numCollectables; i++) {
		
		collectable[i] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"collectable_%d.png",giMapType]];
		collectable[i].position = ccp(collectable_X_Pos[i], collectable_Y_Pos[i]);
		[self addChild:collectable[i]];
		
	}
    
    ////////////
	// get the obstacles
	////////////
    
    CCTMXObjectGroup *obstacleGroup = [theMap objectGroupNamed:@"ogObstacle"];
    numObstacles = [obstacleGroup.objects count];
    
    // save the x and y value for obstacles in array
    for (int i = 0; i < numObstacles; i++) {
        
        NSMutableDictionary *objObstacle = [obstacleGroup objectNamed:[NSString stringWithFormat:@"obstacle%d", i]];
        int obstacle_X_Pos = [[objObstacle valueForKey:@"x"] intValue]/32;
        int obstacle_Y_Pos = [[objObstacle valueForKey:@"y"] intValue]/32;
        
        NSLog(@"Obs X pos : %d and Y pos : %d", obstacle_X_Pos, obstacle_Y_Pos);
        
        // Create collision for each platform
		[self addPlatformCollision:obstacle_X_Pos endTile:(obstacle_X_Pos+1) height:obstacle_Y_Pos];
    }
	
	////////////
	// get the object layer group for platform
	////////////
	
	CCTMXObjectGroup *platformGroup = [theMap objectGroupNamed:@"ogPlatform"];
	
	int numPlatform = [platformGroup.objects count]/2;
	
	
	// save the x and y value of tile for each platform and add collision to it
	for (int i = 0; i < numPlatform; i++) {
		
		NSMutableDictionary *objPlatformStart = [platformGroup objectNamed:[NSString stringWithFormat:@"start%d",i]];
		int iStartPosX = [[objPlatformStart valueForKey:@"x"]intValue]/32;
		int iStartPosY = [[objPlatformStart valueForKey:@"y"]intValue]/32;
		
		NSMutableDictionary *objPlatformEnd = [platformGroup objectNamed:[NSString stringWithFormat:@"end%d",i]];
		int iEndPosX = [[objPlatformEnd valueForKey:@"x"]intValue]/32 + 1;
		//int iEndPosY = [[objPlatformEnd valueForKey:@"y"]intValue]/32; //Since StartY and EndY are same we don't need this 
		
		// Create collision for each platform
		[self addPlatformCollision:iStartPosX endTile:iEndPosX height:iStartPosY];
	}
	
	////////////
	// get end of map position
	////////////
	
	CCTMXObjectGroup *endOfMap = [theMap objectGroupNamed:@"ogEndOfMap"];
	iEndOfMap =  [[[endOfMap objectNamed:@"endMap"] valueForKey:@"x"] intValue];
	
	////////////
	// get power to be collected in the map
	////////////
	
	CCTMXObjectGroup *powerID = [theMap objectGroupNamed:@"ogPowerDetail"];
	gBallPower3 = 320-[[[powerID objectNamed:@"power0"] valueForKey:@"y"] intValue];
	
	////////////
	// set cannon and ball's initial position
	////////////
	
	cannon = [CCSprite spriteWithFile:@"cannon1.png"];
	cannon.position = cannonOrigin;
	
	cannonBall = [CCSprite spriteWithFile:[NSString stringWithFormat:@"ball_%d.png",gBallID]];
	cannonBall.position = ccp(227,cannon.contentSize.height/2 + 2);
	
}

-(void) addBackground{

	frontBackground = [BackgroundMap spriteWithFile:[NSString stringWithFormat:@"bg_front_%d.png",giMapType]];
	backBackground = [BackgroundMap spriteWithFile:[NSString stringWithFormat:@"bg_back_%d.png",giMapType]];
	
	frontBackground.position = ccp([frontBackground boundingBox].size.width/2 - iZoomOffsetX,160);
	backBackground.position = ccp([backBackground boundingBox].size.width/2 - iZoomOffsetX,160);
	
	[self addChild:backBackground];
	[self addChild:frontBackground];

}

-(void) getParent {
	//NSLog(@"Comes here!!!!");
	[self unschedule:@selector(getParent)];
	NSLog(@"Inside get parent: needs to un comment the code");
	
	// get parent layer
	parentLayer = (MultipleLayer*)self.parent;

	// get sound layer
	lSoundLayer = [parentLayer getSoundLayer];
	
	// get HUD layer
	hudLayer = [parentLayer getHUDLayer];
	
	//[hudLayer addChild:spritePower1];
	
	//NSLog(@"Found");
	
}

-(void) animatePowerButton1{
	
	powerIndex = 0;
		
	[self unschedule:@selector(animatePowerButton1)];
	
	powerButtonAnimateCount[0]++;
	
	if (powerUsedCount[0] == 3)
	{
		[powerArray[0] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"power%d_disabled_1.png",gBallPower1]]];
	}
	else
	{
		if(powerButtonAnimateCount[0] <= 6)
		{
			//NSLog(@"********************!!!!!!!!!!!!!####################$$$$$$$$$$$$$$$$$$$$$!!!!!!!!!!@@@@@@@@@inside condition of animatePowerButton%d",powerButtonAnimateCount);
			[powerArray[0] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d_disabled_%d.png",gBallPower1,powerButtonAnimateCount[0]]]];
			//spritePower1.position=ccp(gPowerButton1.position.x,gPowerButton1.position.y);
			
			[self schedule:@selector(animatePowerButton1) interval:0.6];
			
		}
		if(powerButtonAnimateCount[0] == 7)
		{
			[self unschedule:@selector(animatePowerButton1)];
			[powerArray[0] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d.png",gBallPower1]]];
			powerUsedArray[0] = FALSE;
			powerButtonAnimateCount[0] = 0;
			if(gBallPower1==4)
				collPowerFlag=1;
			
			if(gBallPower1==5)
				shadPowerFlag=0;
		}
	}
}

-(void) animatePowerButton2{
	
	powerIndex = 0;
	
	[self unschedule:@selector(animatePowerButton2)];
	
	powerButtonAnimateCount[1]++;

	if (powerUsedCount[1] == 3)
	{
		[powerArray[1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat: @"power%d_disabled_1.png",gBallPower2]]];
	}
	else
	{
	
	
		if(powerButtonAnimateCount[1] <= 6)
		{
			[powerArray[1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d_disabled_%d.png",gBallPower2,powerButtonAnimateCount[1]]]];
			//spritePower1.position=ccp(gPowerButton1.position.x,gPowerButton1.position.y);
			
			[self schedule:@selector(animatePowerButton2) interval:0.6];
			
		}
		if(powerButtonAnimateCount[1] == 7)
		{
			
			[powerArray[1] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d.png",gBallPower2]]];
			powerUsedArray[1] = FALSE;
			powerButtonAnimateCount[1] = 0;
			if(gBallPower2==4)
				collPowerFlag=1;
			
			if(gBallPower2==5)
				shadPowerFlag=0;
		}
	}
}



-(void) animatePowerButton3{
	
	powerIndex = 0;
	
	[self unschedule:@selector(animatePowerButton3)];

	powerButtonAnimateCount[2]++;
	
	
	if (powerUsedCount[2] == 3)
	{
		[powerArray[2] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d_disabled_1.png",gBallPower3]]];
	}
	else
	{
	
		if(powerButtonAnimateCount[2] <= 6)
		{
			[powerArray[2] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d_disabled_%d.png",gBallPower3,powerButtonAnimateCount[2]]]];
			//spritePower1.position=ccp(gPowerButton1.position.x,gPowerButton1.position.y);
			
			[self schedule:@selector(animatePowerButton3) interval:0.6];
			
		}
		if(powerButtonAnimateCount[2] == 7)
		{
			
			[powerArray[2] setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"power%d.png",gBallPower3]]];
			powerUsedArray[2] = FALSE;
			powerButtonAnimateCount[2] = 0;
			if(gBallPower3==4)
				collPowerFlag=1;
			
			if(gBallPower3==5)
				shadPowerFlag=0;
		}
	}
}



-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
	
	// this update function is called every frame
	
	// following code is for scrolling the map based on touch start and end time
	
	int deltaScalingFactor = 3000;
	float speedFactor = 0.01f;
	
	//NSLog(@"Time Diff : %f",timeDiff);
	
	if ((touchEndX - touchStartX) < 0 && timeDiff < 0) {
		
		int diffToBeAdded = dt * deltaScalingFactor;
		CGPoint curLocation = ccp(prevTouchLocation.x,160);
		
		if (timeDiff + diffToBeAdded > 0) {
			timeDiff = 0;
		}
		else {
			timeDiff += diffToBeAdded;
			curLocation.x += speedFactor * timeDiff;
			
			//NSLog(@"####### %f",curLocation.x);
			
			// call scrolling map function to see the map
			[self scrollMapBySlide:curLocation];
			//prevTouchLocation = curLocation;
		}

		
		
	}
	if ((touchEndX - touchStartX) > 0 && timeDiff > 0) {
		
		int diffToBeSubtracted = dt * deltaScalingFactor;
		CGPoint curLocation = ccp(prevTouchLocation.x,160);
		
		if (timeDiff - diffToBeSubtracted < 0) {
			timeDiff = 0;
		}
		else {
			timeDiff -= diffToBeSubtracted;
			curLocation.x += speedFactor * timeDiff;
			
		
			// call scrolling map function to see the map
			[self scrollMapBySlide:curLocation];
		
			//prevTouchLocation = curLocation;
		}
	}

}

-(void) setCenterOfScreen:(CGPoint) position{
	
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	
	int x = MAX(position.x , screenSize.width/2);
	int y = MAX(position.y , screenSize.height/2);
	
	//float camNewY = y;
	
	//x = MIN(x,theMap.mapSize.width * theMap.tileSize.width - screenSize.width/2);
	x = MIN(x,iEndOfMap - screenSize.width/2);
	y = MIN(y, theMap.mapSize.height * theMap.tileSize.height - screenSize.height/2);
	
	/*

	// Initially the above x and y were used for the camPoint below but to solve the zoom problem in x direction (zooming done by setScaleOfScreen function) following value is added to the x depending upon the ball's height
	// For how I got the following formula refer setScaleOfScreen function
	*/
	//float camAddX = (0.866*(camNewY + 50 - screenSize.height))/(2*0.577);
	CGPoint camPoint = ccp(x,y);
	
	/*
	if ((camNewY + 50) > screenSize.height) {
		camPoint = ccp(x - camAddX,y);
		
	}
	 */

	
	
	CGPoint centerOfScreen = ccp(screenSize.width/2, screenSize.height/2);
	
	CGPoint difference = ccpSub(centerOfScreen, camPoint);
	
	self.position = difference;
	
	// Also check if we needs to move background
	
	[self moveBackground:camPoint diffPos:difference];
	
	//NSLog(@"X : %f, %f, Y : %f,%f",position.x,difference.x,position.y,difference.y);
	
}

-(void) setScaleOfScreen:(CGPoint) position{

	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	
	int y = MAX(position.y , screenSize.height/2);
	
	// add 50 to give padding on top for ball
	y = y + 50;
	
	// the new y position is the height of the ball from the bottom of the screen which is equal to double the height of the ball from the center of the screen
	
	// so y value for the camera is equal to the half of the distance of the ball above screen height ie. new y - screen height / 2
	
	// x : y : z =  root 3 by 2 : root 3 by 3 : 1
	// approx x : y : z  = 0.866 : 0.577 : 1
	
	float camY = (y - screenSize.height)/2;
	float camZ = camY / 0.577;
	float camMaxY = screenSize.height/2;
	//float camX = camZ * 0.866;
	
	if (y > 4*camMaxY) {
		[self.camera setCenterX:0 centerY:camMaxY centerZ:0];
		[self.camera setEyeX:0 eyeY:camMaxY eyeZ:camMaxY/0.577];
	}
	else if (y > screenSize.height) {
		
			[self.camera setCenterX:0 centerY:camY centerZ:0];
			[self.camera setEyeX:0 eyeY:camY eyeZ:camZ];

	}
	else
	{
			[self.camera setCenterX:0 centerY:0 centerZ:0];
			[self.camera setEyeX:0 eyeY:0 eyeZ:1];
		
	}
	 
	
	//NSLog(@"HEIGHT : %d,%d",theMap.position.x,theMap.position.y);
}

-(void) addTracePath:(CGPoint) position {

	static int frameCount = 0;
	
	frameCount++;
	
	if (frameCount % 3 == 0) {
		
		CCSprite *tracePoint = [CCSprite spriteWithFile:@"tracePath_10_10.png"];
		tracePoint.position = position;
		tracePoint.scale = 0.5;
		
		[oTracePoints addObject:tracePoint];
		
		[self addChild:tracePoint];
	}
}

-(void) removeTracePath {

	// remove all the tracepoints of the previous path from the layer
	for (CCSprite *b in oTracePoints) {
		
		[self removeChild:b cleanup:NO];
		
	}
	
	// empty out point-storing array
	[oTracePoints removeAllObjects];
	
}

-(void) powerUsed {
	

	if (ballFired == TRUE) {
		powerIndex = 1;
	}
	else
		powerIndex = 0;
	
}

-(void) powerUsed2 {
	
	if (ballFired == TRUE) {
		powerIndex = 2;
	}
	else 
		powerIndex = 0;
	
}

-(void) powerUsed3 {
	
	if (ballFired == TRUE) {
		powerIndex = 3;
	}
	else
		powerIndex = 0;
	
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	
	self.theMap = nil;
	self.bgLayer = nil;
	self.revPower = nil;
	//NSLog(@"Inside Dealloc");
	cpSpaceFree(space);
	[super dealloc];
}

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	// tracking the current time when touch begin
	touchStartTime = [event timestamp];
	touchStartX = touchLocation.x;
	
	// call rotation function to track the current orientation of the cannon
	[self changeRotationAnimation:touchLocation];
	
	// call calculate function to calculate the power to be applied based on the current touch location
	[self calculatePowerForTouch:touchLocation];
	
	//setting the start of the touch location
	prevTouchLocation = touchLocation;
	
	// call scrolling map function to see the map
	//[self scrollMapBySlide:touchLocation];
	
	//display image at touch position
	//[self displayTouchImage:touchLocation];
	
	return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint curLocation = [touch locationInView: [touch view]];
	curLocation = [[CCDirector sharedDirector] convertToGL:curLocation];
	
	// call rotation function to track the current orientation of the cannon
	[self changeRotationAnimation:curLocation];

	// call calculate function to calculate the power to be applied based on the current touch location
	[self calculatePowerForTouch:curLocation];
	
	//NSLog(@"$$$$$$$$ %f",curLocation.x);
	// call scrolling map function to see the map
	[self scrollMapBySlide:curLocation];
	
	//[self displayTouchImage:curLocation];
	
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	
	if (touchLocation.x > (cannonOrigin.x + [angleSelector boundingBox].size.width)) {
		//[self shootBall];
		// commented above line as now the shoot function is being called from the hud
	}
	
	// tracking the timestamp when touch ended 
	touchEndTime = [event timestamp];
	touchEndX = touchLocation.x;
	prevTouchLocation = touchLocation;
	
	timeDiff = (touchEndX - touchStartX)/(touchEndTime - touchStartTime);
}

-(void) displayTouchImage: (CGPoint) position
{
	CCSprite *touchImage = [CCSprite spriteWithFile:@"redTouch.png"];
	touchImage.position = position;
	touchImage.scale = 0.3;
	[self addChild:touchImage];
	
	id scaleDownAction = [CCScaleTo actionWithDuration:1.0f scale:0.0f]; 
	id fadeOutAction = [CCFadeOut actionWithDuration:1.0f];
	[touchImage runAction:[CCSpawn actions:fadeOutAction,scaleDownAction,nil]];
	
}

-(void) shootBall {

	if (firePower > 2) {

		shootStarted = TRUE;
		
		firePower /= 1.2;
		
		// removing the shoot button
		[hudLayer hideShootButton];
		
		//set the cannon's image without ball
		[cannon setTexture:[[CCTextureCache sharedTextureCache] addImage:@"cannon13.png"]];
		cannonBall.position = ccp(115,cannon.contentSize.height/2 + 5);
		
		float animationInterval = firePower/(float)maxPower;
		[self schedule:@selector(fireBall) interval:animationInterval];
		
	}
	
	
}

-(void) fireBall
{
	[self unschedule:@selector(fireBall)];

	CGFloat convertedAngle = -cannon.rotation;
	CGFloat angle = CC_DEGREES_TO_RADIANS(convertedAngle);

	[lSoundLayer playShootSound];
	
	[cannon setTexture:[[CCTextureCache sharedTextureCache] addImage:@"cannon12.png"]];
	cannonBall.position = ccp(-232,cannon.contentSize.height/2);
	
	
	CCSprite *smoke = [CCSprite spriteWithFile:@"smoke.png"];
	float smokeScale = firePower/60.0f;
	
	if (smokeScale <= 0.7) {
		smokeScale = 0.7;
	}
	smoke.scale = smokeScale;
	
	smoke.position = ccp(250 + smokeScale*20,cannon.position.y/2);
	[cannon addChild:smoke];
	
	[smoke runAction:[CCFadeOut actionWithDuration:3.0f]];
	
	[self addNewSpriteX: cannonOrigin.x y:cannonOrigin.y power:firePower angle:angle];
}


#define kFilterFactor 0.05
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration{
	static float prevX=0, prevY=0;
	float accFactor = 200.0f;
	
	float accelX = acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	//float diffX = accelX - prevX;
	float diffY = accelY - prevY;
	float powerToBeAdded = accFactor * diffY;
	
	//to provide the acceleration to the power
	float upperBound = 1.0f;
	float threshold = 0.35f;
	float lowerBound = 0.0f;
	
	if (powerToBeAdded > threshold || powerToBeAdded < -threshold) {
		//NSLog(@"power to be added : %f",powerToBeAdded);
	}
	
	
	if (powerToBeAdded > upperBound || powerToBeAdded < -upperBound) {
		//firePower = firePower + 3 * powerToBeAdded;
	}
	else if((powerToBeAdded < lowerBound && powerToBeAdded > -threshold) || (powerToBeAdded > lowerBound && powerToBeAdded < threshold)){
		firePower = firePower;
	}
	else if(powerToBeAdded > threshold){
		//firePower = firePower + 1;
	}
	else if(powerToBeAdded < -threshold){
		//firePower = firePower - 1;
	}
	
	
	prevX = accelX;
	prevY = accelY;
	
	[self changePowerAnimation];
	
}



-(void) changeRotationAnimation: (CGPoint)touchLocation{
	
	CGPoint checkPoint = ccp(ShootingArea.origin.x + cannonOrigin.x,cannonOrigin.y);
	CGPoint distLine = ccpSub( touchLocation,checkPoint);
	CGFloat radAngle = ccpToAngle(distLine);
	CGFloat angle = CC_RADIANS_TO_DEGREES(radAngle);
    
	//distance between the touch and the center of the cannon
	float touchDist = ccpDistance(touchLocation, cannon.position);
	
	// width of the angle selector red background
	int iWidth = [angleSelector boundingBox].size.width;
	
	// first part make sure the touch is inside the shooting area to track either angle or power; the second part is for tracking the angle
	// the last condition is to check whether the screen as been scroll or not, 10 is the extra allowance in case the screen is not exactly at the start position
	if (CGRectContainsPoint(ShootingArea, touchLocation) && (iWidth > touchDist && (iWidth - 75) < touchDist ) ) {
		if (angle >= 90) {
			angle = 90;
		}
		else if (angle <= 0) {
			angle = 0;
		}
		
		if (ballFired == FALSE) {
			
			//set cannon to current touch orientation
			cannon.rotation = -angle;
			
			//Display angle label
			CCLabelTTF* angleLabel=(CCLabelTTF*) [ self getChildByTag:kTagForAngle];
			[angleLabel setString:[NSString stringWithFormat:@"%d'",(int)angle]];
			
		}
	}
}


-(void) calculatePowerForTouch: (CGPoint)touchLocation{

	CGPoint checkPoint = ccp(ShootingArea.origin.x + cannonOrigin.x,cannonOrigin.y);
	
	//distance between the touch and the center of the cannon
	float touchDist = ccpDistance(touchLocation, checkPoint);
	
	// width of the angle selector red background
	int iWidth = [angleSelector boundingBox].size.width;
	
	// first part make sure the touch is inside the shooting area to track either angle or power; the second part is for tracking the power
	if (CGRectContainsPoint(ShootingArea, touchLocation) && ((iWidth - 75) > touchDist) && touchLocation.x >= checkPoint.x) {
		firePower = maxPower - touchDist;
		
		// call animation function to change the animation of the cannon
		[self changePowerAnimation];
	}

}

-(void) scrollMapBySlide: (CGPoint)touchLocation{
	
	float moveDistance = prevTouchLocation.x - touchLocation.x;
	CGPoint curMapLocation = self.position;
	CGPoint newMapLocation;
	
	//NSLog(@"CUR MAP LOC: %f , moveDistance : %f",(cannon.position.x), cannon.contentSize.width/2);
	
	if(CGRectContainsPoint(ShootingArea, touchLocation) == NO)
	{
		float newX = -curMapLocation.x + moveDistance + 240; // added 240 because setCenterOfScreen takes min of 240 and this new number, without adding 240, this new number will always be less then that and thus map does not move
		newMapLocation = ccp(newX,curMapLocation.y);
		
		//NSLog(@"curMapLocation: %f newMapLocation : %f",curMapLocation.x, newMapLocation.x);
		
		[self setCenterOfScreen:newMapLocation];
		
		
	}
	prevTouchLocation = touchLocation;

}

-(void) changePowerAnimation{

	if (firePower <= 0) {
		firePower = 0;
	}
	if (firePower >= maxPower) {
		firePower = maxPower;
	}
	
	// Changing the image orientation; imageIndex give the int value to select which image to be displaced
	int imageIndex = firePower / 10 + 1;
	
	if (firePower == maxPower) {
		imageIndex = imageIndex - 1;
	}
	
	//Change the cannon animation as per magnitude of power
	if (ballFired == FALSE && shootStarted == FALSE) {
		[cannon setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"cannon%d.png",imageIndex]]]; //[CCSprite spriteWithFile:[NSString stringWithFormat:@"cannon%d.png",imageIndex]];
	
		int ballPosY = cannon.contentSize.height/2 + 1;
		// Following code is just a hardcoded value for EA presentation needs to have better method for it
		switch (imageIndex) {
			case 1:
				cannonBall.position = ccp(227,ballPosY + 1);
				break;
			case 2:
				cannonBall.position = ccp(224,ballPosY + 1);
				break;
			case 3:
				cannonBall.position = ccp(217,ballPosY + 1);
				break;
			case 4:
				cannonBall.position = ccp(211,ballPosY);
				break;
			case 5:
				cannonBall.position = ccp(204,ballPosY);
				break;
			case 6:
				cannonBall.position = ccp(201,ballPosY);
				break;
			case 7:
				cannonBall.position = ccp(194,ballPosY);
				break;
			case 8:
				cannonBall.position = ccp(185,ballPosY);
				break;
			case 9:
				cannonBall.position = ccp(178,ballPosY + 1);
				break;
			case 10:
				cannonBall.position = ccp(165,ballPosY + 1);
				break;
			case 11:
				cannonBall.position = ccp(160,ballPosY + 1);
				break;
			default:
				break;
		}
		

		//Display power label
		CCLabelTTF* powerLabel=(CCLabelTTF*) [ self getChildByTag:kTagForPower];
		[powerLabel setString:[NSString stringWithFormat:@"%d%%",(int)(firePower/1.1f)]];
	}
}

-(void) moveBackground: (CGPoint) position diffPos: (CGPoint) difference{

	int frontScaleDown = 4; // to slow down by this factor
	int backScaleDown = 10;
	
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	//CGPoint newDiff = ccp(difference.x - screenSize.width/2,difference.y);
	
	// following two are the new value of the background image's position
	float newFrontPositionX = [frontBackground boundingBox].size.width/2 + position.x + difference.x/frontScaleDown - screenSize.width/2;
	float newBackPositionX = [backBackground boundingBox].size.width/2 + position.x + difference.x/backScaleDown - screenSize.width/2;
	
	//NSLog(@"OLD X : %f %f",newBackPositionX,newFrontPositionX);
	
	// if the map is at the start position then fix the position of the background to its original position to avoid moving it to extra towards right hence avoiding the blank background at the left border
	if (self.position.x >= -0.0f) {
		newFrontPositionX = frontBackground.contentSize.width/2;
		newBackPositionX = [backBackground contentSize].width/2;
	}
	
	//NSLog(@"NEW X : %f %f",newBackPositionX,newFrontPositionX);
	
	frontBackground.position = ccp(newFrontPositionX - iZoomOffsetX,160);
	backBackground.position = ccp(newBackPositionX - iZoomOffsetX,160);
	
	//NSLog(@"Current X : %f %f %f",frontBackground.position.x,backBackground.position.x,self.position.x);
	
	// Following code is for moving the Shooting Area
	float newShootingAreaX = self.position.x;
	
	ShootingArea.origin.x = newShootingAreaX;
}

-(void) addPlatformCollision:(int)startTile endTile:(int)endTile height:(int)iHeight {

	cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
	cpShape *shape;
	
	float tileSize = theMap.tileSize.height; // hieght of the tile which is 32 px in our case
	float floorElasticity = 1.0f; // elasticity for the floor right now its same for all the surfaces but in future we can parameterize
	float floorFriction = 1.0f;
	float radius = tileSize / 2; // thickness using this radius so effective thickness of the plateform will be 32
	
	// here we are setting up a rectangle with curve sides so start and end points will be center of the height
	NSLog(@"Start pos for obstacle : %d and end pos for obstacle %d", startTile, endTile);
	shape = cpSegmentShapeNew(staticBody, ccp(startTile * tileSize + radius,iHeight * tileSize + radius), ccp(endTile * tileSize - radius + 1,iHeight * tileSize + radius), radius); // added the value 1 to the end in order to create at least one pixel of line, this was an issue for the obstacles.
	shape->e = floorElasticity; shape->u = floorFriction;
	shape->surface_v = ccp(0,0);
	
	// setup callback handler for collision
	if(iHeight<=1)
        shape->collision_type=20;
	else
		shape->collision_type=2;	

	
	// Add to space
	cpSpaceAddStaticShape(space, shape);
}


@end
