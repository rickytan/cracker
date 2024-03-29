/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "HelloWorldLayer.h"
#import "Hello3DLayer.h"
#import "Hello3DWorld.h"
#import "SimpleAudioEngine.h"

@interface HelloWorldLayer (PrivateMethods)
@end

@implementation HelloWorldLayer

@synthesize helloWorldString, helloWorldFontName;
@synthesize helloWorldFontSize;

-(id) init
{
	if ((self = [super init]))
	{
		CCLOG(@"%@ init", NSStringFromClass([self class]));

		CCDirector* director = [CCDirector sharedDirector];
		
		CCSprite* sprite = [CCSprite spriteWithFile:@"ship.png"];
		sprite.position = director.screenCenter;
		sprite.scale = 0;
		[self addChild:sprite];
		
		id scale = [CCScaleTo actionWithDuration:1.0f scale:1.6f];
		[sprite runAction:scale];
		id move = [CCMoveBy actionWithDuration:1.0f position:CGPointMake(0, -120)];
		[sprite runAction:move];

		// get the hello world string from the config.lua file
		[KKConfig injectPropertiesFromKeyPath:@"HelloWorldSettings" target:self];
		
		CCLabelTTF* label = [CCLabelTTF labelWithString:helloWorldString 
											   fontName:helloWorldFontName 
											   fontSize:helloWorldFontSize];
		label.position = director.screenCenter;
		label.color = ccGREEN;
		[self addChild:label z:1];

		// print out which platform we're on
		NSString* platform = @"(unknown platform)";
		
		if (director.currentPlatformIsIOS)
		{
			// add code 
			platform = @"iPhone/iPod Touch";
			
			if (director.currentDeviceIsIPad)
				platform = @"iPad";

			if (director.currentDeviceIsSimulator)
				platform = [NSString stringWithFormat:@"%@ Simulator", platform];
		}
		else if (director.currentPlatformIsMac)
		{
			platform = @"Mac OS X";
		}
		
		CCLabelTTF* platformLabel = [CCLabelTTF labelWithString:platform 
													   fontName:@"Arial" 
													   fontSize:24];
		platformLabel.position = director.screenCenter;
		platformLabel.color = ccYELLOW;
		[self addChild:platformLabel];
		
		id movePlatform = [CCMoveBy actionWithDuration:0.2f 
											  position:CGPointMake(0, 50)];
		[platformLabel runAction:movePlatform];

		glClearColor(0.2f, 0.2f, 0.4f, 1.0f);

		// play sound with CocosDenshion's SimpleAudioEngine
		[[SimpleAudioEngine sharedEngine] playEffect:@"Pow.caf"];
        
        
        Hello3DLayer *layer = [Hello3DLayer node];
        layer.cc3World = [Hello3DWorld world];
        [layer scheduleUpdate];
        
        [self addChild:layer];
	}

	return self;
}

@end
