//
//  MCMicroManagerConfigDAO.m
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import "MCMicroManagerConfigDAO.h"
#import "MCMicroManagerConfigMO.h"

@implementation MCMicroManagerConfigDAO
static MCMicroManagerConfigDAO *sharedManager = nil;

+ (MCMicroManagerConfigDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}

//插入微管理功能模块配置
- (int)insert:(MCMicroManagerConfig *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCMicroManagerConfigMO *microManagerConfig = [NSEntityDescription insertNewObjectForEntityForName:@"MCMicroManagerConfig" inManagedObjectContext:cxt];
    microManagerConfig.code = model.code;
    microManagerConfig.name = model.name;
    microManagerConfig.iconImage = model.iconImage;
    microManagerConfig.pagePath = model.pagePath;
    microManagerConfig.sort = model.sort;
    microManagerConfig.upCode = model.upCode;
    microManagerConfig.type = model.type;
    microManagerConfig.defaultShow = model.defaultShow;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        DLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//修改微管理功能模块配置
- (int)update:(MCMicroManagerConfig *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerConfig" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", model.code];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCMicroManagerConfigMO *microManagerConfig = [listData lastObject];
        microManagerConfig.code = model.code;
        microManagerConfig.name = model.name;
        microManagerConfig.iconImage = model.iconImage;
        microManagerConfig.pagePath = model.pagePath;
        microManagerConfig.sort = model.sort;
        microManagerConfig.upCode = model.upCode;
        microManagerConfig.type = model.type;
        microManagerConfig.defaultShow = model.defaultShow;
        
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

//删除所有微管理功能模块配置
- (int)deleteAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerConfig" inManagedObjectContext:cxt];
    
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

//查询微管理功能模块配置
- (MCMicroManagerConfig *)queryByCode:(NSString *)strCode
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerConfig" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", strCode];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    if ([listData count] > 0) {
        MCMicroManagerConfigMO *model = [listData lastObject];
        MCMicroManagerConfig *microManagerConfig = [[MCMicroManagerConfig alloc] init];
        microManagerConfig.code = model.code;
        microManagerConfig.name = model.name;
        microManagerConfig.iconImage = model.iconImage;
        microManagerConfig.pagePath = model.pagePath;
        microManagerConfig.sort = model.sort;
        microManagerConfig.upCode = model.upCode;
        microManagerConfig.type = model.type;
        microManagerConfig.defaultShow = model.defaultShow;
        
        return microManagerConfig;
    }
    return nil;
}

//查询微管理功能模块配置
- (NSArray *)queryByWidgetCodes:(NSArray *)arrWidgetCodes
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerConfig" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(code IN %@)", arrWidgetCodes];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCMicroManagerConfigMO *mo in listData) {
        
        MCMicroManagerConfig *microManagerConfig = [[MCMicroManagerConfig alloc] init];
        microManagerConfig.code = mo.code;
        microManagerConfig.name = mo.name;
        microManagerConfig.iconImage = mo.iconImage;
        microManagerConfig.pagePath = mo.pagePath;
        microManagerConfig.sort = mo.sort;
        microManagerConfig.upCode = mo.upCode;
        microManagerConfig.type = mo.type;
        microManagerConfig.defaultShow = mo.defaultShow;
        
        [resListData addObject:microManagerConfig];
    }
    return [resListData copy];
}

//查询所有微管理功能模块配置
- (NSArray *)queryAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMicroManagerConfig" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCMicroManagerConfigMO *mo in listData) {
        
        MCMicroManagerConfig *microManagerConfig = [[MCMicroManagerConfig alloc] init];
        microManagerConfig.code = mo.code;
        microManagerConfig.name = mo.name;
        microManagerConfig.iconImage = mo.iconImage;
        microManagerConfig.pagePath = mo.pagePath;
        microManagerConfig.sort = mo.sort;
        microManagerConfig.upCode = mo.upCode;
        microManagerConfig.type = mo.type;
        microManagerConfig.defaultShow = mo.defaultShow;
        
        [resListData addObject:microManagerConfig];
    }
    return [resListData copy];
}
@end
