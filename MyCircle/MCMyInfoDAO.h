//
//  MCMyInfoDAO.h
//  MyCircle
//
//  Created by Samuel on 4/4/14.
//
//

#import "MCCoreDataDAO.h"
#import "MCMyInfo.h"
#import "MCMyInfoManagedObject.h"

@interface MCMyInfoDAO : MCCoreDataDAO
+ (MCMyInfoDAO *)sharedManager;
//插入个人资料
- (int)insert:(MCMyInfo *)model;
//插入头像照片
- (int)insertAvatar:(NSData *)avatarImage byAccount:(NSString *)strAccount;
//删除个人资料
- (int)removeAll;
//查询个人资料
- (MCMyInfo *)findByAccount:(NSString *)strAccount;

@end
