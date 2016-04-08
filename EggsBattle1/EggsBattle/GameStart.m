//
//  HelloWorldLayer.m
//  GameTest
//
//  Created by yang mu on 12-4-11.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "GameStart.h"
#import "SimpleAudioEngine.h"
#import "GameOver.h"
#import "GameMain.h"

// HelloWorldLayer implementation
@implementation GameStart

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameStart *layer = [GameStart node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {
        // 初始化背景
        [self initBackground];
        // 初始化大炮
        [self initGun];
        // 初始化得分显示
        [self initScoreShow];
        // 初始化所有数组
        [self initAllArray];
        // 初始化触摸设置
        [self initTouchSet];
        // 初始化计时器
        [self initSchedule];
        // 播放背景音乐
        [self playBackgroundSound];
        // 画所有东西
        [self drawAllThings];
        // 设置放弃控制代理
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(onPause:)
         name:UIApplicationWillResignActiveNotification 
         object:NULL];
    }
    
    return self;
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

// 画所有东西
-(void)drawAllThings
{
    // 画边框
    [self drawFrame];
    // 画暂停按钮
    [self drawPause];
}

// 画边框
-(void)drawFrame
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 设置静态背景
    CCSprite *frame = [[CCSprite spriteWithFile:@"frame.png"] retain];
    frame.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:frame];
}

// 画暂停按钮
-(void)drawPause
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 菜单按钮
    CCMenuItemImage *pause = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pauseed.png" target:self selector:@selector(onPause:)];
    pauseMenu = [CCMenu menuWithItems:pause, nil];
    // 菜单
    pauseMenu.position = ccp(winSize.width-55, winSize.height-25);
    [pauseMenu alignItemsVerticallyWithPadding: 40.0f];
    // 添加菜单
    [self addChild:pauseMenu];
}

// 点击暂停
-(void)onPause:(id)sender
{
    if (pauseMenu.isTouchEnabled == YES) {
        // 暂停场景
        [[CCDirector sharedDirector] pause];
        // 禁止暂停菜单触摸
        pauseMenu.isTouchEnabled = NO;
        // 禁止场景触摸
        self.isTouchEnabled = NO;
        // 暂停背景音乐
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        // 显示返回及其他按钮菜单
        [self showResumeAndOthersMenu];
    }
}

// 点击返回
-(void)onResume:(id)sender
{
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    // 场景继续
    [[CCDirector sharedDirector] resume];
    // 恢复暂停菜单触摸
    pauseMenu.isTouchEnabled = YES;
    // 恢复场景触摸
    self.isTouchEnabled = YES;
    // 恢复背景音乐
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    // 关闭返回及其他按钮菜单
    [self closeResumeAndOthersMenu];
}

// 点击重新开始
-(void)onRestart:(id)sender
{
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    // 返回并重新载入场景
    [self onResume:nil];
    [[CCDirector sharedDirector] replaceScene:[GameStart scene]];
}

// 点击主菜单
-(void)onMain:(id)sender
{
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    // 返回并载入首页
    [self onResume:nil];
    [[CCDirector sharedDirector] replaceScene:[GameMain scene]];
}

// 显示返回及其他按钮菜单
-(void)showResumeAndOthersMenu
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 画遮罩层
    pauseBackgroundSprite = [CCSprite spriteWithFile:@"backgroundpause.png" rect:CGRectMake(0, 0, 480, 320)];
    pauseBackgroundSprite.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:pauseBackgroundSprite];
    
    // 返回按钮
    CCMenuItemImage *resume = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resumeed.png" target:self selector:@selector(onResume:)];
    // 重新开始按钮
    CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage:@"restart.png" selectedImage:@"restarted.png" target:self selector:@selector(onRestart:)];
    // 主菜单按钮
    CCMenuItemImage *main = [CCMenuItemImage itemFromNormalImage:@"main.png" selectedImage:@"mained.png" target:self selector:@selector(onMain:)];
    // 蓝牙按钮
    CCMenuItemImage *bluetooth = [CCMenuItemFont itemFromString:@"Bluetooth" target:self selector:@selector(onBluetooth:)];
    
    // 返回及其他按钮菜单
    resumeAndOthersMenu = [CCMenu menuWithItems:resume, restart, main, bluetooth, nil];
    resumeAndOthersMenu.position = ccp(winSize.width/2, winSize.height/2);
    [resumeAndOthersMenu alignItemsVerticallyWithPadding: 10.0f];
    
    // 添加返回及其他按钮菜单
    [self addChild:resumeAndOthersMenu];
}

