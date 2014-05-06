//
//  MCCityDAO.m
//  MyCircle
//
//  Created by Samuel on 5/2/14.
//
//

#import "MCCityDAO.h"

@implementation MCCityDAO
static MCCityDAO *sharedManager = nil;

+ (MCCityDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
    });
    
    return sharedManager;
}

- (NSString *)applicationDocumentsDirectoryFile
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"MyInfoRegionCity.plist"];
    
	return path;
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
	
	BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
	if (!dbexits) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MyInfoRegionCity.plist"];
		
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"错误写入文件：'%@'。", [error localizedDescription]);
		}
	}
}

//插入市方法
- (int)create:(NSArray *)arrCity pid:(NSString *)pid
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [dict setValue:arrCity forKeyPath:pid];
    [dict writeToFile:path atomically:YES];
    
    return 0;
}

//删除市方法
- (int)remove:(MCCity *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dict in array) {
        
        if ([[dict objectForKey:@"cid"] isEqualToString:model.cid]){
            [array removeObject:dict];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    
    return 0;
}

//删除所有市方法
- (int)removeAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    [array removeAllObjects];
    
    return 0;
}

//修改市方法
- (int)modify:(MCCity *)model
{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dict in array) {
        
        if ([[dict objectForKey:@"cid"] isEqualToString:model.cid]){
            [dict setValue:model.name forKey:@"name"];
            [dict setValue:model.existsChild forKey:@"existsChild"];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    return 0;
}

//查询所有市数据方法
- (NSArray *)findAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dict in array) {
        
        MCCity *city = [[MCCity alloc] init];
        city.cid = [dict objectForKey:@"cid"];
        city.name = [dict objectForKey:@"name"];
        city.existsChild = [dict objectForKey:@"existsChild"];
        
        [listData addObject:city];
        
    }
    
    return [listData copy];
}

//按照所属省id查询市数据方法
- (NSArray *)findByPid:(NSString *)pid
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *array = [dict objectForKey:pid];

    return array;
}

//按照主键查询市数据方法
- (MCCity *)findById:(NSString *)cid pid:(NSString *)pid
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *array = [dict objectForKey:pid];
    
    for (NSDictionary *dict in array) {
        
        if ([[dict objectForKey:@"id"] isEqualToString:cid]) {
            MCCity *city = [[MCCity alloc] init];
            city.cid = [dict objectForKey:@"id"];
            city.name = [dict objectForKey:@"name"];
            city.existsChild = [dict objectForKey:@"existsChild"];
            
            return city;
        }
    }
    return nil;
}
@end
