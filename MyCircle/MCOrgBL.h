//
//  MCOrgBL.h
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import <Foundation/Foundation.h>
#import "MCOrg.h"
#import "MCOrgDAO.h"

@interface MCOrgBL : NSObject

//插入Org方法
- (BOOL)create:(MCOrg *)model;

//删除Org方法
- (BOOL)remove:(MCOrg *)model;

//通过OrgId删除Org方法
- (BOOL)removeByOrgId:(NSString *)orgId;

//删除所有Org方法
- (BOOL)removeAll;

//更新指定组织的联系人数据版本号
- (BOOL)updateVersionByOrgId:(NSString *)orgId version:(NSString *)version;

//更新对应的联系人数据版本号
- (BOOL)updateAllVersion:(NSDictionary *)dictVersion;

//查询所有组织id
- (NSArray *)findAllId;

//获取当前所有联系人数据版本号
- (NSDictionary *)findAllVersion;

//根据orgId获取对应联系人数据版本号
- (NSString *)findVersionByOrgId:(NSString *)orgId;

//查询所用数据方法
- (NSArray *)findAll;

@end
