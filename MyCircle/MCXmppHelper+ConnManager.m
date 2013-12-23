//
//  MCXmppHelper+ConnManager.m
//  MyCircle
//
//  Created by Samuel on 12/19/13.
//
//

#import "MCXmppHelper+ConnManager.h"

@implementation MCXmppHelper (ConnManager)

@dynamic xmppAutoPing;
//激活XMPP连接检测心跳
- (void)activeXmppHeartBeater:(NSString *)server
{
    self.xmppAutoPing = [[XMPPAutoPing alloc] init];
    if (server != nil)
    {
        //设置ping目标服务器,如果为nil,则监听socketstream当前连接上的那个服务器
        self.xmppAutoPing.targetJID = [XMPPJID jidWithString:server];
    }
    self.xmppAutoPing.respondsToQueries = YES;
    self.xmppAutoPing.pingInterval = 2;//ping 间隔时间 2s
    self.xmppAutoPing.pingTimeout = 10;
    [self.xmppAutoPing activate:self.xmppStream];
    [self.xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];

    
}

//取消XMPP连接检测心跳
- (void)deactiveXmppHeartBeater
{
    [self.xmppAutoPing deactivate];
    [self.xmppAutoPing removeDelegate:self];
}

#pragma mark - XMPPAutoPing delegate
- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender
{
    DLog(@"- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender");
}

- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender
{
    DLog(@"- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender");
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender
{
    DLog(@"- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender");
}

@end
