//
//  MCChatSessionDAO.m
//  MyCircle
//
//  Created by Samuel on 12/16/13.
//
//

#import "MCChatSessionDAO.h"

@implementation MCChatSessionDAO

static MCChatSessionDAO *sharedManager = nil;

+ (MCChatSessionDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}

//插入消息
- (int)insert:(MCChatSession *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCChatSessionManagedObject *chatSession = [NSEntityDescription insertNewObjectForEntityForName:@"MCChatSession" inManagedObjectContext:cxt];
    chatSession.key = model.key;
    chatSession.lastmsg = model.lastmsg;
    chatSession.time = model.time;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        //        NSLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//根据聊天对象key删除消息
- (int)remove:(MCChatSession *)model
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatSession" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"key = %@", model.key];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCChatSessionManagedObject *chatSession = [listData lastObject];
        [self.managedObjectContext deleteObject:chatSession];
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            DLog(@"删除数据成功");
        } else {
            DLog(@"删除数据失败");
            return -1;
        }
    }
    
    return 0;
}

//删除所有历史消息记录
- (void)deleteAllSession
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatSession"
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

//查询所有消息
- (NSMutableArray*)findAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCChatSession" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCChatSessionManagedObject *mo in listData) {
        MCChatSession *chatSession = [[MCChatSession alloc] init];
        chatSession.key = mo.key;
        chatSession.lastmsg = mo.lastmsg;
        chatSession.time = mo.time;
        
        [resListData addObject:chatSession];
    }
    
    return resListData;
}

@end
