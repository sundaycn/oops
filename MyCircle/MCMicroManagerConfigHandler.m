//
//  MCMicroManagerConfigHandler.m
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import "MCMicroManagerConfigHandler.h"
#import "MCMicroManagerConfigDAO.h"
#import "MCMicroManagerAccountDAO.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

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

//下载微管理当前账号所有功能模块代码
- (void)getCodeByMMAccount:(NSString *)strMMAccount
{
    NSString *strURL = [[NSString alloc] initWithString:[MM_BASE_URL stringByAppendingString:@"easyoa!getUserByTelAjaxp.action"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"tel":strMMAccount};
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
            
            DLog(@"微管理账号获取成功");
        }
        else {
            DLog(@"微管理账号获取失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"微管理账号获取请求发生错误\n %@", error);
        
    }];
}
@end
