//
//  MCChatHistoryDAO.m
//  MyCircle
//
//  Created by Samuel on 12/16/13.
//
//

#import "MCChatHistoryDAO.h"

@implementation MCChatHistoryDAO

static MCChatHistoryDAO *sharedManager = nil;

+ (MCChatHistoryDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}

//插入消息
- (int)insert:(MCChatHistory *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCChatHistoryManagedObject *chatHistory = [NSEntityDescription insertNewObjectForEntityForName:@"MCChatHistory" inManagedObjectContext:cxt];
    
    chatHistory.from = model.from;
    chatHistory.to = model.to;
    chatHistory.message = model.message;
    chatHistory.time = model.time;
    chatHistory.isread = model.isread;
    chatHistory.type = model.type;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        //        DLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//删除所有历史消息记录
- (void)deleteAllHistory
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatHistory"
                                              inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *dataList = [cxt executeFetchRequest:request error:&error];
    for (NSManagedObject *managedObject in dataList) {
        [cxt deleteObject:managedObject];
        //NSLog(@"%@ object deleted",entityDescription);
    }
    
    [cxt setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    if (![cxt save:&error]) {
        //错误处理
        DLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
}

//根据聊天对象jid更新未读为已读
- (void)updateByJid:(NSString *)jid
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatHistory" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isread='NO' AND from=%@", jid];
    [request setPredicate:predicate];

    NSError *error;
    NSArray *result = [cxt executeFetchRequest:request error:&error];
    
    if(!error && result.count > 0)
    {
        for(MCChatHistory *obj in result)
        {
            obj.isread = @"YES";
        }
    }
    if([self.managedObjectContext hasChanges])
    {
        [self.managedObjectContext save:&error];
    }
}

//在聊天历史记录表中，根据双方jid查找未读消息
- (NSArray *)findUnreadMessageByJid:(NSString *)jid
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatHistory" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isread='NO' AND (from=%@ or to=%@)", jid, jid];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];

    for (MCChatHistoryManagedObject *mo in listData) {
        MCChatHistory *chatHistory = [[MCChatHistory alloc] init];
        chatHistory.from = mo.from;
        chatHistory.to = mo.to;
        chatHistory.message = mo.message;
        chatHistory.time = mo.time;
        chatHistory.isread = mo.isread;
        
        [resListData addObject:chatHistory];
    }
    return [resListData copy];
}

//在聊天历史记录表中，查找最近10条记录
- (NSArray *)findRecentMessageByType:(NSString *)type jid:(NSString *)jid myJid:(NSString *)myJid
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatHistory" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate;
    if ([type isEqualToString:MSG_TYPE_NORMAL_CHAT]) {
        predicate = [NSPredicate predicateWithFormat:@"(from=%@ AND to=%@) OR (from=%@ AND to=%@)", jid, myJid, myJid, jid];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"from=%@ AND to=%@ AND type=%@", jid, myJid, type];
    }
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    int listCount = listData.count;
    int loopTimes;
    if ([type isEqualToString:MSG_TYPE_NORMAL_CHAT]) {
        loopTimes = 10;
    }
    else {
        loopTimes = 3;
    }

    while (listCount > 0 && loopTimes > 0)
    {
        MCChatHistoryManagedObject *mo = [listData objectAtIndex:listCount-1];
        listCount--;
        MCChatHistory *chatHistory = [[MCChatHistory alloc] init];
        chatHistory.from = mo.from;
        chatHistory.to = mo.to;
        chatHistory.message = mo.message;
        chatHistory.time = mo.time;
        chatHistory.isread = mo.isread;
        [resListData addObject:chatHistory];
        loopTimes--;
    }
    return [resListData copy];
}

//在聊天历史记录表中，查找某个时间段内的记录
- (NSArray *)findSomeMessageByType:(NSString *)type time:(NSDate *)time jid:(NSString *)jid myJid:(NSString *)myJid
{
    // Define a date formatter for storage, full style for more flexibility
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    // Format back to a date using the same styles
    NSDate *dtime = [dateFormatter dateFromString:time];*/
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatHistory" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate;
    if ([type isEqualToString:MSG_TYPE_NORMAL_CHAT]) {
        predicate = [NSPredicate predicateWithFormat:@"((from=%@ AND to=%@) OR (from=%@ AND to=%@)) AND time<%@", jid, myJid, myJid, jid, time];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"from=%@ AND to=%@ AND type=%@ AND time<%@", jid, myJid, type, time];
    }
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    int listCount = listData.count;
    int loopTimes;
    if ([type isEqualToString:MSG_TYPE_NORMAL_CHAT]) {
        loopTimes = 10;
    }
    else {
        loopTimes = 5;
    }
    
    while (listCount > 0 && loopTimes > 0)
    {
        MCChatHistoryManagedObject *mo = [listData objectAtIndex:listCount-1];
        listCount--;
        MCChatHistory *chatHistory = [[MCChatHistory alloc] init];
        chatHistory.from = mo.from;
        chatHistory.to = mo.to;
        chatHistory.message = mo.message;
        chatHistory.time = mo.time;
        chatHistory.isread = mo.isread;
        [resListData addObject:chatHistory];
        loopTimes--;
    }

    return [resListData copy];
}

//获取未读消息数
- (NSInteger)fetchUnReadMsgCount
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatHistory" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isread='NO'"];
    [request setPredicate:predicate];

    NSError *error;
    NSArray *result = [cxt executeFetchRequest:request error:&error];
    return result.count;
}

@end
