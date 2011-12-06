//
//  MainMenu.m
//  Cracker
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"

const float PTM_RATIO = 32.0f;

const int TILESIZE = 32;
const int TILESET_COLUMNS = 9;
const int TILESET_ROWS = 19;


@interface MainMenu (PrivateMethods)

- (void)menuCallback:(id)sender;
- (void)menuCallback2:(id)sender;
- (void)menuCallbackDisabled:(id)sender;
- (void)menuCallbackEnable:(id)sender;
- (void)enableBox2dDebugDrawing;
- (void)activate;
@end


@implementation MainMenu

- (void)dealloc
{
    [super dealloc];
    delete world;
}
- (id)init
{
    if ((self = [super init])){
        
        world = new b2World(b2Vec2(0.0f, 0.0f));
        world->SetAllowSleeping(NO);
        
        worldStatic = YES;
        //[self enableBox2dDebugDrawing];
        
        // for the screenBorder body we'll need these values
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		float widthInMeters = screenSize.width / PTM_RATIO;
		float heightInMeters = screenSize.height / PTM_RATIO;
		b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
		b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
		b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
		b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
		
		// Define the static container body, which will provide the collisions at screen borders.
		b2BodyDef screenBorderDef;
		screenBorderDef.position.Set(0, 0);
		b2Body* screenBorderBody = world->CreateBody(&screenBorderDef);
		b2EdgeShape screenBorderShape;
        
		// Create fixtures for the four borders (the border shape is re-used)
		screenBorderShape.Set(lowerLeftCorner, lowerRightCorner);
		screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(0.8);
		screenBorderShape.Set(lowerRightCorner, upperRightCorner);
		screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(0.8);
		screenBorderShape.Set(upperRightCorner, upperLeftCorner);
		screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(0.8);
		screenBorderShape.Set(upperLeftCorner, lowerLeftCorner);
		screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(0.8);
        
		[CCMenuItemFont setFontSize:30];
		[CCMenuItemFont setFontName: @"Courier New"];
        
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        self.isTouchEnabled = YES;
#endif
        
        CCMenuItemFont *item0 = [CCMenuItemFont itemFromString:@"Start"
                                                        target:self
                                                      selector:@selector(gameStart:)];
        
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"Config"
                                                        target:self
                                                      selector:@selector(gameConfig:)];
        CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:@"About"
                                                        target:self
                                                      selector:@selector(gameAbout:)];
        
		// Font Item
		
		CCSprite *spriteNormal = [CCSprite spriteWithFile:@"menuitemsprite.png" 
                                                     rect:CGRectMake(0,23*2,115,23)];
		CCSprite *spriteSelected = [CCSprite spriteWithFile:@"menuitemsprite.png" 
                                                       rect:CGRectMake(0,23*1,115,23)];
		CCSprite *spriteDisabled = [CCSprite spriteWithFile:@"menuitemsprite.png" 
                                                       rect:CGRectMake(0,23*0,115,23)];
		CCMenuItemSprite *item3 = [CCMenuItemSprite itemFromNormalSprite:spriteNormal 
                                                          selectedSprite:spriteSelected 
                                                          disabledSprite:spriteDisabled 
                                                                  target:self 
                                                                selector:@selector(menuCallback:)];
        disabledItem = item3;
		// Image Item
		CCMenuItem *item4 = [CCMenuItemImage itemFromNormalImage:@"SendScoreButton.png" 
                                                   selectedImage:@"SendScoreButtonPressed.png" 
                                                          target:self 
                                                        selector:@selector(menuCallback2:)];
        
		// Label Item (LabelAtlas)
		CCLabelAtlas *labelAtlas = [CCLabelAtlas labelWithString:@"0123456789" 
                                                     charMapFile:@"fps_images.png" 
                                                       itemWidth:16
                                                      itemHeight:24 
                                                    startCharMap:'.'];
        
		CCMenuItemLabel *item5 = [CCMenuItemLabel itemWithLabel:labelAtlas
                                                         target:self 
                                                       selector:@selector(menuCallbackDisabled:)];
		item5.disabledColor = ccc3(32,32,64);
		item5.color = ccc3(200,200,255);
		
        
		// Font Item
		CCMenuItemFont *item6 = [CCMenuItemFont itemFromString: @"I toggle enable items"
                                                        target: self 
                                                      selector:@selector(menuCallbackEnable:)];
		
		[item6 setFontSize:20];
		[item6 setFontName:@"Marker Felt"];
		
		
		CCTintBy* color_action = [CCTintBy actionWithDuration:0.5f red:0 green:-255 blue:-255];
		id color_back = [color_action reverse];
		id seq = [CCSequence actions:color_action, color_back, nil];
		[item6 runAction:[CCRepeatForever actionWithAction:seq]];
        
		menu = [CCMenu menuWithItems:item0, item1, item2, item3, item4, item5, item6, nil];
		[menu alignItemsVertically];
		
        CGSize s = [[CCDirector sharedDirector] winSize];
        int i=0;
        for( CCNode *child in [menu children] ) {
            CGPoint dstPoint = child.position;
            
            int offset = s.width/2 + 20;
            if( i % 2 == 0)
                offset = -offset;
            
            child.position = ccp( dstPoint.x + offset, dstPoint.y);
            i++;
        }
        
		[self addChild: menu];
        
        [self scheduleUpdate];
		
		[KKInput sharedInput].accelerometerActive = YES;
    }
    return self;
}

