//
//  MCSettingModel.h
//  MyCircle
//
//  Created by Samuel on 1/19/14.
//
//

#import <Foundation/Foundation.h>

@interface MCSettingModel : NSObject

@property (copy,nonatomic) NSString *image;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *title2;
@property NSUInteger tag;

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSUInteger)tag title2:(NSString *)title2;

@end
