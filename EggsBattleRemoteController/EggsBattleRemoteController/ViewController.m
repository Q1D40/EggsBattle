//
//  ViewController.m
//  lanya
//
//  Created by yang mu on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [connect setHidden:NO];
    [disconnect setHidden:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  
{
    // 震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // 获取触摸点蓝牙传输坐标
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:[touch view]];
    
    NSString *xx = [[NSString alloc] initWithFormat:@"%f",point.x];
    NSString *yy = [[NSString alloc] initWithFormat:@"%f",point.y];
    NSString *xxyy = [[NSString alloc] init];
    
    xxyy = [xx stringByAppendingString:@"-"];
    xxyy = [xxyy stringByAppendingString:yy];
    
    NSData* data;
    NSString *str = [NSString stringWithString:xxyy];
    data = [str dataUsingEncoding: NSASCIIStringEncoding];
    [self mySendDataToPeers:data];
}

// 打开蓝牙使配选择框
-(IBAction) btnConnect:(id) sender{
    
    GKPeerPickerController *picker= [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    //connectionTypesMask用户可以选择的连接类型，包括两种类型：GKPeerPickerConnectionTypeNearby和GKPeerPickerConnectionTypeOnline。对于蓝牙通信，使用GKPeerPickerConnectionTypeNearby常量，GKPeerPickerConnectionTypeOnline常量表示基于互联网的连接。
    [connect setHidden:YES];
    [disconnect setHidden:NO];
    [picker show];
    
}

// 关闭蓝牙连接
-(IBAction) btnDisconnect:(id) sender{
    [currentSession disconnectFromAllPeers];
    currentSession = nil;
    [connect setHidden:NO];
    [disconnect setHidden:YES];
}

// 蓝牙连接到设备
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session {
    //将蓝牙连接的回话session保存为当前的session
    currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    // 关闭蓝牙匹配选择框
    [picker dismiss];
}

// 蓝牙匹配选择框点击取消事件
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    
    [connect setHidden:NO];
    [disconnect setHidden:YES];
}

// 蓝牙连接状态
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state){
        case GKPeerStateConnected:
            NSLog(@"connected");
            break;
            
        case GKPeerStateDisconnected:
            NSLog(@"disconnected");
            currentSession = nil;
            [connect setHidden:NO];
            [disconnect setHidden:YES];
            break;
        default:
            break;
    }
}

// 发送蓝牙传输数据
-(void)mySendDataToPeers:(NSData *) data{
    if (currentSession)
        [currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}

// 接受蓝牙传输数据
-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    
    NSString* str;
    str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data received"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
