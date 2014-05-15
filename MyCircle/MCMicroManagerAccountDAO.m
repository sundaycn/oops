//
//  MCMicroManagerAccountDAO.m
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import "MCMicroManagerAccountDAO.h"
#import "MCMicroManagerAccountMO.h"

@implementation MCMicroManagerAccountDAO
static MCMicroManagerAccountDAO *sharedManager = nil;

+ (MCMicroManagerAccountDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}

//插入当前用户的微管理账号
- (int)insert:(MCMicroManagerAccount *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCMicroManagerAccountMO *microManagerAccount = [NSEntityDescription insertNewObjectForEntityForName:@"MCMicroManagerAccount" inManagedObjectContext:cxt];
    microManagerAccount.userId = model.userId;
    microManagerAccount.userCode = model.userCode;
    microManagerAccount.userName = model.userName;
    microManagerAccount.gender = model.gender;
    microManagerAccount.acctId = model.acctId;
    microManagerAccount.acctName = model.acctName;
    microManagerAccount.belongOrgId = model.belongOrgId;
    microManagerAccount.orgName = model.orgName;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        DLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//修改当前用户的微管理账号
- (int)update:(MCMicroManagerAccount *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerAccount" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"acctId = %@", model.acctId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCMicroManagerAccountMO *microManagerAccount = [listData lastObject];
        microManagerAccount.userId = model.userId;
        microManagerAccount.userCode = model.userCode;
        microManagerAccount.userName = model.userName;
        microManagerAccount.gender = model.gender;
        microManagerAccount.acctId = model.acctId;
        microManagerAccount.acctName = model.acctName;
        microManagerAccount.belongOrgId = model.belongOrgId;
        microManagerAccount.orgName = model.orgName;
        
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

//删除当前用户的所有微管理账号
- (int)deleteAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerAccount" inManagedObjectContext:cxt];
    
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

//查询当前用户的微管理账号
- (NSArray *)queryAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerAccount" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", strCode];
//    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    for (MCMicroManagerAccountMO *mo in listData) {
        MCMicroManagerAccount *microManagerAccount = [[MCMicroManagerAccount alloc] init];
        microManagerAccount.userId = mo.userId;
        microManagerAccount.userCode = mo.userCode;
        microManagerAccount.userName = mo.userName;
        microManagerAccount.gender = mo.gender;
        microManagerAccount.acctId = mo.acctId;
        microManagerAccount.acctName = mo.acctName;
        microManagerAccount.belongOrgId = mo.belongOrgId;
        microManagerAccount.orgName = mo.orgName;
        
        [resListData addObject:microManagerAccount];
    }

    return [resListData copy];
}
@end
