//
//  MCProvinceDAO.m
//  MyCircle
//
//  Created by Samuel on 5/2/14.
//
//

#import "MCProvinceDAO.h"

@implementation MCProvinceDAO
static MCProvinceDAO *sharedManager = nil;

+ (MCProvinceDAO *)sharedManager
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
    //documnet path
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"MyInfoRegionProvince.plist"];

	return path;
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
	
	BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
	if (!dbexits) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MyInfoRegionProvince.plist"];

		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"错误写入文件：'%@'。", [error localizedDescription]);
		}
	}
}

//插入省份方法
- (int)create:(MCProvince *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary *dict = [NSDictionary
                          dictionaryWithObjects:@[model.pid, model.name, model.existsChild]
                          forKeys:@[@"pid", @"name", @"existsChild"]];
    
    [array addObject:dict];
    [array writeToFile:path atomically:YES];
    
    return 0;
}

//删除省份方法
- (int)remove:(MCProvince *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dict in array) {
        
        if ([[dict objectForKey:@"pid"] isEqualToString:model.pid]){
            [array removeObject:dict];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    
    return 0;
}

//删除所有省份方法
- (int)removeAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    [array removeAllObjects];
    
    return 0;
}

//修改省份方法
- (int)modify:(MCProvince *)model
{
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dict in array) {
        
        if ([[dict objectForKey:@"pid"] isEqualToString:model.pid]){
            [dict setValue:model.name forKey:@"name"];
            [dict setValue:model.existsChild forKey:@"existsChild"];
            [array writeToFile:path atomically:YES];
            break;
        }
    }
    return 0;
}

//查询所有省份数据方法
- (NSArray *)findAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dict in array) {
        
        MCProvince *province = [[MCProvince alloc] init];
        province.pid = [dict objectForKey:@"pid"];
        province.name = [dict objectForKey:@"name"];
        province.existsChild = [dict objectForKey:@"existsChild"];
        
        [listData addObject:province];
        
    }
    
    return [listData copy];
}

//按照主键查询省份数据方法
- (MCProvince *)findById:(NSString *)pid
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dict in array) {
        
        if ([[dict objectForKey:@"pid"] isEqualToString:pid]) {
            MCProvince *province = [[MCProvince alloc] init];
            province.pid = [dict objectForKey:@"pid"];
            province.name = [dict objectForKey:@"name"];
            province.existsChild = [dict objectForKey:@"existsChild"];
            
            return province;
        }
    }
    return nil;
}
@end
