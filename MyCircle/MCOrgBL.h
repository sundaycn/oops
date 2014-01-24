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

//查询所有组织id
- (NSArray *)findAllId;

//查询所用数据方法
- (NSArray *)findAll;

@end
