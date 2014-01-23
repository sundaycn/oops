//
//  MCOrgDAO.m
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import "MCOrgDAO.h"

@implementation MCOrgDAO

static MCOrgDAO *sharedManager = nil;

+ (MCOrgDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}


//插入org方法
-(int) create:(MCOrg *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCOrgManagedObject *org = [NSEntityDescription insertNewObjectForEntityForName:@"MCOrg" inManagedObjectContext:cxt];
    org.id = model.id;
    org.name = model.name;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        DLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//删除org方法
-(int) remove:(MCOrg *)model
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCOrg" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@", model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCOrgManagedObject *org = [listData lastObject];
        [self.managedObjectContext deleteObject:org];
        
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

//通过orgId删除org方法
-(int) removeByOrgId:(NSString *)orgId
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCOrg" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@", orgId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *listData = [NSMutableArray arrayWithArray:[cxt executeFetchRequest:request error:&error]];
    while ([listData count] > 0) {
        MCOrgManagedObject *org = [listData lastObject];
        [self.managedObjectContext deleteObject:org];
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            DLog(@"删除数据成功");
            [listData removeLastObject];
        } else {
            DLog(@"删除数据失败");
            return -1;
        }
    }
    
    return 0;
}


//删除所有org方法
-(int) removeAll
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCOrg" inManagedObjectContext:cxt];
    
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


//修改org方法
-(int) modify:(MCOrg *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCOrg" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@", model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCOrgManagedObject *org = [listData lastObject];
        org.name = model.name;
        
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

//查询所有组织id
- (NSArray *)findAllId
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCOrg" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    //    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCOrgManagedObject *mo in listData) {
        [resListData addObject:mo.id];
    }
    
    return [resListData copy];
}

//查询所有数据方法
- (NSMutableArray *)findAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCOrg" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
//    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCOrgManagedObject *mo in listData) {
        MCOrg *org = [[MCOrg alloc] init];
        org.id = mo.id;
        org.name = mo.name;
        
        [resListData addObject:org];
    }
    
    return resListData;
}

//按照主键查询数据方法
-(MCOrg *) findById:(MCOrg *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCOrg" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@",model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    if ([listData count] > 0) {
        MCOrgManagedObject *mo = [listData lastObject];
        
        MCOrg *org = [[MCOrg alloc] init];
        org.id = mo.id;
        org.name = mo.name;
        
        return org;
    }
    return nil;
}

@end
