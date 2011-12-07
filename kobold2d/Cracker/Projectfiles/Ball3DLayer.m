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
    CC3Camera *                 cam;    // Weak assign
}
@property (nonatomic, getter = camere, readonly) CC3Camera *cam;
@end

@implementation Ball3DWorld
@synthesize cam;

-(void) initializeWorld
{
	// Create the camera, place it back a bit
	cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v(0.0, 0.0, 10.0);
    
	[self addChild:cam];
    
	// Create a light, place it and make it shine in all directions (not directional)
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v(0.0, 1.0, -2.0);
	lamp.isDirectionalOnly = YES;
	[cam addChild:lamp];
    
    CC3BoundingBox bounds = CC3BoundingBoxMake(-2, -3, -1, 2, 3, 0);
    CC3MeshNode *box = [CC3MeshNode node];
    [box populateAsWireBox:bounds];
    

    [self addChild:box];
	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
}

-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {}

#pragma mark - getter

- (CC3Camera*)camere
{
    return cam;
}
@end

@implementation Ball3DLayer

- (id)init
{
    if ((self = [super init])){
        Ball3DWorld *world = [Ball3DWorld world];
        self.cc3World = world;
        camera = world.camere;
        [world play];
        [self scheduleUpdate];

    }
    return self;
}

- (void)initializeControls
{
    [KKInput sharedInput].accelerometerActive = YES;
}

- (void)update:(ccTime)dt
{
    [super update:dt];
    
	CCDirector* director = [CCDirector sharedDirector];
    
    KKInput* input = [KKInput sharedInput];
    if (director.currentDeviceIsSimulator == NO)
    {
        KKAcceleration* a = input.acceleration;
        camera.location =  cc3v(-a.smoothedX*4,-a.smoothedY*4, 10.0);
    }
}
@end
