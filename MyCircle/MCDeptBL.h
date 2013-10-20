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

//插入Book方法
-(BOOL) create:(MCDept *)model;

//删除Book方法
-(BOOL) remove:(MCDept *)model;

//通过belongOrgId删除Book方法
-(BOOL) removeByOrgId:(NSString *)orgId;

//删除所有Book方法
-(BOOL) removeAll;

//查询所用数据方法
-(NSMutableArray*) findAll;

@end
