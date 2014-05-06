//
//  MCMyInfoDAO.m
//  MyCircle
//
//  Created by Samuel on 4/4/14.
//
//

#import "MCMyInfoDAO.h"

@implementation MCMyInfoDAO
static MCMyInfoDAO *sharedManager = nil;

+ (MCMyInfoDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager managedObjectContext];
        
    });
    return sharedManager;
}

//插入个人资料
- (int)insert:(MCMyInfo *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    MCMyInfoManagedObject *myInfo = [NSEntityDescription insertNewObjectForEntityForName:@"MCMyInfo" inManagedObjectContext:cxt];
    myInfo.address = myInfo.address;
    myInfo.birthday = model.birthday;
    myInfo.birthdayString = model.birthdayString;
    myInfo.cityId = model.cityId;
    myInfo.countyId = model.countyId;
    myInfo.createDate = model.createDate;
    myInfo.createDateString = model.createDateString;
    myInfo.createId = model.createId;
    myInfo.email = model.email;
    myInfo.gender = model.gender;
    myInfo.homepage = model.homepage;
    myInfo.id = model.id;
    myInfo.microBlog = model.microBlog;
    myInfo.mobile = model.mobile;
    myInfo.modifyDate = model.modifyDate;
    myInfo.modifyDateString = model.modifyDateString;
    myInfo.modifyId = model.modifyId;
    myInfo.openfireAcct = model.openfireAcct;
    myInfo.phone = model.phone;
    myInfo.photo = model.photo;
    myInfo.postNo = model.postNo;
    myInfo.provinceId = model.provinceId;
    myInfo.qqNo = model.qqNo;
    myInfo.signature = model.signature;
    myInfo.trade = model.trade;
    myInfo.userConcerns = model.userConcerns;
    myInfo.userName = model.userName;
    myInfo.weChatNo = model.weChatNo;
    
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        DLog(@"插入数据成功");
    } else {
        DLog(@"插入数据失败");
        return -1;
    }
    
    return 0;
}

//更新个人资料
- (int)modify:(MCMyInfo *)model
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMyInfo" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", model.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCMyInfoManagedObject *myInfo = [listData lastObject];
        myInfo.address = myInfo.address;
        myInfo.birthday = model.birthday;
        myInfo.birthdayString = model.birthdayString;
        myInfo.cityId = model.cityId;
        myInfo.countyId = model.countyId;
        myInfo.createDate = model.createDate;
        myInfo.createDateString = model.createDateString;
        myInfo.createId = model.createId;
        myInfo.email = model.email;
        myInfo.gender = model.gender;
        myInfo.homepage = model.homepage;
        myInfo.id = model.id;
        myInfo.microBlog = model.microBlog;
        myInfo.mobile = model.mobile;
        myInfo.modifyDate = model.modifyDate;
        myInfo.modifyDateString = model.modifyDateString;
        myInfo.modifyId = model.modifyId;
        myInfo.openfireAcct = model.openfireAcct;
        myInfo.phone = model.phone;
        myInfo.photo = model.photo;
        myInfo.postNo = model.postNo;
        myInfo.provinceId = model.provinceId;
        myInfo.qqNo = model.qqNo;
        myInfo.signature = model.signature;
        myInfo.trade = model.trade;
        myInfo.userConcerns = model.userConcerns;
        myInfo.userName = model.userName;
        myInfo.weChatNo = model.weChatNo;
        myInfo.avatarImage = model.avatarImage;
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            DLog(@"修改个人资料成功");
        } else {
            DLog(@"修改个人资料失败");
            return -1;
        }
    }
    
    return 0;
}

//插入头像照片
- (int)insertAvatar:(NSData *)avatarImage byAccount:(NSString *)strAccount
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMyInfo" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mobile = %@", strAccount];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MCMyInfoManagedObject *myInfo = [listData lastObject];
        myInfo.avatarImage = avatarImage;
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            DLog(@"插入头像图片成功");
        } else {
            DLog(@"插入头像图片失败");
            return -1;
        }
    }
    return 0;
}

//删除个人资料
- (int)removeAll
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMyInfo" inManagedObjectContext:cxt];
    
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

//查询个人资料
- (MCMyInfo *)findByAccount:(NSString *)strAccount
{
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MCMyInfo" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mobile = %@", strAccount];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    
    if ([listData count] > 0) {
        MCMyInfoManagedObject *model = [listData lastObject];
        
        MCMyInfo *myInfo = [[MCMyInfo alloc] init];
        myInfo.address = myInfo.address;
        myInfo.birthday = model.birthday;
        myInfo.birthdayString = model.birthdayString;
        myInfo.cityId = model.cityId;
        myInfo.countyId = model.countyId;
        myInfo.createDate = model.createDate;
        myInfo.createDateString = model.createDateString;
        myInfo.createId = model.createId;
        myInfo.email = model.email;
        myInfo.gender = model.gender;
        myInfo.homepage = model.homepage;
        myInfo.id = model.id;
        myInfo.microBlog = model.microBlog;
        myInfo.mobile = model.mobile;
        myInfo.modifyDate = model.modifyDate;
        myInfo.modifyDateString = model.modifyDateString;
        myInfo.modifyId = model.modifyId;
        myInfo.openfireAcct = model.openfireAcct;
        myInfo.phone = model.phone;
        myInfo.photo = model.photo;
        myInfo.postNo = model.postNo;
        myInfo.provinceId = model.provinceId;
        myInfo.qqNo = model.qqNo;
        myInfo.signature = model.signature;
        myInfo.trade = model.trade;
        myInfo.userConcerns = model.userConcerns;
        myInfo.userName = model.userName;
        myInfo.weChatNo = model.weChatNo;
        myInfo.avatarImage = model.avatarImage;
        
        return myInfo;
    }
    return nil;
}
@end
