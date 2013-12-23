//
//  MCChatHistoryDAO.h
//  MyCircle
//
//  Created by Samuel on 12/16/13.
//
//

#import "MCCoreDataDAO.h"
#import "MCChatHistoryManagedObject.h"
#import "MCChatHistory.h"

@interface MCChatHistoryDAO : MCCoreDataDAO

+ (MCChatHistoryDAO *)sharedManager;

// 插入消息
- (int)insert:(MCChatHistory *)model;
// 根据聊天对象jid更新未读为已读
- (void)updateByJid:(NSString *)jid;
// 在聊天历史记录表中，根据对方jid查找未读消息
- (NSArray *)findUnreadMessageByJid:(NSString *)jid;
//在聊天历史记录表中，查找最近10条记录
- (NSArray *)findRecentMessageByJid:(NSString *)jid myJid:(NSString *)myJid;
// 获取未读消息数
- (NSInteger)fetchUnReadMsgCount;

@end
