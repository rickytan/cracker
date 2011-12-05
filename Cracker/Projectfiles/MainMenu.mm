//
//  MainMenu.m
//  Cracker
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"

@interface MainMenu (PrivateMethods)

- (void)menuCallback:(id)sender;
- (void)menuCallback2:(id)sender;
- (void)menuCallbackDisabled:(id)sender;
- (void)menuCallbackEnable:(id)sender;
@end
@implementation MainMenu

- (void)dealloc
{
    [super dealloc];
    delete world;
}
- (id)init
{
    if ((self = [super init])){
        
        world = new b2World(b2Vec2(0, -10));
        
		[CCMenuItemFont setFontSize:30];
		[CCMenuItemFont setFontName: @"Courier New"];
        
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        self.isTouchEnabled = YES;
#endif
		// Font Item
		
		CCSprite *spriteNormal = [CCSprite spriteWithFile:@"menuitemsprite.png" 
                                                     rect:CGRectMake(0,23*2,115,23)];
		CCSprite *spriteSelected = [CCSprite spriteWithFile:@"menuitemsprite.png" 
                                                       rect:CGRectMake(0,23*1,115,23)];
		CCSprite *spriteDisabled = [CCSprite spriteWithFile:@"menuitemsprite.png" 
                                                       rect:CGRectMake(0,23*0,115,23)];

        CCMenuItemFont *item0 = [CCMenuItemFont itemFromString:@"Start"
                                                         target:self
                                                       selector:@selector(gameStart:)];
        CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"Config"
                                                        target:self
                                                      selector:@selector(gameConfig:)];
        
        CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:@"About"
                                                        target:self
                                                      selector:@selector(gameAbout:)];
        
		CCMenuItemSprite *item3 = [CCMenuItemSprite itemFromNormalSprite:spriteNormal 
                                                          selectedSprite:spriteSelected 
                                                          disabledSprite:spriteDisabled 
                                                                  target:self 
                                                                selector:@selector(menuCallback:)];
		
		// Image Item
		CCMenuItem *item4 = [CCMenuItemImage itemFromNormalImage:@"SendScoreButton.png" 
                                                   selectedImage:@"SendScoreButtonPressed.png" 
                                                          target:self 
                                                        selector:@selector(menuCallback2:)];
        
		// Label Item (LabelAtlas)
		CCLabelAtlas *labelAtlas = [CCLabelAtlas labelWithString:@"0123456789" 
                                                     charMapFile:@"fps_images.png" 
                                                       itemWidth:16
                                                      itemHeight:24 
                                                    startCharMap:'.'];
        
		CCMenuItemLabel *item5 = [CCMenuItemLabel itemWithLabel:labelAtlas
                                                         target:self 
                                                       selector:@selector(menuCallbackDisabled:)];
		item5.disabledColor = ccc3(32,32,64);
		item5.color = ccc3(200,200,255);
		
        
		// Font Item
		CCMenuItemFont *item6 = [CCMenuItemFont itemFromString: @"I toggle enable items"
                                                        target: self 
                                                      selector:@selector(menuCallbackEnable:)];
		
		[item6 setFontSize:20];
		[item6 setFontName:@"Marker Felt"];
		
		
		CCTintBy* color_action = [CCTintBy actionWithDuration:0.5f red:0 green:-255 blue:-255];
		id color_back = [color_action reverse];
		id seq = [CCSequence actions:color_action, color_back, nil];
		[item6 runAction:[CCRepeatForever actionWithAction:seq]];
        
		CCMenu *menu = [CCMenu menuWithItems:item0, item1, item2, item3, item4, item5, item6, nil];
		[menu alignItemsVertically];
		
		
		// elastic effect
		CGSize s = [[CCDirector sharedDirector] winSize];
		int i=0;
		for( CCNode *child in [menu children] ) {
			CGPoint dstPoint = child.position;
			int offset = s.width/2 + 50;
			if( i % 2 == 0)
				offset = -offset;
			child.position = ccp( dstPoint.x + offset, dstPoint.y);
			[child runAction: 
             [CCEaseElasticOut actionWithAction: 
              [CCMoveBy actionWithDuration:2
                                  position:ccp(dstPoint.x - offset,0)]
								         period: 0.35f]];
			i++;
		}
        
		disabledItem = [item3 retain];
		disabledItem.isEnabled = NO;
        
		[self addChild: menu];
    }
    return self;
}

#pragma mark - Methods

- (void)gameStart:(id)sender
{
    [[CCDirector sharedDirector] runWithScene:[GameScene node]];
}

- (void)gameConfig:(id)sender
{
    
}

- (void)gameAbout:(id)sender
{
    
}

#pragma mark - Overrided Methods
- (void)update:(ccTime)delta
{
    
}
@end
