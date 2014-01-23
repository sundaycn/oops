//
//  MCConfig.m
//  MyCircle
//
//  Created by Samuel on 1/17/14.
//
//

#import "MCConfig.h"
#import "MCCrypto.h"

@implementation MCConfig

static MCConfig *sharedInstance = nil;

+ (MCConfig *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//保存账号和密文密码
-(void)saveAccount:(NSString *)account password:(NSString *)cipherPwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"account"];
    [settings removeObjectForKey:@"password"];
    
    [settings setObject:account forKey:@"account"];
    [settings setObject:cipherPwd forKey:@"password"];
    [settings setObject:@"1" forKey:@"isLogined"];
    [settings synchronize];
}
//获取账号
-(NSString *)getAccount
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    return [settings objectForKey:@"account"];
}
//获取明文密码
-(NSString *)getPlainPassword
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *cipherPwd = [settings objectForKey:@"password"];
    NSString *plainPwd = [MCCrypto DESDecrypt:cipherPwd WithKey:DESENCRYPTED_KEY];

    return plainPwd;
}
//获取密文密码
- (NSString *)getCipherPassword
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *cipherPwd = [settings objectForKey:@"password"];
    
    return cipherPwd;
}

//保存联系人数据版本
- (void)saveContactsVersion:(NSUInteger)contactsVersion
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"contactsVersion"];
    [settings setObject:[NSString stringWithFormat:@"%d", contactsVersion] forKey:@"contactsVersion"];
    [settings synchronize];
}
//获取联系人数据版本
- (NSUInteger)getContactsVersion
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *contactsVersion = [settings objectForKey:@"contactsVersion"];
    
    return [contactsVersion integerValue];
}

//是否已登陆
- (BOOL)isLogined
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    return [[settings objectForKey:@"isLogined"] isEqualToString:@"1"] ? YES : NO;
}

@end
