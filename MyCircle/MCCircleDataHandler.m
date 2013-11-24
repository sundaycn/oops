//
//  MCCircleDataHandler.m
//  MyCircle
//
//  Created by Samuel on 10/21/13.
//
//

#import "MCCircleDataHandler.h"

@implementation MCCircleDataHandler

+ (NSMutableArray *)getDataOfCircle
{
    NSMutableArray *root = [[NSMutableArray alloc] init];
    MCOrgBL *orgBL = [[MCOrgBL alloc] init];
    NSArray *arrOrg = [orgBL findAll];
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    for (MCOrg *org in arrOrg) {
        NSArray *arrDept = [deptBL findByUpDeptId:org.id upDepartmentId:@"-1"];
        if ([arrDept count] == 1) {
            MCDept *dept = [arrDept lastObject];
            NSMutableArray *nodesList = [self getNodesOfOrg:org.id upDepartmentId:dept.id];
            MCDataObject *deptNode = [MCDataObject dataObjectWithId:dept.id type:@"dept" name:dept.name children:nodesList];
            [root addObject:deptNode];
        }
        else
#warning 提示用户圈子根节点不唯一
            DLog(@"根部门不唯一");

    }

    return root;
}

+ (NSMutableArray *)getNodesOfOrg:(NSString *)orgId upDepartmentId:(NSString *)upDeptId {
#warning 可以优化
    NSMutableArray *result = [[NSMutableArray alloc] init];
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    NSArray *arrDept = [deptBL findByUpDeptId:orgId upDepartmentId:upDeptId];
    if ([arrDept count] != 0) {
        for (MCDept *dept in arrDept) {
            NSMutableArray *nodesList = [self getNodesOfOrg:orgId upDepartmentId:dept.id];
            MCDataObject *deptNode = [MCDataObject dataObjectWithId:dept.id type:@"dept" name:dept.name children:nodesList];
            [result addObject:deptNode];
        }
    }
    else {
        MCBookBL *bookBL = [[MCBookBL alloc] init];
        NSArray *arrBook = [bookBL findByBelongDeptId:orgId upDepartmentId:upDeptId];
        for (MCBook *book in arrBook) {
            NSMutableArray *nodesList = [self getNodesOfOrg:orgId upDepartmentId:book.belongDepartmentId];
            MCDataObject *bookNode = [MCDataObject dataObjectWithId:book.id type:@"member" name:book.name children:nodesList];
            [result addObject:bookNode];
        }
    }
    
    return result;
}

@end
