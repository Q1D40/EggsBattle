//
//  GameOver.m
//  GameTest
//
//  Created by yang mu on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScore.h"
#import "GameMain.h"
#import "SimpleAudioEngine.h"

@implementation GameScore

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScore *layer = [GameScore node];
	
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

// 初始化得分显示
-(void)initScoreShow
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 获取保存得分信息
    NSUserDefaults *mainUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *highestScore = [mainUserDefaults stringForKey:@"highestScore"];
    NSString *towScore = [mainUserDefaults stringForKey:@"towScore"];
    NSString *threeScore = [mainUserDefaults stringForKey:@"threeScore"];
    NSString *fourScore = [mainUserDefaults stringForKey:@"fourScore"];
    if (highestScore == NULL) {
        highestScore = @"00000";
    }
    if (towScore == NULL) {
        towScore = @"00000";
    }
    if (threeScore == NULL) {
        threeScore = @"00000";
    }
    if (fourScore == NULL) {
        fourScore = @"00000";
    }
    
    // 得分显示
    CCLabelTTF *scoreLabel;
    // 添加显示标签
    scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Optima-Bold" fontSize:35];
    scoreLabel.color = ccc3(255,255,255);
    scoreLabel.position = ccp(winSize.width/2, winSize.height-30);
    [self addChild:scoreLabel];
    // 显示内容
    NSString *scoreString = @"Score";
    // 更新标签显示内容
    [scoreLabel setString:scoreString];
    
    // 得分显示
    CCLabelTTF *scoreLabel1;
    // 添加显示标签
    scoreLabel1 = [CCLabelTTF labelWithString:@"" fontName:@"Optima-Bold" fontSize:35];
    scoreLabel1.color = ccc3(255,255,255);
    scoreLabel1.position = ccp(winSize.width/2, winSize.height-80);
    [self addChild:scoreLabel1];
    // 显示内容
    scoreString = [[NSString alloc] initWithFormat:@"1 . %@", highestScore];
    // 更新标签显示内容
    [scoreLabel1 setString:scoreString];
    // 图标
    CCSprite *highestScoreIcon = [[CCSprite spriteWithFile:@"scoreicon1.png"] retain];
    highestScoreIcon.position = ccp(145, winSize.height-80);
    [self addChild:highestScoreIcon];
    
    // 得分显示
    CCLabelTTF *scoreLabel2;
    // 添加显示标签
    scoreLabel2 = [CCLabelTTF labelWithString:@"" fontName:@"Optima-Bold" fontSize:35];
    scoreLabel2.color = ccc3(255,255,255);
    scoreLabel2.position = ccp(winSize.width/2, winSize.height-120);
    [self addChild:scoreLabel2];
    // 显示内容
    scoreString = [[NSString alloc] initWithFormat:@"2 . %@", towScore];
    // 更新标签显示内容
    [scoreLabel2 setString:scoreString];
    CCSprite *towScoreIcon = [[CCSprite spriteWithFile:@"scoreicon2.png"] retain];
    towScoreIcon.position = ccp(145, winSize.height-120);
    [self addChild:towScoreIcon];
    
    // 得分显示
    CCLabelTTF *scoreLabel3;
    // 添加显示标签
    scoreLabel3 = [CCLabelTTF labelWithString:@"" fontName:@"Optima-Bold" fontSize:35];
    scoreLabel3.color = ccc3(255,255,255);
    scoreLabel3.position = ccp(winSize.width/2, winSize.height-160);
    [self addChild:scoreLabel3];
    // 显示内容
    scoreString = [[NSString alloc] initWithFormat:@"3 . %@", threeScore];
    // 更新标签显示内容
    [scoreLabel3 setString:scoreString];
    CCSprite *threeScoreIcon = [[CCSprite spriteWithFile:@"scoreicon3.png"] retain];
    threeScoreIcon.position = ccp(145, winSize.height-160);
    [self addChild:threeScoreIcon];
    
    // 得分显示
    CCLabelTTF *scoreLabel4;
    // 添加显示标签
    scoreLabel4 = [CCLabelTTF labelWithString:@"" fontName:@"Optima-Bold" fontSize:35];
    scoreLabel4.color = ccc3(255,255,255);
    scoreLabel4.position = ccp(winSize.width/2, winSize.height-200);
    [self addChild:scoreLabel4];
    // 显示内容
    scoreString = [[NSString alloc] initWithFormat:@"4 . %@", fourScore];
    // 更新标签显示内容
    [scoreLabel4 setString:scoreString];
}

// 初始化菜单
-(void)initMenu
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 主菜单按钮
    CCMenuItemImage *main = [CCMenuItemImage itemFromNormalImage:@"mainb.png" selectedImage:@"mainbed.png" target:self selector:@selector(onMain:)];
    
    // 主页菜单
    CCMenu *mainMenu = [CCMenu menuWithItems:main, nil];
    mainMenu.position = ccp(winSize.width/2, winSize.height/4-30);
    [mainMenu alignItemsVerticallyWithPadding: 10.0f];
    
    // 添加主页菜单
    [self addChild:mainMenu];
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