// 点击蓝牙按钮
-(void)onBluetooth:(id)sender
{
    // 配对选择框
    GKPeerPickerController *picker= [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
}

// 蓝牙配对成功
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session {
    //将蓝牙连接的回话session保存为当前的session
    currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    // 关闭蓝牙配对选项
    [picker dismiss];
}

// 蓝牙连接状态
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state){
        // 连接成功
        case GKPeerStateConnected:
            NSLog(@"connected");
            // 返回游戏
            [self onResume:nil];
            break;
        // 连接断开
        case GKPeerStateDisconnected:
            NSLog(@"disconnected");
            currentSession = nil;
            break;
        default:
            break;
    }
}

// 接受蓝牙数据
-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    // 接受数据字符串分割坐标数据
    NSString* str;
    str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSArray * parts = [str componentsSeparatedByString:@"-"];
    NSString* xx = [parts objectAtIndex:0];
    NSString* yy = [parts objectAtIndex:1];
    
    
    
    // 以下同触摸操作处理
    if (bulletSprite != nil) return;
    // 接受数据替换触摸坐标数据
    CGPoint location = CGPointMake(xx.floatValue, yy.floatValue);
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 初始化子弹精灵
    bulletSprite = [[CCSprite spriteWithFile:@"bullet.png"] retain];
    bulletSprite.position = ccp(20, winSize.height/2);
    
    // 触点坐标
    int offX = location.x - bulletSprite.position.x;
    int offY = location.y - bulletSprite.position.y;
    
    // 非法触点
    if (offX <=0) {
        // 释放子弹精灵
        [bulletSprite release];
        bulletSprite = nil;
        return;
    }
    
    // 子弹目标坐标
    int realX = winSize.width + (bulletSprite.contentSize.width/2);
    float ratio = (float) offY / (float) offX;
    int realY = (realX * ratio) + bulletSprite.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // 子弹移动速度计算
    int offRealX = realX - bulletSprite.position.x;
    int offRealY = realY - bulletSprite.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity =480/1; // 一秒48像素
    float realMoveDuration = length/velocity;
    
    // 大炮仰角设置
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle =-1* angleDegrees;
    float rotateSpeed =0.5/ M_PI; // 转动速度0.5秒半圈
    float rotateDuration = fabs(angleRadians * rotateSpeed); 
    // 大炮仰角移动动画
    [gunSprite runAction:[CCSequence actions:
                          [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                          [CCCallFunc actionWithTarget:self selector:@selector(shooted)],
                          nil]];
    // 大炮抖动动画
    id action10 = [CCScaleTo actionWithDuration:0.1 scale:0.5];
    id action11 = [CCScaleTo actionWithDuration:0.1 scale:1];
    id action21 = [CCSequence actions:action10, action11, nil];
    [gunSprite runAction:action21];
    
    // 子弹精灵移动
    [bulletSprite runAction:[CCSequence actions:
                             [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                             [CCCallFuncN actionWithTarget:self selector:@selector(generalMoveFinished:)],
                             nil]];
    
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    // 甚至精灵标记
    bulletSprite.tag =2;
    
}

// 关闭返回及其他按钮菜单
-(void)closeResumeAndOthersMenu
{
    // 移除返回及其他按钮菜单
    [self removeChild:resumeAndOthersMenu cleanup:YES];
    // 移除遮罩层
    [self removeChild:pauseBackgroundSprite cleanup:YES];
}

// 初始化大炮
-(void)initGun
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 添加大炮精灵
    gunSprite = [[CCSprite spriteWithFile:@"gun.png"] retain];
    gunSprite.position = ccp(gunSprite.contentSize.width/6/2, winSize.height/2);
    [self addChild:gunSprite];
}

