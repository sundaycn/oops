//
//  MCXmppHelper+ConnManager.h
//  MyCircle
//
//  Created by Samuel on 12/19/13.
//
//

#import "MCXmppHelper.h"

@interface MCXmppHelper (ConnManager)

@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;

//激活XMPP连接检测心跳
- (void)activeXmppHeartBeater:(NSString *)server;
//取消XMPP连接检测心跳
- (void)deactiveXmppHeartBeater;

@end
