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

//删除所有Book方法
-(int) removeAll;

//修改Book方法
-(int) modify:(MCBook *)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(MCBook *) findById:(MCBook *)model;

@end
