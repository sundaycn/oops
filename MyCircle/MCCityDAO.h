//
//  MCCityDAO.h
//  MyCircle
//
//  Created by Samuel on 5/2/14.
//
//

#import <Foundation/Foundation.h>
#import "MCCity.h"

@interface MCCityDAO : NSObject
+ (MCCityDAO *)sharedManager;

- (NSString *)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;

//插入市方法
- (int)create:(MCCity *)model;

//删除市方法
- (int)remove:(MCCity *)model;

//删除所有市方法
- (int)removeAll;

//修改市方法
- (int)modify:(MCCity *)model;

//查询所有市数据方法
- (NSArray *)findAll;

//按照主键查询市数据方法
- (MCCity *)findById:(MCCity *)model;
@end
