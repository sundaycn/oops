//
//  MCDeptDAO.h
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import <Foundation/Foundation.h>
#import "MCCoreDataDAO.h"
#import "MCDeptManagedObject.h"
#import "MCDept.h"

@interface MCDeptDAO : MCCoreDataDAO

+ (MCDeptDAO *)sharedManager;

//插入Dept方法
-(int) create:(MCDept *)model;

//删除Dept方法
-(int) remove:(MCDept *)model;

//通过belongOrgId删除Dept方法
-(int) removeByOrgId:(NSString *)orgId;

//删除所有Dept方法
-(int) removeAll;

//修改Dept方法
-(int) modify:(MCDept *)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(MCDept *) findById:(MCDept *)model;

@end
