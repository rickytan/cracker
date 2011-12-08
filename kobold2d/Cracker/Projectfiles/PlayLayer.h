//
//  PlayLayer.h
//  Cracker
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "Box2D.h"
#import "CC3Node.h"
#import "Ball3DLayer.h"

@interface PlayLayer : CCLayer {
    b2World *               world;

    Ball3DLayer *           ball3DLayer;// Weak assign
    NSTimer *               timer;
    
    uint                    score;
}

@end
