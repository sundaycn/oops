//
//  MCDataObject.m
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import "MCDataObject.h"

@implementation MCDataObject

- (id)initWithName:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithName:name children:children];
}

@end
