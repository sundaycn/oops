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

//更新指定组织的联系人数据版本号
- (BOOL)updateVersionByOrgId:(NSString *)orgId version:(NSString *)version
{
    MCOrgDAO *dao = [[MCOrgDAO alloc] init];
    return [dao updateVersionByOrgId:orgId version:version] ? 0 : -1;
}

//更新对应的联系人数据版本号
- (BOOL)updateAllVersion:(NSDictionary *)dictVersion
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao updateAllVersion:dictVersion] ? 0 : -1;
}

//查询所有组织id
- (NSArray *)findAllId
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao findAllId];
}

//获取当前所有联系人数据版本号
- (NSDictionary *)findAllVersion
{
    MCOrgDAO *dao = [[MCOrgDAO alloc] init];
    return [dao findAllVersion];
}

//根据orgId获取对应联系人数据版本号
- (NSString *)findVersionByOrgId:(NSString *)orgId
{
    MCOrgDAO *dao = [[MCOrgDAO alloc] init];
    return [dao findVersionByOrgId:orgId];
}

//查询所用数据方法
- (NSArray *)findAll
{
    MCOrgDAO *dao = [MCOrgDAO sharedManager];
    return [dao findAll];
}

@end
