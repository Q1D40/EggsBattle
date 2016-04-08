//
//  GameOver.m
//  GameTest
//
//  Created by yang mu on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameStart.h"
#import "GameScore.h"
#import "GameMain.h"
#import "SimpleAudioEngine.h"

@implementation GameMain

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameMain *layer = [GameMain node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {
        // 初始化音效
        [self initSound];
        // 初始化背景
        [self initBackground];
        // 初始化菜单
        [self initMenu];
    }
    
    return self;
}

// 初始化音效
-(void)initSound
{
    // 播放背景音乐
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main.caf"];
}

// 初始化菜单
-(void)initMenu
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 开始按钮
    CCMenuItemImage *start = [CCMenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"started.png" target:self selector:@selector(onStart:)];
    // 排行榜按钮
    CCMenuItemImage *score = [CCMenuItemImage itemFromNormalImage:@"score.png" selectedImage:@"scoreed.png" target:self selector:@selector(onScore:)];
    
    // 开始菜单
    CCMenu *mainMenu = [CCMenu menuWithItems:start, score, nil];
    mainMenu.position = ccp(winSize.width/2, winSize.height/4);
    [mainMenu alignItemsVerticallyWithPadding: 10.0f];
    
    // 添加失败菜单
    [self addChild:mainMenu];
}

// 初始化背景
-(void)initBackground
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 背景图
    CCSprite *background = [[CCSprite spriteWithFile:@"mainbackground.png"] retain];
    background.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:background];
}

// 点击开始
- (void)onStart:(id)sender
{    
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    [[CCDirector sharedDirector] replaceScene:[GameStart scene]];
}

// 点击排行榜
-(void)onScore:(id)sender
{
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    [[CCDirector sharedDirector] replaceScene:[GameScore scene]];
}

- (void)dealloc 
{
    [super dealloc];
}

@end
