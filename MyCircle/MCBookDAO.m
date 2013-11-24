//
//  MCBookDAO.m
//  MyCircle
//
//  Created by Samuel on 10/16/13.
//
//

#import "MCBookDAO.h"

@implementation MCBookDAO

static MCBookDAO *sharedManager = nil;

+ (MCBookDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}


//插入Book方法
-(int) create:(MCBook *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCBookManagedObject *book = [NSEntityDescription insertNewObjectForEntityForName:@"MCBook" inManagedObjectContext:cxt];
    //[book setValue:model.id forKey:@"id"];
    //[book setValue:model.name forKey:@"name"];
    //[book setValue:model.sort forKey:@"sort"];    
    book.id = model.id;
    book.name = model.name;
    book.mobilePhone = model.mobilePhone;
    book.officePhone = model.officePhone;
    book.homePhone = model.homePhone;
    book.mobileShort = model.mobileShort;
    book.faxNumber = model.faxNumber;
    book.email = model.email;
    book.position = model.position;
    book.sort = model.sort;
    book.status = model.status;
    book.syncFlag = model.syncFlag;
    book.belongDepartmentId = model.belongDepartmentId;
    book.belongOrgId = model.belongOrgId;
    book.searchId = model.searchId;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
//        NSLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//删除Book方法
-(int) remove:(MCBook *)model
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id =  %@", model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCBookManagedObject *book = [listData lastObject];
        [self.managedObjectContext deleteObject:book];
        
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

//通过belongOrgId删除Book方法
-(int) removeByOrgId:(NSString *)orgId
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"belongOrgId = %@", orgId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *listData = [NSMutableArray arrayWithArray:[cxt executeFetchRequest:request error:&error]];
    while ([listData count] > 0) {
        MCBookManagedObject *book = [listData lastObject];
        [self.managedObjectContext deleteObject:book];
        
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


//删除所有Book方法
-(int) removeAll
{
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
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


//修改Book方法
-(int) modify:(MCBook *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id =  %@", model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCBookManagedObject *book = [listData lastObject];
        book.name = model.name;
        
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
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCBookManagedObject *mo in listData) {
        MCBook *book = [[MCBook alloc] init];
//        book.id = mo.id;
        book.name = mo.name;
        book.mobilePhone = mo.mobilePhone;
//        book.officePhone = mo.officePhone;
//        book.position = mo.position;
//        book.sort = mo.sort;
//        book.status = mo.status;
//        book.syncFlag = mo.syncFlag;
//        book.belongDepartmentId = mo.belongDepartmentId;
//        book.belongOrgId = mo.belongOrgId;
        book.searchId = mo.searchId;

        [resListData addObject:book];
    }
    
    return resListData;
}

//按照belongDepartmentId查询数据方法
-(NSMutableArray *) findByBelongDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)belongDeptId
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(belongDepartmentId == %@) AND (belongOrgId == %@)",belongDeptId,belongOrgId];;
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (MCBookManagedObject *mo in listData) {
        MCBook *book = [[MCBook alloc] init];
        book.id = mo.id;
        book.name = mo.name;
        
        [resListData addObject:book];
    }
    return resListData;
}

//按照主键查询数据方法
-(MCBook *) findById:(NSString *)bookId
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"id = %@",bookId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    if ([listData count] > 0) {
        MCBookManagedObject *mo = [listData lastObject];
        
        MCBook *book = [[MCBook alloc] init];
        book.id = mo.id;
        book.name = mo.name;
        book.mobilePhone = mo.mobilePhone;
        book.officePhone = mo.officePhone;
        book.homePhone = mo.homePhone;
        book.mobileShort = mo.mobileShort;
        book.faxNumber = mo.faxNumber;
        book.email = mo.email;
        book.position = mo.position;
//        book.sort = mo.sort;
//        book.status = mo.status;
//        book.syncFlag = mo.syncFlag;
//        book.belongDepartmentId = mo.belongDepartmentId;
//        book.belongOrgId = mo.belongOrgId;
        
        return book;
    }
    return nil;
}

-(MCBook *) findBySearchId:(NSNumber *)searchId
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCBook" inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"searchId = %@",searchId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    if ([listData count] > 0) {
        MCBookManagedObject *mo = [listData lastObject];
        
        MCBook *book = [[MCBook alloc] init];
        book.id = mo.id;
        book.name = mo.name;
        book.mobilePhone = mo.mobilePhone;
//        book.officePhone = mo.officePhone;
        book.position = mo.position;
        book.belongDepartmentId = mo.belongDepartmentId;
        book.belongOrgId = mo.belongOrgId;
        
        return book;
    }
    return nil;
}

@end
