//
//  MCConfig.h
//  MyCircle
//
//  Created by Samuel on 1/17/14.
//
//

#import <Foundation/Foundation.h>

@interface MCConfig : NSObject

+ (MCConfig *)sharedInstance;

//保存账号密码
-(void)saveAccount:(NSString *)account password:(NSString *)password;
//获取账号
-(NSString *)getAccount;
//获取明文密码
-(NSString *)getPlainPassword;
//获取密文密码
- (NSString *)getCipherPassword;

//是否已登陆
- (BOOL)isLogined;
//退出登陆
- (void)setLoginOff;

//获取应用版本号
//- (NSString *)getAppVersion;
@end
