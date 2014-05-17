//
//  MCMicroMangerDAO.h
//  MyCircle
//
//  Created by Samuel on 5/16/14.
//
//

#import "MCCoreDataDAO.h"
#import "MCMicroManager.h"

@interface MCMicroManagerDAO : MCCoreDataDAO
+ (MCMicroManagerDAO *)sharedManager;
//插入当前账号的微管理功能模块
- (int)insert:(MCMicroManager *)model;
//修改当前账号的微管理功能模块
- (int)update:(MCMicroManager *)model;
//删除当前账号的所有微管理功能模块
- (int)deleteAll;
//查询当前账号的所有微管理功能模块
- (NSArray *)queryAll;
//查询当前账号的所有微管理功能模块代码
- (NSArray *)queryAllCodes;
@end
