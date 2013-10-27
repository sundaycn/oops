//
//  MCBookBL.h
//  MyCircle
//
//  Created by Samuel on 10/17/13.
//
//

#import <Foundation/Foundation.h>
#import "MCBook.h"
#import "MCBookDAO.h"

@interface MCBookBL : NSObject

//插入Book方法
-(BOOL) create:(MCBook *)model;

//删除Book方法
-(BOOL) remove:(MCBook *)model;

//通过belongOrgId删除Book方法
-(BOOL) removeByOrgId:(NSString *)orgId;

//删除所有Book方法
-(BOOL) removeAll;

//查询所用数据方法
-(NSMutableArray *) findAll;
-(NSMutableArray *) findByBelongDeptId:(NSString *)belongOrgId upDepartmentId:(NSString *)belongDeptId;
-(MCBook *) findById:(NSString *)bookId;
@end
