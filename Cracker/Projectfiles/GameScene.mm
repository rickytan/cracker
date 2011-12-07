//
//  GameScene.m
//  Cracker
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "MenuScene.h"
#import "PlayLayer.h"

@implementation GameScene


- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])){

        [self addChild:[PlayLayer node]];
        [self scheduleUpdate];
    }
    return self;
}


#pragma mark - Overrided Methods

- (void)update:(ccTime)delta
{
    KKInput *input = [KKInput sharedInput];
    
    if (input.anyTouchEndedThisFrame){
        [[CCDirector sharedDirector]
         replaceScene:[CCTransitionSlideInL transitionWithDuration:0.3f
                                                             scene:[MenuScene node]]];
    }
}
@end
