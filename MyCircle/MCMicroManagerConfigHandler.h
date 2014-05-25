//
//  MCMicroManagerConfigHandler.h
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import <Foundation/Foundation.h>
#import "MCMicroManagerDelegate.h"

@interface MCMicroManagerConfigHandler : NSObject
@property (nonatomic, strong) id<MCMicroManagerDelegate> delegate;

+ (MCMicroManagerConfigHandler *)sharedInstance;
//初始化微管理功能模块配置
- (void)initConfig;
//下载微管理当前用户所有账号
- (void)getMMAccountByAccount:(NSString *)strAccount defaultMMAccount:(MCMicroManagerAccount *)defaultMMAccount;
//下载微管理当前账号所有功能模块代码
- (void)getCodeByUserCode:(NSString *)userCode acctId:(NSString *)acctId;
//登录
- (void)loginByUserCode:(NSString *)userCode password:(NSString *)userPwd;
@end
