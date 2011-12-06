//
//  MainMenu.h
//  Cracker
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


@interface MainMenu : CCLayer {
    b2World *                   world;
    BOOL                        worldStatic;
    CCMenu *                    menu;           // Weak assign
  	GLESDebugDraw *             debugDraw;
    CCMenuItem *                disabledItem;   // Weak assign
}
- (id)init;

- (void)gameStart:(id)sender;
- (void)gameConfig:(id)sender;
- (void)gameAbout:(id)sender;
@end
