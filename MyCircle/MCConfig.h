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

//保存联系人数据版本
- (void)saveContactsVersion:(NSUInteger)contactsVersion;
//获取联系人数据版本
- (NSUInteger)getContactsVersion;

//是否已登陆
- (BOOL)isLogined;
@end
