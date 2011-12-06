//
//  Memu.m
//  Cracker
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "MainMenu.h"


@implementation MenuScene

- (void)dealloc
{
    
}

- (id)init
{
    if ((self = [super init])){
        glClearColor(.0f, .0f, .0f, .0f);
        
        CCLayerMultiplex *layer = [CCLayerMultiplex layerWithLayers: [MainMenu node], nil];
        
        [self addChild:layer];
    }
    return self;
}

@end
