//
//  XmppHelper.m
//  iShareSomething
//
//  Created by Samuel on 12/11/13.
//  Copyright (c) 2013年 Samuel. All rights reserved.
//

#import "XmppHelper.h"
#import "MCAppDelegate.h"
#import <XMPPFramework/XMPPRosterMemoryStorage.h>
#import <XMPPFramework/XMPPRoster.h>
//#import "XMPPStream.h"
//#import "XMPPRoster.h"
//#import "NSDefaultUserInfo.h"
//#import "XMPPvCardTempModule.h"
//#import "XMPPvCardTemp.h"
#import "DbHelper.h"
#import "NewFriendEntity.h"
@interface XmppHelper()

@property (strong,nonatomic) CallBackVoid DidConnectCallBack;
@property (strong,nonatomic) CallBackVoid loginsuccess;
@property (strong,nonatomic) CallBackError loginfail;

@end

@implementation XmppHelper

-(id)init{
    if(self=[super init]){
        [self setupxmpp];
        self.host=XMPP_HOST;
        self.domain=XMPP_DOMAIN;
    }
    return self;
}

-(void)setupxmpp{
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //花名册
    self.xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterMemoryStorage];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster activate:self.xmppStream];
    
}

//连接服务器
-(NSString *)connect:(NSString *)account host:(NSString *)host success:(CallBackVoid)DidConnect{
    self.DidConnectCallBack=DidConnect;
    //已经连接到服务器
    if (![self.xmppStream isDisconnected]) {
        return @"Y";
    }
    
    //连接服务器
    if (account == nil) {
        return @"未填写账号";
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:account]];
    [self.xmppStream setHostName:host];
    
    NSError *err = nil;
    if (![self.xmppStream connectWithTimeout:30 error:&err]) {
        return @"无法连接服务器";
    }
    
    return @"Y";
}

-(void)disconnect{
    [self goOffline];
    [self.xmppStream disconnect];
}

- (void)goOnline {
	XMPPPresence *presence = [XMPPPresence presence];
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline {
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}

//此方法在stream开始连接服务器的时候调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    self.DidConnectCallBack();

}

//接受到好友状态更新
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
//    if ([presenceType isEqualToString:@"subscribe"]) {
//        NewFriendEntity *entity=[[NewFriendEntity alloc] init];
//        entity.jid=[[presence from] bare];
//        entity.status=@"NO";
//        [DbHelper InsertNewFriend:entity];
//    }
}

//此方法在stream连接断开的时候调用
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    self.DidDisConnectCallBack();
}

+ (XmppHelper *)Instance{
    MCAppDelegate *appdel= (MCAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appdel.xmppHepler==nil)
        appdel.xmppHepler=[[XmppHelper alloc] init];
    return appdel.xmppHepler;
}
@end
