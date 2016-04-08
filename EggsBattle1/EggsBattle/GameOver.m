//
//  GameOver.m
//  GameTest
//
//  Created by yang mu on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOver.h"
#import "GameStart.h"
#import "GameMain.h"
#import "SimpleAudioEngine.h"

@implementation GameOver

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOver *layer = [GameOver node];
	
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
        // 初始化得分显示
        [self initScoreShow];
        // 画顶部图
        [self drawTop];
        // 画广告
        [self drawAd];
        // 初始化菜单
        [self initMenu];
    }
    
    return self;
}

// 初始化得分显示
-(void)initScoreShow
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 添加显示标签
    scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Optima-Bold" fontSize:20];
    scoreLabel.color = ccc3(255,255,255);
    scoreLabel.position = ccp(winSize.width/2, winSize.height-15);
    [self addChild:scoreLabel];
    
    // 获取保存得分信息
    NSUserDefaults *mainUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nowScore = [mainUserDefaults stringForKey:@"nowScore"];
    NSString *highestScore = [mainUserDefaults stringForKey:@"highestScore"];
    NSString *towScore = [mainUserDefaults stringForKey:@"towScore"];
    NSString *threeScore = [mainUserDefaults stringForKey:@"threeScore"];
    NSString *fourScore = [mainUserDefaults stringForKey:@"fourScore"];
    if (nowScore == NULL) {
        nowScore = @"00000";
    }
    // 显示内容
    NSString *scoreString = [[NSString alloc] initWithFormat:@"Score:%@", nowScore];
    // 更新标签显示内容
    [scoreLabel setString:scoreString];
    
    // 更新排行榜
    if (nowScore.intValue > highestScore.intValue) {
        [mainUserDefaults setObject:nowScore forKey:@"highestScore"];
    }else if (nowScore.intValue > towScore.intValue) {
        [mainUserDefaults setObject:nowScore forKey:@"towScore"];
    }else if (nowScore.intValue > threeScore.intValue) {
        [mainUserDefaults setObject:nowScore forKey:@"threeScore"];
    }else if (nowScore.intValue > fourScore.intValue) {
        [mainUserDefaults setObject:nowScore forKey:@"fourScore"];
    }
}

// 初始化音效
-(void)initSound
{
    // 播放背景音乐
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"fail.caf"];
}

// 画顶部图
-(void)drawTop
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 顶部图
    CCSprite *topImage = [[CCSprite spriteWithFile:@"top.png"] retain];
    topImage.position = ccp(winSize.width/2, winSize.height - topImage.contentSize.height/4*3);
    [self addChild:topImage];
}

// 画广告
-(void)drawAd
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 广告套图
    // 套按钮
    CCMenuItemImage *tao = [CCMenuItemImage itemFromNormalImage:@"adtao.png" selectedImage:@"adtaoed.png" target:self selector:@selector(openAd:)];
    // 套菜单
    CCMenu *taoMenu = [CCMenu menuWithItems:tao, nil];
    taoMenu.position = ccp(winSize.width-tao.contentSize.width/2, tao.contentSize.height/2);
    [taoMenu alignItemsVerticallyWithPadding: 10.0f];
    // 添加套菜单
    [self addChild:taoMenu];
    
    // 广告顶部图
    CCSprite *adTopImage = [[CCSprite spriteWithFile:@"adtop.png"] retain];
    adTopImage.position = ccp(winSize.width-adTopImage.contentSize.width/2, adTopImage.contentSize.height/2+tao.contentSize.height);
    
    // 原始位置
    float jumpY = adTopImage.position.y;
    // 向上移动
    id action4 = [CCMoveTo actionWithDuration:0.5 position:ccp(adTopImage.position.x,jumpY+20)];
    // 淡出到一半
    id action19 = [CCFadeTo actionWithDuration:0.5 opacity:127];
    // 组合动作
    id action21 = [CCSpawn actions:action4, action19, nil];
    // 向下移动
    id action5 = [CCMoveTo actionWithDuration:0.5 position:ccp(adTopImage.position.x,jumpY)];
    // 淡入到一半
    id action18 = [CCFadeTo actionWithDuration:0.5 opacity:255];
    // 组合动作
    id action22 = [CCSpawn actions:action5, action18, nil];
    // 组合动作
    id action23 = [CCSequence actions:action21, action22, nil];
    // 无限循环动作
    id action25 = [CCRepeatForever actionWithAction:action23];
    [adTopImage runAction:action25];
    // 添加adTop图
    [self addChild:adTopImage];
}

// 打开广告链接
- (void)openAd:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://s.taobao.com/search?q=%B6%C5%C0%D9%CB%B9"]];
}

// 初始化菜单
-(void)initMenu
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 重新开始按钮
    CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage:@"restartb.png" selectedImage:@"restartbed.png" target:self selector:@selector(onRestart:)];
    // 主菜单按钮
    CCMenuItemImage *main = [CCMenuItemImage itemFromNormalImage:@"mainb.png" selectedImage:@"mainbed.png" target:self selector:@selector(onMain:)];
    
    // 失败菜单
    CCMenu *failMenu = [CCMenu menuWithItems:restart, main, nil];
    failMenu.position = ccp(winSize.width/2, winSize.height/4);
    [failMenu alignItemsVerticallyWithPadding: 10.0f];
    
    // 添加失败菜单
    [self addChild:failMenu];
}

// 初始化背景
-(void)initBackground
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 设置贴图
    CCTexture2D *texture1 = [[CCTextureCache sharedTextureCache] addImage:@"background1.png"];
    CCTexture2D *texture2 = [[CCTextureCache sharedTextureCache] addImage:@"background2.png"];
    CCTexture2D *texture3 = [[CCTextureCache sharedTextureCache] addImage:@"background3.png"];
    CCTexture2D *texture4 = [[CCTextureCache sharedTextureCache] addImage:@"background4.png"];
    // 设置播放画面贴图顺序
    CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTexture:texture1 rect:CGRectMake(0, 0, 480, 320)];
    CCSpriteFrame *frame2 = [CCSpriteFrame frameWithTexture:texture2 rect:CGRectMake(0, 0, 480, 320)];
    CCSpriteFrame *frame3 = [CCSpriteFrame frameWithTexture:texture3 rect:CGRectMake(0, 0, 480, 320)];
    CCSpriteFrame *frame4 = [CCSpriteFrame frameWithTexture:texture4 rect:CGRectMake(0, 0, 480, 320)];
    
    // 添加背景精灵
    backgroundSprite = [[CCSprite spriteWithSpriteFrame:frame1] retain];
    backgroundSprite.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:backgroundSprite];
    
    // 设置播放动画
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:frame1];
    [animFrames addObject:frame2];
    [animFrames addObject:frame3];
    [animFrames addObject:frame4];
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.1f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
    CCSequence *seq = [CCSequence actions: animate,
                       [CCFlipX actionWithFlipX:NO],
                       [[animate copy] autorelease],
                       [CCFlipX actionWithFlipX:NO],
                       nil];
    id action1 = [CCRepeatForever actionWithAction: seq ];
    
    // 让背景开始动
    [backgroundSprite runAction:action1];
}

// 重新开始
- (void)onRestart:(id)sender
{    
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    [[CCDirector sharedDirector] replaceScene:[GameStart scene]];
}

// 点击主菜单
-(void)onMain:(id)sender
{
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    [[CCDirector sharedDirector] replaceScene:[GameMain scene]];
}

- (void)dealloc 
{
    [super dealloc];
}

@end
