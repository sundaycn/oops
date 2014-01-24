//
//  MCOrgBL.m
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import "MCOrgBL.h"

@implementation MCOrgBL

//插入Org方法
- (BOOL)create:(MCOrg *)model
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao create:model] ? 0 : -1;
}

//删除Org方法
- (BOOL)remove:(MCOrg *)model
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao remove:model] ? 0 : -1;
}

//通过OrgId删除Org方法
- (BOOL)removeByOrgId:(NSString *)orgId
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao removeByOrgId:orgId] ? 0 : -1;
}

//删除所有Org方法
- (BOOL)removeAll
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao removeAll] ? 0 : -1;
}

//查询所有组织id
- (NSArray *)findAllId
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao findAllId];
}

//查询所用数据方法
- (NSArray *)findAll
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao findAll];
}

@end
