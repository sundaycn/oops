//
//  MCDataObject.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import <Foundation/Foundation.h>

@interface MCDataObject : NSObject

@property (strong, nonatomic) NSString *bookId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *children;

//- (id)initWithName:(NSString *)name children:(NSArray *)array;
- (id)initWithId:(NSString *)bookId name:(NSString *)name children:(NSArray *)children;

//+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;
+ (id)dataObjectWithId:(NSString *)bookId name:(NSString *)name children:(NSArray *)children;

@end