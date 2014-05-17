//
//  MCMicroManagerConfigDAO.h
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import "MCCoreDataDAO.h"
#import "MCMicroManagerConfig.h"

@interface MCMicroManagerConfigDAO : MCCoreDataDAO
+ (MCMicroManagerConfigDAO *)sharedManager;
//插入微管理功能模块配置
- (int)insert:(MCMicroManagerConfig *)model;
//修改微管理功能模块配置
- (int)update:(MCMicroManagerConfig *)model;
//删除所有微管理功能模块配置
- (int)deleteAll;
//查询微管理功能模块配置
- (MCMicroManagerConfig *)queryByCode:(NSString *)strCode;
//查询微管理功能模块配置
- (NSArray *)queryByWidgetCodes:(NSArray *)arrWidgetCodes;
//查询所有微管理功能模块配置
- (NSArray *)queryAll;
@end
