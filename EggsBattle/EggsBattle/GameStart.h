//
//  HelloWorldLayer.h
//  GameTest
//
//  Created by yang mu on 12-4-11.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <GameKit/GameKit.h>

// HelloWorldLayer
@interface GameStart : CCLayerColor <GKSessionDelegate,GKPeerPickerControllerDelegate> {
    // 怪物数组
    NSMutableArray *monsterArray;
    // 死亡怪物数组
    NSMutableArray *deadMonsterArray;
    // 子弹数组
    NSMutableArray *bulletArray;
    // 爆炸子弹数组
    NSMutableArray *bulletedArray;
    // 大炮精灵
    CCSprite *gunSprite;
    // 子弹精灵
    CCSprite *bulletSprite;
    // 背景精灵
    CCSprite *backgroundSprite;
    // 暂停背景精灵
    CCSprite *pauseBackgroundSprite;
    // 暂停菜单
    CCMenu *pauseMenu;
    // 返回及其他按钮菜单
    CCMenu *resumeAndOthersMenu;
    // 得分显示
    CCLabelTTF *scoreLabel;
    // 打中统计
    int bulletedCount;
    GKSession *currentSession;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

// 初始化背景
-(void)initBackground;
// 初始化大炮
-(void)initGun;
// 初始化得分显示
-(void)initScoreShow;
// 初始化所有数组
-(void)initAllArray;
// 初始化触摸设置
-(void)initTouchSet;
// 初始化计时器
-(void)initSchedule;
// 播放背景音乐
-(void)playBackgroundSound;
// 怪物死亡处理
-(void)monsterDeadProcess:(id)sender;
// 加分
-(void)addScore;
// 画所有东西
-(void)drawAllThings;
// 画边框
-(void)drawFrame;
// 画暂停按钮
-(void)drawPause;
// 显示返回及其他按钮菜单
-(void)showResumeAndOthersMenu;
// 关闭返回及其他按钮菜单
-(void)closeResumeAndOthersMenu;

@end
