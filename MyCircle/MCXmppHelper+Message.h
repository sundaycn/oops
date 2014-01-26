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
//删除最后一条聊天记录
- (void)removeLastMessage:(NSString *)key;
//删除所有聊天记录
- (void)removeAllMessages;
//删除最后一条聊天记录
- (void)removeLastMessageFromDB:(NSString *)key;

@end
