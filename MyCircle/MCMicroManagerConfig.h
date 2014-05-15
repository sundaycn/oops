//
//  MCMicroManagerConfig.h
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import <Foundation/Foundation.h>

@interface MCMicroManagerConfig : NSObject
@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) int16_t defaultShow;
@property (nonatomic, strong) NSString * iconImage;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * pagePath;
@property (nonatomic, assign) int16_t sort;
@property (nonatomic, assign) int16_t type;
@property (nonatomic, strong) NSString * upCode;
@end
