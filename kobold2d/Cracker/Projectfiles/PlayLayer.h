//
//  PlayLayer.h
//  Cracker
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "Box2D.h"

@interface PlayLayer : CCLayer {
    b2World *               world;
    CCSprite *              ball;       // Weak assign
}

@end
