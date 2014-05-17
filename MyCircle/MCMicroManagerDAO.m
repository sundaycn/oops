//
//  MCMicroMangerDAO.m
//  MyCircle
//
//  Created by Samuel on 5/16/14.
//
//

#import "MCMicroManagerDAO.h"
#import "MCMicroManagerMO.h"

@implementation MCMicroManagerDAO
static MCMicroManagerDAO *sharedManager = nil;

+ (MCMicroManagerDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}

//插入当前账号的微管理功能模块
- (int)insert:(MCMicroManager *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCMicroManagerMO *microManager = [NSEntityDescription insertNewObjectForEntityForName:@"MCMicroManager" inManagedObjectContext:cxt];
    microManager.code = model.code;
    microManager.defaultShow = model.defaultShow;
    microManager.loginIfNeed = model.loginIfNeed;
    microManager.isTodo = model.isTodo;
    microManager.todoAmount = model.todoAmount;
    microManager.sort = model.sort;
    microManager.belongPhone = model.belongPhone;
    microManager.belongAccountId = model.belongAccountId;
    microManager.belongAccountName = model.belongAccountName;
    microManager.belongUserId = model.belongUserId;
    microManager.belongUserCode = model.belongUserCode;
    microManager.belongUserName = model.belongUserName;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        DLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//修改当前账号的微管理功能模块
- (int)update:(MCMicroManager *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManager" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@ AND belongAccountId = %@", model.code, model.belongAccountId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCMicroManagerMO *microManager = [listData lastObject];
        microManager.code = model.code;
        microManager.defaultShow = model.defaultShow;
        microManager.loginIfNeed = model.loginIfNeed;
        microManager.isTodo = model.isTodo;
        microManager.todoAmount = model.todoAmount;
        microManager.sort = model.sort;
        microManager.belongPhone = model.belongPhone;
        microManager.belongAccountId = model.belongAccountId;
        microManager.belongAccountName = model.belongAccountName;
        microManager.belongUserId = model.belongUserId;
        microManager.belongUserCode = model.belongUserCode;
        microManager.belongUserName = model.belongUserName;
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            DLog(@"修改数据成功");
        } else {
            DLog(@"修改数据失败");
            return -1;
        }
    }
    
    return 0;
}

//删除当前账号的所有微管理功能模块
- (int)deleteAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManager" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *dataList = [cxt executeFetchRequest:request error:&error];
    for (NSManagedObject *managedObject in dataList) {
        [cxt deleteObject:managedObject];
        //NSLog(@"%@ object deleted",entityDescription);
    }
    
    if (![cxt save:&error]) {
        //错误处理
        DLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    return 0;
}

//查询当前账号的所有微管理功能模块
- (NSArray *)queryAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManager" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", strCode];
    //    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    for (MCMicroManagerMO *mo in listData) {
        MCMicroManager *microManager = [[MCMicroManager alloc] init];
        microManager.code = mo.code;
        microManager.defaultShow = mo.defaultShow;
        microManager.loginIfNeed = mo.loginIfNeed;
        microManager.isTodo = mo.isTodo;
        microManager.todoAmount = mo.todoAmount;
        microManager.sort = mo.sort;
        microManager.belongPhone = mo.belongPhone;
        microManager.belongAccountId = mo.belongAccountId;
        microManager.belongAccountName = mo.belongAccountName;
        microManager.belongUserId = mo.belongUserId;
        microManager.belongUserCode = mo.belongUserCode;
        microManager.belongUserName = mo.belongUserName;
        [resListData addObject:microManager];
    }
    
    return [resListData copy];
}

//查询当前账号的所有微管理功能模块代码
- (NSArray *)queryAllCodes
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManager" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", strCode];
    //    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    for (MCMicroManagerMO *mo in listData) {
        [resListData addObject:mo.code];
    }
    
    return [resListData copy];
}
@end
