//
//  MCMicroManager.h
//  MyCircle
//
//  Created by Samuel on 5/16/14.
//
//

#import <Foundation/Foundation.h>

@interface MCMicroManager : NSObject
@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) int16_t defaultShow;
@property (nonatomic, assign) int16_t loginIfNeed;
@property (nonatomic, assign) int16_t isTodo;
@property (nonatomic, strong) NSString * belongPhone;
@property (nonatomic, assign) int32_t todoAmount;
@property (nonatomic, assign) int16_t sort;
@property (nonatomic, strong) NSString * belongAccountId;
@property (nonatomic, strong) NSString * belongAccountName;
@property (nonatomic, strong) NSString * belongUserId;
@property (nonatomic, strong) NSString * belongUserCode;
@property (nonatomic, strong) NSString * belongUserName;
@end