// 初始化得分显示
-(void)initScoreShow
{
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 添加显示标签
    scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Optima-Bold" fontSize:20];
    scoreLabel.color = ccc3(255,255,255);
    scoreLabel.position = ccp(125, winSize.height-22);
    [self addChild:scoreLabel];
    
    // 获取保存得分信息
    NSUserDefaults *mainUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *highestScore = [mainUserDefaults stringForKey:@"highestScore"];
    if (highestScore == NULL) {
        highestScore = @"00000";
    }
    // 显示内容
    NSString *scoreString = [[NSString alloc] initWithFormat:@"Score:00000 High:%@", highestScore];
    // 更新标签显示内容
    [scoreLabel setString:scoreString];
    // 初始化当前得分
    [mainUserDefaults setObject:@"00000" forKey:@"nowScore"];
}

// 初始化所有数组
-(void)initAllArray
{
    // 怪物数组
    monsterArray = [[NSMutableArray alloc] init];
    // 尸体数组
    deadMonsterArray = [[NSMutableArray alloc] init];
    // 子弹数组
    bulletArray = [[NSMutableArray alloc] init];
    // 子弹爆破数组
    bulletedArray = [[NSMutableArray alloc] init];
}

// 初始化触摸设置
-(void)initTouchSet
{
    // 设置可触摸
    self.isTouchEnabled = YES;
}

// 初始化计时器
-(void)initSchedule
{
    // 怪物数量平衡控制
    [self schedule:@selector(MonsterCounterpoise:) interval:1.0];
    // 怪物尸体清理
    [self schedule:@selector(deadMonsterClear:) interval:1.5];
    // 子弹爆破效果清理
    [self schedule:@selector(bulletedClear:) interval:0.3];
    // 碰撞检测
    [self schedule:@selector(collisionDetection:)];
}

// 播放背景音乐
-(void)playBackgroundSound
{
    // 播放背景音乐
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.caf"];
}

// 添加怪物
-(void)addMonster
{    
    // 设置贴图
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"monster.png"];
    // 动画贴图
    CCSpriteFrame *frame0 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, 95, 15)];
    CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(95, 0, 95, 15)];
    CCSpriteFrame *frame2 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(95*2, 0, 95, 15)];
    CCSpriteFrame *frame3 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(95*3, 0, 95, 15)];
    CCSpriteFrame *frame4 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(95*4, 0, 95, 15)];
    CCSpriteFrame *frame5 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(95*5, 0, 95, 15)];
    CCSpriteFrame *frame6 = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(95*6, 0, 95, 15)];
    // 怪物精灵设置贴图
    CCSprite *monsterSprite = [CCSprite spriteWithSpriteFrame:frame0]; 
    
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // 初始化坐标
    int minY = monsterSprite.contentSize.height/2;
    int maxY = winSize.height - monsterSprite.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // 添加怪物
    monsterSprite.position = ccp(winSize.width + (monsterSprite.contentSize.width/2), actualY);
    [self addChild:monsterSprite];
    
    // 设置移动速度区间
    int minDuration =8.0;
    int maxDuration =16.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // 创建移动范围动作
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(-monsterSprite.contentSize.width/2, actualY)];
    // 移动结束回调事件
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(generalMoveFinished:)];
    
    // 设置怪物动作动画
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:frame0];
    [animFrames addObject:frame1];
    [animFrames addObject:frame2];
    [animFrames addObject:frame3];
    [animFrames addObject:frame4];
    [animFrames addObject:frame5];
    [animFrames addObject:frame6];
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.02f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
    CCSequence *seq = [CCSequence actions: animate,
                       [CCFlipX actionWithFlipX:NO],
                       [[animate copy] autorelease],
                       [CCFlipX actionWithFlipX:NO],
                       nil];
    id action1 = [CCRepeatForever actionWithAction: seq ];
    
    // 添加怪物动作
    [monsterSprite runAction:action1];
    // 添加怪物移动动作
    [monsterSprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    // 设置移动结束标示
    monsterSprite.tag =1;
    // 添加怪物列表
    [monsterArray addObject:monsterSprite];
}

// 通用精灵移动结束处理
-(void)generalMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
    
    if (sprite.tag ==1) { // 怪物
        [monsterArray removeObject:sprite];
        // 切换游戏结束场景
        [[CCDirector sharedDirector] replaceScene:[GameOver scene]];
    } else if (sprite.tag ==2) { // 子弹
        [bulletArray removeObject:sprite];
    }
}

