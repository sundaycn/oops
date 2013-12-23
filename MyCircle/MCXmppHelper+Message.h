//
//  MCXmppHelper+Message.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import "MCXmppHelper.h"

@class MCMessage;
@interface MCXmppHelper (Message)

@property (nonatomic,strong) NSMutableDictionary *Messages;

//发送消息
- (void)sendMessage:(MCMessage *)message;

@end
