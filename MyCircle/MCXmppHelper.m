//
//  MCXmppHelper.m
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import "MCXmppHelper.h"
#import "XMPPAutoPing.h"
#import "XMPPReconnect.h"
//#import "XMPPRosterMemoryStorage.h"
#import "MCAppDelegate.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface MCXmppHelper()

@property (strong,nonatomic) CallBackVoid DidConnectCallBack;
@property (strong,nonatomic) CallBackVoid loginsuccess;
@property (strong,nonatomic) CallBackError loginfail;

@end

@implementation MCXmppHelper

-(id)init{
    if(self=[super init]){
        [self setupxmpp];
        self.host = XMPP_HOST;
        self.domain = XMPP_DOMAIN;
    }
    return self;
}

-(void)setupxmpp{
    self.xmppStream = [[XMPPStream alloc] init];
    
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    [self.xmppReconnect activate:self.xmppStream];    
//    [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];

    self.xmppAutoPing = [[XMPPAutoPing alloc] init];
	self.xmppAutoPing.pingInterval = 30;
	self.xmppAutoPing.pingTimeout = 3;
	self.xmppAutoPing.targetJID = [XMPPJID jidWithString:XMPP_HOST];

    [self.xmppAutoPing activate:self.xmppStream];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //花名册
//    self.xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
//    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterMemoryStorage];
//    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [self.xmppRoster activate:self.xmppStream];
    
}

//连接服务器
-(NSString *)connect:(NSString *)account host:(NSString *)host success:(CallBackVoid)DidConnect{
    self.DidConnectCallBack = DidConnect;
    //已连接服务器
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
    DLog(@"connect");
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
    DLog(@"did connect callback");
    self.DidConnectCallBack();
    
}

/*
//接收到好友状态更新
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    if ([presenceType isEqualToString:@"subscribe"]) {
        NewFriendEntity *entity=[[NewFriendEntity alloc] init];
        entity.jid=[[presence from] bare];
        entity.status=@"NO";
        [DbHelper InsertNewFriend:entity];
    }
}*/

//此方法在stream连接断开的时候调用
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    DLog(@"Did disconnect:%@", [error localizedDescription]);
//    self.DidDisConnectCallBack();
}

+ (MCXmppHelper *)sharedInstance
{
    MCAppDelegate *appDelegate = (MCAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(!appDelegate.xmppHepler)
        appDelegate.xmppHepler = [[MCXmppHelper alloc] init];
    return appDelegate.xmppHepler;
}

#pragma mark - XMPPAutoPing delegate
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender
{
	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
}

- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender
{
	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender
{
	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
}

@end
