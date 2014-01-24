//
//  MCBookBL.m
//  MyCircle
//
//  Created by Samuel on 10/17/13.
//
//

#import "MCBookBL.h"
#import "MCBookDAO.h"

@implementation MCBookBL

//插入Book方法
- (BOOL)create:(MCBook *)model
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao create:model] ? 0 : -1;
}

//删除Book方法
- (BOOL)remove:(MCBook *)model
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao remove:model] ? 0 : -1;
}

//通过belongOrgId删除Book方法
- (BOOL)removeByOrgId:(NSString *)orgId
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao removeByOrgId:orgId] ? 0 : -1;
}

//删除不再belongOrgId集合内得所有数据
- (BOOL)removeStaffNotInOrgIdSet:(NSArray *)arrOrgId
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao removeStaffNotInOrgIdSet:arrOrgId] ? 0 : -1;
}

//删除所有Book方法
- (BOOL)removeAll
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao removeAll] ? 0 : -1;
}

//修改联系人资料
- (BOOL)modify:(MCBook *)model
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao modify:model] ? 0 : -1;
}

//更新联系人searchId
- (BOOL)updateSearchId
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao updateSearchId] ? 0 : -1;
}

//查询所用数据方法
- (NSArray *)findAll
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao findAll];
}

//按照归属部门查询数据方法
- (NSMutableArray *)findByBelongDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)belongDeptId
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao findByBelongDeptId:belongOrgId upDepartmentId:belongDeptId];
}

//按照主键查询数据方法
- (MCBook *)findById:(NSString *)bookId
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao findById:bookId];
}

- (MCBook *)findBySearchId:(NSNumber *)searchId
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao findBySearchId:searchId];
}

//按照手机号码查找联系人
- (MCBook *)findbyMobilePhone:(NSString *)mobilePhone
{
    MCBookDAO *dao = [MCBookDAO sharedManager];
    return [dao findbyMobilePhone:mobilePhone];
}

@end