//
//  MCOrgDAO.h
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import <Foundation/Foundation.h>
#import "MCCoreDataDAO.h"
#import "MCOrgManagedObject.h"
#import "MCOrg.h"

@interface MCOrgDAO : MCCoreDataDAO

+ (MCOrgDAO *)sharedManager;

//插入Org方法
- (int)create:(MCOrg *)model;

//删除Org方法
- (int)remove:(MCOrg *)model;

//通过Id删除Org方法
- (int)removeByOrgId:(NSString *)orgId;

//删除所有Org方法
- (int)removeAll;

//修改Org方法
- (int)modify:(MCOrg *)model;

//查询所有组织id
- (NSArray *)findAllId;

//查询所有数据方法
- (NSArray *)findAll;

//按照主键查询数据方法
- (MCOrg *)findById:(MCOrg *)model;

@end
