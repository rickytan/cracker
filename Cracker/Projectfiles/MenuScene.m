//
//  Memu.m
//  Cracker
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"



@interface Layer2 : CCLayer
{
	CGPoint	centeredMenu;
	BOOL alignedH;
}
-(void) menuCallbackBack: (id) sender;
-(void) menuCallbackOpacity: (id) sender;
-(void) menuCallbackAlign: (id) sender;
@end



#pragma mark -
#pragma mark MainMenu

#define kTagMenu 1



#pragma mark -
#pragma mark StartMenu

@implementation Layer2

-(void) alignMenusH
{
	for(int i=0;i<2;i++) {
		CCMenu *menu = (CCMenu*)[self getChildByTag:100+i];
		menu.position = centeredMenu;
		if(i==0) {
			// TIP: if no padding, padding = 5
			[menu alignItemsHorizontally];			
			CGPoint p = menu.position;
			menu.position = ccpAdd(p, ccp(0,30));
			
		} else {
			// TIP: but padding is configurable
			[menu alignItemsHorizontallyWithPadding:40];
			CGPoint p = menu.position;
			menu.position = ccpSub(p, ccp(0,30));
		}		
	}
}

-(void) alignMenusV
{
	for(int i=0;i<2;i++) {
		CCMenu *menu = (CCMenu*)[self getChildByTag:100+i];
		menu.position = centeredMenu;
		if(i==0) {
			// TIP: if no padding, padding = 5
			[menu alignItemsVertically];			
			CGPoint p = menu.position;
			menu.position = ccpAdd(p, ccp(100,0));			
		} else {
			// TIP: but padding is configurable
			[menu alignItemsVerticallyWithPadding:40];	
			CGPoint p = menu.position;
			menu.position = ccpSub(p, ccp(100,0));
		}		
	}
}

-(id) init
{
	if( (self=[super init]) ) {
        
	}
    
	return self;
}

// Testing issue #1018 and #1021
-(void) onEnter
{	
	[super onEnter];
    
	// remove previously added children
	[self removeAllChildrenWithCleanup:YES];
	
	for( int i=0;i < 2;i++ ) {
		CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"btn-play-normal.png"
                                                        selectedImage:@"btn-play-selected.png" 
                                                               target:self 
                                                             selector:@selector(menuCallbackBack:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"btn-highscores-normal.png" 
                                                        selectedImage:@"btn-highscores-selected.png" 
                                                               target:self 
                                                             selector:@selector(menuCallbackOpacity:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"btn-about-normal.png" 
                                                        selectedImage:@"btn-about-selected.png" 
                                                               target:self 
                                                             selector:@selector(menuCallbackAlign:)];
		
		item1.scaleX = 1.5f;
		item2.scaleY = 0.5f;
		item3.scaleX = 0.5f;
		
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
		
		menu.tag = kTagMenu;
		
		[self addChild:menu z:0 tag:100+i];
		centeredMenu = menu.position;
	}
	
	alignedH = YES;
	[self alignMenusH];
}

-(void) dealloc
{
	[super dealloc];
}

-(void) menuCallbackBack: (id) sender
{
	[(CCLayerMultiplex*)parent_ switchTo:0];
}

-(void) menuCallbackOpacity: (id) sender
{
	CCMenu *menu = (CCMenu*) [sender parent];
	GLubyte opacity = [menu opacity];
	if( opacity == 128 )
		[menu setOpacity: 255];
	else
		[menu setOpacity: 128];	
}
-(void) menuCallbackAlign: (id) sender
{
	alignedH = ! alignedH;
	
	if( alignedH )
		[self alignMenusH];
	else
		[self alignMenusV];
}

@end

#pragma mark -
#pragma mark SendScores




@implementation MenuScene

- (void)dealloc
{
    
}

- (id)init
{
    if ((self = [super init])){
        CCLayerMultiplex *layer = [CCLayerMultiplex layerWithLayers: [Layer2 node], nil];
        
        [self addChild:layer];
    }
    return self;
}

@end
