//
//  MCDeptBL.h
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import <Foundation/Foundation.h>
#import "MCDept.h"
#import "MCDeptDAO.h"

@interface MCDeptBL : NSObject

//插入Dept方法
-(BOOL) create:(MCDept *)model;

//删除Dept方法
-(BOOL) remove:(MCDept *)model;

//通过belongOrgId删除Dept方法
-(BOOL) removeByOrgId:(NSString *)orgId;

//删除所有Dept方法
-(BOOL) removeAll;

//查询所用数据方法
-(NSMutableArray*) findAll;

//查询所用数据方法
-(NSMutableArray*) findByUpDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)upDeptId;

//查询所用数据方法
-(MCDept *) findByDeptId:(NSString *)deptId belongOrgId:(NSString *)belongOrgId;

@end
