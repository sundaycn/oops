//
//  MCSettingModel.m
//  MyCircle
//
//  Created by Samuel on 1/19/14.
//
//

#import "MCSettingModel.h"

@implementation MCSettingModel

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSUInteger)tag title2:(NSString *)title2
{
    MCSettingModel *result = [[MCSettingModel alloc] init];
    result.title = title;
    result.image = image;
    result.tag = tag;
    result.title2 = title2;
    
    return result;
}

@end
