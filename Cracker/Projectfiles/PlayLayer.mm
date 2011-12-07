//
//  PlayLayer.m
//  Cracker
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayLayer.h"
#import "Ball3DLayer.h"

@interface PlayLayer (PrivateMethods)
- (void)CreateScreenBound;
@end

@implementation PlayLayer

const float PTM_RATIO = 32.0f;

- (void)dealloc
{
    [super dealloc];
    delete world;
}

- (id)init
{
    if ((self = [super init])){
        
        world = new b2World(b2Vec2(0.0f,0.0f));
        world->SetAllowSleeping(NO);
        
        [self CreateScreenBound];
        [self addChild:[Ball3DLayer node]];
        
        [self scheduleUpdate];
    }
    return self;
}

#pragma mark - Private Methods

- (void)CreateScreenBound
{
    // for the screenBorder body we'll need these values
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    const CGFloat boundFriction = 0.8;
    
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
    screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(boundFriction);
    screenBorderShape.Set(lowerRightCorner, upperRightCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(boundFriction);
    screenBorderShape.Set(upperRightCorner, upperLeftCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(boundFriction);
    screenBorderShape.Set(upperLeftCorner, lowerLeftCorner);
    screenBorderBody->CreateFixture(&screenBorderShape, 0)->SetFriction(boundFriction);
}

#pragma mark - Overrided Methods

- (void)update:(ccTime)delta
{
    
}
@end
