//
//  MCDeptDAO.m
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import "MCDeptDAO.h"

@implementation MCDeptDAO

static MCDeptDAO *sharedManager = nil;

+ (MCDeptDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}


//插入dept方法
-(int) create:(MCDept *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCDeptManagedObject *dept = [NSEntityDescription insertNewObjectForEntityForName:@"MCDept" inManagedObjectContext:cxt];
    dept.id = model.id;
    dept.name = model.name;
    dept.sort = model.sort;
    dept.status = model.status;
    dept.syncFlag = model.syncFlag;
    dept.upDepartmentId = model.upDepartmentId;
    dept.belongOrgId = model.belongOrgId;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
//        DLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//删除dept方法
-(int) remove:(MCDept *)model
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCDept" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@", model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCDeptManagedObject *dept = [listData lastObject];
        [self.managedObjectContext deleteObject:dept];
        
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

//通过belongOrgId删除dept方法
-(int) removeByOrgId:(NSString *)orgId
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCDept" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"belongOrgId = %@", orgId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *listData = [NSMutableArray arrayWithArray:[cxt executeFetchRequest:request error:&error]];
    while ([listData count] > 0) {
        MCDeptManagedObject *dept = [listData lastObject];
        [self.managedObjectContext deleteObject:dept];
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            //            DLog(@"删除数据成功");
            [listData removeLastObject];
        } else {
            DLog(@"删除数据失败");
            return -1;
        }
    }
    
    return 0;
}


//删除所有dept方法
-(int) removeAll
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCDept" inManagedObjectContext:cxt];
    
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


//修改dept方法
-(int) modify:(MCDept *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCDept" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@", model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCDeptManagedObject *dept = [listData lastObject];
        dept.name = model.name;
        
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

//查询所有数据方法
-(NSMutableArray*) findAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCDept" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCDeptManagedObject *mo in listData) {
        MCDept *dept = [[MCDept alloc] init];
        dept.id = mo.id;
        dept.name = mo.name;
        dept.sort = mo.sort;
        dept.status = mo.status;
        dept.syncFlag = mo.syncFlag;
        dept.upDepartmentId = mo.upDepartmentId;
        dept.belongOrgId = mo.belongOrgId;
        
        [resListData addObject:dept];
    }
    
    return resListData;
}

//按照upDepartmentId查询数据方法
-(NSMutableArray *) findByUpDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)upDeptId
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCDept" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(upDepartmentId == %@) AND (belongOrgId == %@)",upDeptId,belongOrgId];;
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCDeptManagedObject *mo in listData) {
        MCDept *dept = [[MCDept alloc] init];
        dept.id = mo.id;
        dept.name = mo.name;
        dept.sort = mo.sort;
        dept.status = mo.status;
        dept.syncFlag = mo.syncFlag;
        dept.upDepartmentId = mo.upDepartmentId;
        dept.belongOrgId = mo.belongOrgId;
        
        [resListData addObject:dept];
    }
    return resListData;
}


//按照主键查询数据方法
-(MCDept *) findById:(MCDept *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCDept" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@",model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    if ([listData count] > 0) {
        MCDeptManagedObject *mo = [listData lastObject];
        
        MCDept *dept = [[MCDept alloc] init];
        dept.id = mo.id;
        dept.name = mo.name;
        dept.sort = mo.sort;
        dept.status = mo.status;
        dept.syncFlag = mo.syncFlag;
        dept.upDepartmentId = mo.upDepartmentId;
        dept.belongOrgId = mo.belongOrgId;
        
        return dept;
    }
    return nil;
}

@end
