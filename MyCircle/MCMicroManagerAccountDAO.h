//
//  MCMicroManagerAccountDAO.h
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import "MCCoreDataDAO.h"
#import "MCMicroManagerAccount.h"

@interface MCMicroManagerAccountDAO : MCCoreDataDAO
+ (MCMicroManagerAccountDAO *)sharedManager;
//插入当前用户的微管理账号
- (int)insert:(MCMicroManagerAccount *)model;
//修改当前用户的微管理账号
- (int)update:(MCMicroManagerAccount *)model;
//删除当前用户的所有微管理账号
- (int)deleteAll;
//查询当前用户的微管理账号
- (NSArray *)queryAll;
@end