#pragma mark - Methods

- (void)gameStart:(id)sender
{
    CCDirector *dir = [CCDirector sharedDirector];
    [dir replaceScene:[CCTransitionSlideInR transitionWithDuration:0.3f
                                                             scene:[GameScene node]]];
    
}

- (void)gameConfig:(id)sender
{
    
}

- (void)gameAbout:(id)sender
{
    
}

#pragma mark - PrivateMethods

- (void)menuCallback:(id)sender
{
    
}

- (void)menuCallback2:(id)sender
{
    
}

- (void)menuCallbackDisabled:(id)sender
{
    disabledItem.isEnabled = NO;
}

- (void)menuCallbackEnable:(id)sender
{
    disabledItem.isEnabled = !disabledItem.isEnabled;
}

// convenience method to convert a CGPoint to a b2Vec2
-(b2Vec2) toMeters:(CGPoint)point
{
	return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}

// convenience method to convert a b2Vec2 to a CGPoint
-(CGPoint) toPixels:(b2Vec2)vec
{
	return ccpMult(CGPointMake(vec.x, vec.y), PTM_RATIO);
}

-(void) enableBox2dDebugDrawing
{
	float debugDrawScaleFactor = 1.0f;
#if KK_PLATFORM_IOS
	debugDrawScaleFactor = [[CCDirector sharedDirector] contentScaleFactor];
#endif
	debugDrawScaleFactor *= PTM_RATIO;
	
	debugDraw = new GLESDebugDraw(debugDrawScaleFactor);
	
	if (debugDraw)
	{
		UInt32 debugDrawFlags = 0;
		debugDrawFlags += b2Draw::e_shapeBit;
		debugDrawFlags += b2Draw::e_jointBit;
		//debugDrawFlags += b2Draw::e_aabbBit;
		//debugDrawFlags += b2Draw::e_pairBit;
		//debugDrawFlags += b2Draw::e_centerOfMassBit;
		
		debugDraw->SetFlags(debugDrawFlags);
		world->SetDebugDraw(debugDraw);
	}
}

- (void)activate
{
    worldStatic = NO;
}

#pragma mark - Overrided Methods

- (void)update:(ccTime)delta
{
	CCDirector* director = [CCDirector sharedDirector];
    
    KKInput* input = [KKInput sharedInput];
    if (director.currentDeviceIsSimulator == NO)
    {
        KKAcceleration* acceleration = input.acceleration;
        b2Vec2 gravity = 10.0f * b2Vec2(acceleration.rawX, acceleration.rawY);
        world->SetGravity(gravity);
    }
    
	
	// The number of iterations influence the accuracy of the physics simulation. With higher values the
	// body's velocity and position are more accurately tracked but at the cost of speed.
	// Usually for games only 1 position iteration is necessary to achieve good results.
    if (!worldStatic){
        
        float timeStep = 0.03f;
        int32 velocityIterations = 2;
        int32 positionIterations = 1;
        world->Step(timeStep, velocityIterations, positionIterations);
        
        // for each body, get its assigned sprite and update the sprite's position
        for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
        {
            CCSprite* sprite = (__bridge CCSprite*)body->GetUserData();
            if (sprite != NULL)
            {
                // update the sprite's position to where their physics bodies are
                sprite.position = ccpSub([self toPixels:body->GetPosition()],menu.position);;
                float angle = body->GetAngle();
                sprite.rotation = CC_RADIANS_TO_DEGREES(angle) * -1;
            }
        }
    }
}

#if DEBUG
-(void) draw
{
	[super draw];
    
	if (debugDraw)
	{
		// these GL states must be disabled/enabled otherwise drawing debug data will not render and may even crash
		glDisable(GL_TEXTURE_2D);
		glDisableClientState(GL_COLOR_ARRAY);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		world->DrawDebugData();
		
		glDisableClientState(GL_VERTEX_ARRAY);   
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnableClientState(GL_COLOR_ARRAY);
		glEnable(GL_TEXTURE_2D);	
	}
}
#endif

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    // elastic effect
    ccTime duration = 2.0f;

    int i=0;
    for( CCNode *child in [menu children] ) {
        CGPoint dstPoint = child.position;
        dstPoint.x = 0;
        [child runAction: 
         [CCEaseElasticOut actionWithAction: 
          [CCMoveTo actionWithDuration:duration
                              position:dstPoint]
                                     period: 0.35f]];
        i++;
        
        /*=============== Add Bodies =================*/
        b2Body *body;
        b2BodyDef bodyDef;
        bodyDef.position = [self toMeters:ccpAdd(dstPoint,menu.position)];
        bodyDef.type = b2_dynamicBody;
        bodyDef.userData = child;
        body = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic bodies.
        b2PolygonShape dynamicBox;
        CGSize bound = child.contentSize;
        dynamicBox.SetAsBox(bound.width / PTM_RATIO * 0.5f, bound.height / PTM_RATIO * 0.5f);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 0.3f;
        fixtureDef.friction = 0.5f;
        fixtureDef.restitution = 0.6f;
        body->CreateFixture(&fixtureDef);

    }
    [self performSelector:@selector(activate) 
               withObject:nil
               afterDelay:duration];
}
@end
