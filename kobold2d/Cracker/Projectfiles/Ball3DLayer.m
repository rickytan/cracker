//
//  Ball3DWorld.m
//  Cracker
//
//  Created by  on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Ball3DLayer.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3ParametricMeshNodes.h"
#import "CC3Camera.h"
#import "CC3Light.h"


@interface Ball3DWorld : CC3World {
    CC3Camera *                 _cam;    // Weak assign
    CC3PlaneNode *              _ball;   // Weak assign
    CC3BoxNode *                _box;    // Weak assign
    
    CGFloat                     _ballRadius;
    CGSize                      boxBound;
}

- (void)setBallLocation:(CGPoint)ballLocation;
- (void)setBallRotation:(CGFloat)ballRotation;
- (CGPoint)getBallLocation;
- (CGFloat)getBallRadius;
- (CGPoint)toBoxPoint:(CGPoint)screen;
- (CGPoint)toScreenPoint:(CGPoint)box;
@end

@implementation Ball3DWorld


#pragma mark - Overrided Methods

-(void) initializeWorld
{
	// Create the camera, place it back a bit
	_cam = [CC3Camera nodeWithName: @"Camera"];
	_cam.location = cc3v(0.0, 0.0, 15.0);
    _ballRadius = 0.5f;
    
	[self addChild:_cam];
    
	// Create a light, place it and make it shine in all directions (not directional)
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v(-4.0, 1.0, 10.0);
	lamp.isDirectionalOnly = YES;
    lamp.color = ccc3(0xff, 0xff, 0xff);
    lamp.specularColor = kCCC4FWhite;
    lamp.ambientColor = kCCC4FLightGray;
    lamp.diffuseColor = kCCC4FWhite;
	[self addChild:lamp];
    
    const CGFloat ratio = 60;
    CGSize s = [CCDirector sharedDirector].winSize;
    boxBound.width = s.width / ratio;
    boxBound.height = s.height / ratio;
    
    CC3BoundingBox bounds = CC3BoundingBoxMake(-boxBound.width/2, -boxBound.height/2, -1, 
                                                boxBound.width/2,  boxBound.height/2, 0);
    
    _box = [CC3BoxNode nodeWithName:@"Box"];
    [_box populateAsSolidBox:bounds];
    _box.texture = [CC3Texture textureFromFile:@"wood2.jpg"];
    _box.specularColor = kCCC4FWhite;
    _box.diffuseColor = kCCC4FLightGray;
    _box.ambientColor = kCCC4FDarkGray;
    
    [self addChild:_box];


    _ball = [CC3PlaneNode nodeWithName:@"Ball"];
    
    [_ball populateAsCenteredRectangleWithSize:CGSizeMake(2*_ballRadius, 2*_ballRadius) 
                                   withTexture:[CC3Texture textureFromFile:@"ball.png"] 
                                 invertTexture:YES];
    _ball.material.isOpaque = YES;
    _ball.material.sourceBlend = GL_SRC_ALPHA;
    _ball.material.destinationBlend = GL_ONE_MINUS_SRC_ALPHA;
    _ball.shouldCullBackFaces = NO;

    [_ball retainVertexLocations];
    
    [_box addChild:_ball];

	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
}

-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {}

-(void) updateWorld:(ccTime)dt
{
    [super updateWorld:dt];
    
    CCDirector* director = [CCDirector sharedDirector];
    
    KKInput* input = [KKInput sharedInput];
    if (director.currentDeviceIsSimulator == NO)
    {
        KKDeviceMotion* m = input.deviceMotion;
        float xd = CC_RADIANS_TO_DEGREES(m.pitch);
        float yd = CC_RADIANS_TO_DEGREES(m.roll);
        _box.rotation = cc3v(xd<10?(xd>-10?xd:-10):10, yd<10?(yd>-10?yd:-10):10,0.0);
    }
}

#pragma mark - Methods
- (CGPoint)toBoxPoint:(CGPoint)screen
{
    CGPoint p;
    CGSize s = [CCDirector sharedDirector].winSize;
    screen = ccpSub(screen, ccp(s.width*0.5, s.height*0.5));
    p.x = screen.x / s.width * boxBound.width;
    p.y = screen.y / s.height * boxBound.height;
    return p;
}

- (CGPoint)toScreenPoint:(CGPoint)box
{
    CGPoint p;
    CGSize s = [CCDirector sharedDirector].winSize;
    box = ccpAdd(box, ccp(boxBound.width*0.5, boxBound.height*0.5));
    p.x = box.x / boxBound.width * s.width;
    p.y = box.y / boxBound.height * s.height;
    return p;
}

- (void)setBallLocation:(CGPoint)screenPoint
{
    CGPoint p = [self toBoxPoint:screenPoint];
    _ball.location = cc3v(p.x, p.y, 0);
}

- (void)setBallRotation:(CGFloat)ballRotation
{
    _ball.rotationAxis = cc3v(0, 0, 1);
    //_ball.rotationAngle = ballRotation;
}

- (CGPoint)getBallLocation
{
    CGPoint p = ccp(_ball.location.x, _ball.location.y);
    return [self toScreenPoint:p];
}

- (CGFloat)getBallRadius
{
    CGSize s = [CCDirector sharedDirector].winSize;
    return _ballRadius / boxBound.width * s.width;
}
@end



@implementation Ball3DLayer

- (id)init
{
    if ((self = [super init])){
        Ball3DWorld *world = [Ball3DWorld world];
        self.cc3World = world;
        [world play];
        
        /*
        CGSize s = [CCDirector sharedDirector].winSize;
        self.contentSize = CGSizeMake(s.width/2, s.height/2);
        self.position = CGPointMake(s.width/4, s.height/4);
         */
        
        [self scheduleUpdate];
    }
    return self;
}

#pragma mark - Methods

- (void)updateBallLocation:(CGPoint)l andRotation:(CGFloat)a
{
    Ball3DWorld *w = (Ball3DWorld*)self.cc3World;
    [w setBallLocation:l];
    [w setBallRotation:a];
}

- (CGPoint)getBallLocation
{
    Ball3DWorld *w = (Ball3DWorld*)self.cc3World;
    return [w getBallLocation];
}

- (CGFloat)getBallRadius
{
    Ball3DWorld *w = (Ball3DWorld*)self.cc3World;
    return [w getBallRadius];
}

#pragma mark - Overrided Methods

- (void)initializeControls
{
    [KKInput sharedInput].deviceMotionActive = YES;
}

@end
