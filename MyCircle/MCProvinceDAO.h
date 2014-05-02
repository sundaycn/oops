//
//  MCProvinceDAO.h
//  MyCircle
//
//  Created by Samuel on 5/2/14.
//
//

#import <Foundation/Foundation.h>
#import "MCProvince.h"

@interface MCProvinceDAO : NSObject
+ (MCProvinceDAO *)sharedManager;

- (NSString *)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;

//插入省份方法
- (int)create:(MCProvince *)model;

//删除省份方法
- (int)remove:(MCProvince *)model;

//删除所有省份方法
- (int)removeAll;

//修改省份方法
- (int)modify:(MCProvince *)model;

//查询所有省份数据方法
- (NSArray *)findAll;

//按照主键查询省份数据方法
- (MCProvince *)findById:(MCProvince *)model;

@end
