//
//  MCDeptBL.m
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import "MCDeptBL.h"

@implementation MCDeptBL

//插入Dept方法
-(BOOL) create:(MCDept *)model
{
    MCDeptDAO *dao = [MCDeptDAO sharedManager];
    return [dao create:model] ? 0 : -1;
}

//删除Dept方法
-(BOOL) remove:(MCDept *)model
{
    MCDeptDAO *dao = [MCDeptDAO sharedManager];
    return [dao remove:model] ? 0 : -1;
}

//通过belongOrgId删除Dept方法
-(BOOL) removeByOrgId:(NSString *)orgId
{
    MCDeptDAO *dao = [MCDeptDAO sharedManager];
    return [dao removeByOrgId:orgId] ? 0 : -1;
}

//删除所有Dept方法
-(BOOL) removeAll
{
    MCDeptDAO *dao = [MCDeptDAO sharedManager];
    return [dao removeAll] ? 0 : -1;
}

//查询所用数据方法
-(NSMutableArray*) findAll
{
    MCDeptDAO *dao = [MCDeptDAO sharedManager];
    return [dao findAll];
}

//查询所用数据方法
-(NSMutableArray*) findByUpDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)upDeptId
{
    MCDeptDAO *dao = [MCDeptDAO sharedManager];
    return [dao findByUpDeptId:belongOrgId upDepartmentId:upDeptId];
}

//查询所用数据方法
-(MCDept *) findByDeptId:(NSString *)deptId belongOrgId:(NSString *)belongOrgId
{
    MCDeptDAO *dao = [MCDeptDAO sharedManager];
    return [dao findByDeptId:deptId belongOrgId:belongOrgId];
}

@end
