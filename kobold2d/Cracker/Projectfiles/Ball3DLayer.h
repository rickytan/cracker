//
//  Ball3DWorld.h
//  Cracker
//
//  Created by  on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CC3World.h"
#import "CC3MeshNode.h"
#import "CC3Layer.h"

@class Ball3DLayer;
@class Ball3DWorld;

@interface Ball3DLayer : CC3Layer {
    CC3Camera *                 camera;     // Weak assign
}

@end