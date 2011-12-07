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
    
}

@end

@implementation Ball3DWorld

-(void) initializeWorld
{
	// Create the camera, place it back a bit
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v(0.0, 0.0, 2.0);
	[self addChild:cam];
    
	// Create a light, place it and make it shine in all directions (not directional)
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v(0.0, 1.0, -2.0);
	lamp.isDirectionalOnly = YES;
	[cam addChild:lamp];

    CC3BoundingBox bounds = CC3BoundingBoxMake(-2, -1, -1, 2, 1, 1);
    CC3MeshNode *box = [[CC3MeshNode alloc] init];
    [box populateAsSolidBox:bounds];
    
    [self addChild:box];
    
    CCScaleBy *s1 = [CCScaleBy actionWithDuration:2.0f
                                            scale:2.0f];
    CCScaleBy *s2 = [CCScaleBy actionWithDuration:1.0f
                                            scale:0.5f];
    CCSequence *s = [CCSequence actions:s1, s2, nil];
    [box runAction:s];

	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
	
}

-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {}

@end

@implementation Ball3DLayer

- (void)initializeControls
{
    CC3World *world = [Ball3DWorld world];
    self.cc3World = world;
    [world play];

    [self scheduleUpdate];
}

@end
