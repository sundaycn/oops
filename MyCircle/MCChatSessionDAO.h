//
//  MCChatSessionDAO.h
//  MyCircle
//
//  Created by Samuel on 12/16/13.
//
//

#import "MCCoreDataDAO.h"
#import "MCChatSessionManagedObject.h"
#import "MCChatSession.h"

@interface MCChatSessionDAO : MCCoreDataDAO

+ (MCChatSessionDAO *)sharedManager;
//插入消息
- (int)insert:(MCChatSession *)model;
//根据聊天对象key删除消息
- (int)remove:(MCChatSession *)model;
//查询所有消息
- (NSMutableArray*)findAll;

@end