// 怪物数量平衡控制
-(void)MonsterCounterpoise:(ccTime)dt
{
    // 添加怪物
    [self addMonster];
}

// 怪物尸体清理
-(void)deadMonsterClear:(ccTime)dt {
    if (deadMonsterArray.count <= 0) {
        return;
    }
    [self removeChild:[deadMonsterArray objectAtIndex:0] cleanup:YES];
    [deadMonsterArray removeObject:[deadMonsterArray objectAtIndex:0]];
}

// 子弹爆破效果清理
-(void)bulletedClear:(ccTime)dt {
    if (bulletedArray.count <= 0) {
        return;
    }
    [self removeChild:[bulletedArray objectAtIndex:0] cleanup:YES];
    [bulletedArray removeObject:[bulletedArray objectAtIndex:0]];
}

// 触摸事件处理
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (bulletSprite != nil) return;
    
    // 触摸对象设置
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // 系统尺寸
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // 初始化子弹精灵
    bulletSprite = [[CCSprite spriteWithFile:@"bullet.png"] retain];
    bulletSprite.position = ccp(20, winSize.height/2);
    
    // 触点坐标
    int offX = location.x - bulletSprite.position.x;
    int offY = location.y - bulletSprite.position.y;
    
    // 非法触点
    if (offX <=0) {
        // 释放子弹精灵
        [bulletSprite release];
        bulletSprite = nil;
        return;
    }
    
    // 子弹目标坐标
    int realX = winSize.width + (bulletSprite.contentSize.width/2);
    float ratio = (float) offY / (float) offX;
    int realY = (realX * ratio) + bulletSprite.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // 子弹移动速度计算
    int offRealX = realX - bulletSprite.position.x;
    int offRealY = realY - bulletSprite.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity =480/1; // 一秒48像素
    float realMoveDuration = length/velocity;
    
    // 大炮仰角设置
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle =-1* angleDegrees;
    float rotateSpeed =0.5/ M_PI; // 转动速度0.5秒半圈
    float rotateDuration = fabs(angleRadians * rotateSpeed); 
    // 大炮仰角移动动画
    [gunSprite runAction:[CCSequence actions:
                        [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                        [CCCallFunc actionWithTarget:self selector:@selector(shooted)],
                        nil]];
    // 大炮抖动动画
    id action10 = [CCScaleTo actionWithDuration:0.1 scale:0.5];
    id action11 = [CCScaleTo actionWithDuration:0.1 scale:1];
    id action21 = [CCSequence actions:action10, action11, nil];
    [gunSprite runAction:action21];
    
    // 子弹精灵移动
    [bulletSprite runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                                [CCCallFuncN actionWithTarget:self selector:@selector(generalMoveFinished:)],
                                nil]];
    
    // 播放大炮音效
    [[SimpleAudioEngine sharedEngine] playEffect:@"gun.caf"];
    
    // 甚至精灵标记
    bulletSprite.tag =2;
}

// 发射结束
- (void)shooted
{
    // 添加子弹精灵
    [self addChild:bulletSprite];
    [bulletArray addObject:bulletSprite];
    // 释放子弹精灵
    [bulletSprite release];
    bulletSprite = nil;
}

