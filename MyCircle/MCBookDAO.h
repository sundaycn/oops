//
//  MCBookDAO.h
//  MyCircle
//
//  Created by Samuel on 10/16/13.
//
//

#import <Foundation/Foundation.h>
#import "MCCoreDataDAO.h"
#import "MCBookManagedObject.h"
#import "MCBook.h"

@interface MCBookDAO : MCCoreDataDAO

+ (MCBookDAO *)sharedManager;

//插入Book方法
-(int) create:(MCBook *)model;

//删除Book方法
-(int) remove:(MCBook *)model;

//通过belongOrgId删除Book方法
-(int) removeByOrgId:(NSString *)orgId;

//删除不再belongOrgId集合内得所有数据
- (int)removeStaffNotInOrgIdSet:(NSArray *)arrOrgId;

//删除所有Book方法
-(int) removeAll;

//修改Book方法
-(int) modify:(MCBook *)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照belongDepartmentId查询数据方法
-(NSMutableArray *) findByBelongDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)belongDeptId;

//按照主键查询数据方法
-(MCBook *) findById:(NSString *)bookId;

//按照searchId查询数据方法
-(MCBook *) findBySearchId:(NSNumber *)searchId;

//按照手机号码查找联系人
- (MCBook *)findbyMobilePhone:(NSString *)mobilePhone;

@end
