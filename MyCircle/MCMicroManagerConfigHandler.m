//
//  MCMicroManagerConfigHandler.m
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import "MCMicroManagerConfigHandler.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MCMicroManagerConfigDAO.h"
#import "MCMicroManagerAccountDAO.h"
#import "MCMicroManagerDAO.h"

@implementation MCMicroManagerConfigHandler
static MCMicroManagerConfigHandler *sharedInstance = nil;
+ (MCMicroManagerConfigHandler *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//初始化微管理功能模块配置
- (void)initConfig
{
    NSBundle *bundle  = [NSBundle mainBundle];
    NSString *strConfigPlistPath = [bundle pathForResource:@"MicroManagerConfig" ofType:@"plist"];
    NSArray *arrConfig = [[NSArray alloc] initWithContentsOfFile:strConfigPlistPath];
    for (NSDictionary *obj in arrConfig) {
        MCMicroManagerConfig *config = [[MCMicroManagerConfig alloc] init];
        config.code = [obj objectForKey:@"code"];
        config.name = [obj objectForKey:@"name"];
        config.iconImage = [obj objectForKey:@"iconImage"];
        config.pagePath = [obj objectForKey:@"pagePath"];
        config.sort = [[obj objectForKey:@"sort"] intValue];
        config.upCode = [obj objectForKey:@"upCode"];
        config.type = [[obj objectForKey:@"type"] intValue];
        config.defaultShow = [[obj objectForKey:@"defaultShow"] intValue];
        
        [[MCMicroManagerConfigDAO sharedManager] insert:config];
    }
}

//下载微管理当前用户所有账号
- (void)getMMAccountByAccount:(NSString *)strAccount
{
    NSString *strURL = [[NSString alloc] initWithString:[MM_BASE_URL stringByAppendingString:@"easyoa!getUserByTelAjaxp.action"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"tel":strAccount};
    [manager POST:strURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"服务器返回微管理账号如下:\n%@", responseObject);
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
        BOOL isSuccessful = [strResult isEqualToString:@"1"];
        if (isSuccessful) {
            NSArray *arrAccount = [responseObject objectForKey:@"message"];
            MCMicroManagerAccount *account = [[MCMicroManagerAccount alloc] init];
            for (NSDictionary *obj in arrAccount) {
                account.userId = [obj objectForKey:@"userId"];
                account.userCode = [obj objectForKey:@"userCode"];
                account.userName = [obj objectForKey:@"userName"];
                account.gender = [obj objectForKey:@"gender"];
                account.acctId = [obj objectForKey:@"acctId"];
                account.acctName = [obj objectForKey:@"acctName"];
                account.belongOrgId = [obj objectForKey:@"belongOrgId"];
                account.orgName = [obj objectForKey:@"orgName"];
                
                [[MCMicroManagerAccountDAO sharedManager] insert:account];
            }
            
            [self.delegate didFinishGetMicroManagerAccount:account];
            DLog(@"微管理账号获取成功");
        }
        else {
            DLog(@"微管理账号获取失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"微管理账号获取请求发生错误\n %@", error);
    }];
}

//下载微管理当前账号所有功能模块代码
- (void)getCodeByUserCode:(NSString *)userCode acctId:(NSString *)acctId
{
    NSString *strURL = [[NSString alloc] initWithString:[MM_BASE_URL stringByAppendingString:@"easyoa!getUserModuleAjaxp.action"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"userCode":userCode, @"acctId":acctId};
    [manager POST:strURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"服务器返回微管理当前账号所有功能模块如下:\n%@", responseObject);
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
        BOOL isSuccessful = [strResult isEqualToString:@"1"];
        if (isSuccessful) {
            NSArray *arrWidgetCode = [responseObject objectForKey:@"message"];
            MCMicroManager *myWidget = [[MCMicroManager alloc] init];
            for (int i=0; i<arrWidgetCode.count; i++) {
                myWidget.code = arrWidgetCode[i];
                myWidget.belongAccountId = acctId;
                myWidget.belongUserCode = userCode;
                
                [[MCMicroManagerDAO sharedManager] insert:myWidget];
            }
            
            [self.delegate didFinishGetMicroManagerWidget];
            DLog(@"微管理当前账号所有功能模块获取成功");
        }
        else {
            DLog(@"微管理当前账号所有功能模块获取失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"微管理当前账号所有功能模块获取请求发生错误\n %@", error);
    }];
}

//登录
- (void)loginByUserCode:(NSString *)userCode password:(NSString *)userPwd
{
    NSString *strURL = [[NSString alloc] initWithString:[MM_BASE_URL stringByAppendingString:@"easy-login!dologinAjax.action"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"user.userCode":userCode, @"user.loginPwd":userPwd};
    [manager POST:strURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"服务器返回微管理登录结果如下:\n%@", responseObject);
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
        BOOL isSuccessful = [strResult isEqualToString:@"1"];
        if (isSuccessful) {
//            NSArray *arrWidgetCode = [responseObject objectForKey:@"message"];
//            MCMicroManager *myWidget = [[MCMicroManager alloc] init];
//            for (int i=0; i<arrWidgetCode.count; i++) {
//                myWidget.code = arrWidgetCode[i];
//                myWidget.belongAccountId = acctId;
//                myWidget.belongUserCode = userCode;
//                
//                [[MCMicroManagerDAO sharedManager] insert:myWidget];
//            }
//            
//            [self.delegate didFinishGetMicroManagerWidget];
            DLog(@"微管理登录成功");
        }
        else {
            DLog(@"微管理登录失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"微管理登录请求发生错误\n %@", error);
    }];
}
@end
