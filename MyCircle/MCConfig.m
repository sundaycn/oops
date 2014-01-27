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

//是否已登陆
- (BOOL)isLogined
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    return [[settings objectForKey:@"isLogined"] isEqualToString:@"1"] ? YES : NO;
}
//退出登陆
- (void)setLoginOff
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"isLogined"];
    [settings setObject:@"0" forKey:@"isLogined"];
}

////获取应用版本号
//- (NSString *)getAppVersion
//{
//    NSString *strAppVersion = [@"v" stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//    NSString *strAppBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
//    
//    return [[strAppVersion stringByAppendingString:@"."] stringByAppendingString:strAppBuild];
//}

@end
