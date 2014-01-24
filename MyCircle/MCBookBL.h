//
//  MCBookBL.h
//  MyCircle
//
//  Created by Samuel on 10/17/13.
//
//

#import <Foundation/Foundation.h>
#import "MCBook.h"

@interface MCBookBL : NSObject

//插入Book方法
- (BOOL)create:(MCBook *)model;

//删除Book方法
- (BOOL)remove:(MCBook *)model;

//通过belongOrgId删除Book方法
- (BOOL)removeByOrgId:(NSString *)orgId;

//删除不再belongOrgId集合内得所有数据
- (BOOL)removeStaffNotInOrgIdSet:(NSArray *)arrOrgId;

//删除所有Book方法
- (BOOL)removeAll;

//修改联系人资料
- (BOOL)modify:(MCBook *)model;

//更新联系人searchId
- (BOOL)updateSearchId;

//查询所用数据方法
- (NSArray *)findAll;
- (NSMutableArray *)findByBelongDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)belongDeptId;
- (MCBook *)findById:(NSString *)bookId;
- (MCBook *)findBySearchId:(NSNumber *)searchId;
//按照手机号码查找联系人
- (MCBook *)findbyMobilePhone:(NSString *)mobilePhone;

@end
