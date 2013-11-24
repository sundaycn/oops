//
//  MCDataObject.m
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import "MCDataObject.h"

@implementation MCDataObject

- (id)initWithId:(NSString *)bookId type:(NSString *)type name:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.type = type;
        self.name = name;
        self.bookId = bookId;
    }
    return self;
}

+ (id)dataObjectWithId:(NSString *)bookId type:(NSString *)type name:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithId:bookId type:type name:name children:children];
}

@end
