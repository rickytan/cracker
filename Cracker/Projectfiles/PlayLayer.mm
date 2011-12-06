//
//  PlayLayer.m
//  Cracker
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayLayer.h"

@implementation PlayLayer


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
    }
    return self;
}

#pragma mark - Overrided Methods

- (void)update:(ccTime)delta
{
    
}
@end
