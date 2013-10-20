//
//  MCCoreDataDAO.h
//  MyCircle
//
//  Created by Samuel on 10/16/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MCCoreDataDAO : NSObject

//被管理的对象上下文
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//被管理的对象模型
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//持久化存储协调者
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

@end
