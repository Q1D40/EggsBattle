//
//  ViewController.h
//  lanya
//
//  Created by yang mu on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController <GKSessionDelegate,GKPeerPickerControllerDelegate> {
    //GKSession对象用于表现两个蓝牙设备之间连接的一个会话，你也可以使用它在两个设备之间发送和接收数据。
    GKSession *currentSession;
    
    IBOutlet UIButton *connect;
    IBOutlet UIButton *disconnect;
}

-(IBAction) btnConnect:(id) sender;
-(IBAction) btnDisconnect:(id) sender;
-(void)mySendDataToPeers:(NSData *)data;

@end