// 碰撞检测
- (void)collisionDetection:(ccTime)dt {
    // 删除子弹数组
    NSMutableArray *bulletDeleteArray = [[NSMutableArray alloc] init];
    
    // 循环子弹数组
    for (CCSprite *bullet in bulletArray) {
        // 子弹碰撞范围
        CGRect bulletRect = CGRectMake(
                                       bullet.position.x - (bullet.contentSize.width/2), 
                                       bullet.position.y - (bullet.contentSize.height/2), 
                                       bullet.contentSize.width, 
                                       bullet.contentSize.height);
        
        // 怪物删除数组
        NSMutableArray *monsterDeleteArray = [[NSMutableArray alloc] init];
        
        // 循环怪物并进行碰撞检测
        for (CCSprite *monster in monsterArray) {
            // 怪物碰撞范围
            CGRect monsterRect = CGRectMake(
                                           monster.position.x - (monster.contentSize.width/2), 
                                           monster.position.y - (monster.contentSize.height/2), 
                                           monster.contentSize.width, 
                                           monster.contentSize.height);
            
            // 子弹怪物碰撞检测
            if (CGRectIntersectsRect(bulletRect, monsterRect)) {
                // 检测到碰撞添加怪物删除列表
                [monsterDeleteArray addObject:monster]; 
                // 播放打中音效
                [[SimpleAudioEngine sharedEngine] playEffect:@"bulleted.caf"];
            } 
        }
        
        // 循环怪物死亡列表进行相应处理
        for (CCSprite *monster in monsterDeleteArray) {
            // 怪物死亡处理
            [self monsterDeadProcess:monster];
            // 加分
            [self addScore];
        }
        
        // 添加子弹删除列表
        if (monsterDeleteArray.count >0) {
            [bulletDeleteArray addObject:bullet];
        }
        
        // 释放怪物删除列表
        [monsterDeleteArray release];
    }
    
    // 循环子弹删除列表并删除子弹精灵
    for (CCSprite *bullet in bulletDeleteArray) {
        [bulletArray removeObject:bullet];
        [self removeChild:bullet cleanup:YES];
    }
    // 释放子弹删除列表
    [bulletDeleteArray release];
}

// 怪物死亡处理
-(void)monsterDeadProcess:(id)sender {
    // 怪物对象
    CCSprite *monster = (CCSprite *)sender;
    
    // 添加子弹爆破效果精灵
    CCSprite *bulleted = [CCSprite spriteWithFile:@"bulleted.png" rect:CGRectMake(0, 0, 27, 40)];
    bulleted.position = ccp(monster.position.x, monster.position.y);
    // 画出子弹爆破精灵
    [self addChild:bulleted];
    // 子弹爆破动画设置
    id action10 = [CCScaleTo actionWithDuration:0.1 scale:2];
    id action11 = [CCScaleTo actionWithDuration:0.1 scale:1];
    id action21 = [CCSequence actions:action10, action11, nil];
    [bulleted runAction:action21];
    // 添加子弹爆破精灵数组
    [bulletedArray addObject:bulleted];
    
    // 怪物尸体精灵
    CCSprite *deadMonster = [CCSprite spriteWithFile:@"deadmonster.png" rect:CGRectMake(0, 0, 40, 27)];
    deadMonster.position = ccp(monster.position.x, monster.position.y);
    // 淡化效果
    id action17 = [CCFadeTo actionWithDuration: 1 opacity:80];
    [deadMonster runAction:action17];
    // 画出怪物尸体
    [self addChild:deadMonster];
    // 添加怪物尸体数组
    [deadMonsterArray addObject:deadMonster];
    
    // 从怪物列表中删除怪物并清除屏幕
    [monsterArray removeObject:monster];
    [self removeChild:monster cleanup:YES];
}

// 加分
-(void)addScore
{
    // 系统数据存储
    NSUserDefaults *mainUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *highestScore = [mainUserDefaults stringForKey:@"highestScore"];
    
    // 分数累加器
    bulletedCount++;
    
    // 更新分数
    NSString *scoreLength = [[NSString alloc] initWithFormat:@"%d",bulletedCount];
    NSString *scoreTemp = [[NSString alloc] initWithFormat:@"%d",bulletedCount];
    for (int i=0; i<(5-scoreLength.length); i++) {
        scoreTemp = [@"0" stringByAppendingString:scoreTemp];
    }
    [mainUserDefaults setObject:scoreTemp forKey:@"nowScore"];
    NSString *scoreString = [[NSString alloc] initWithFormat:@"Score:%@ High:%@",scoreTemp,highestScore];
    [scoreLabel setString:scoreString];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    // 释放怪物数组
    [monsterArray release];
    monsterArray = nil;
    // 释放子弹数组
    [bulletArray release];
    bulletArray = nil;
    // 释放尸体数组
    [deadMonsterArray release];
    deadMonsterArray = nil;
    // 释放大炮精灵
    [gunSprite release];
    gunSprite = nil;
    // 释放背景精灵
    [backgroundSprite release];
    backgroundSprite = nil;
    // 移除放弃控制代理
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 释放Session
    [currentSession release];
    currentSession = nil;
    
	[super dealloc];
}
@end
