//
//  MCMicroManagerConfigHandler.h
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import <Foundation/Foundation.h>

@interface MCMicroManagerConfigHandler : NSObject
+ (MCMicroManagerConfigHandler *)sharedInstance;
//初始化微管理功能模块配置
- (void)initConfig;
//下载微管理当前账号所有功能模块代码
- (void)getCodeByMMAccount:(NSString *)strMMAccount;
@end
