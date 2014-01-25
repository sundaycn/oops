//
//  MCLoginHandler.m
//  MyCircle
//
//  Created by Samuel on 11/6/13.
//
//

#import "MCLoginHandler.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "MCCrypto.h"
#import "MCBookBL.h"
#import "MCDeptBL.h"
#import "MCOrgBL.h"
#import "MCConfig.h"

@implementation MCLoginHandler

+ (NSInteger)isLoginedSuccessfully:(NSString *)strAccount password:(NSString *)cipherPwd
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!loginAjax.action"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:strAccount forKey:@"tel"];
    [request addPostValue:cipherPwd forKey:@"password"];
    //获取1到x之间的整数
    NSUInteger randomInteger = (arc4random() % 99999999) + 1;
    NSString *stamp = [[NSString alloc] initWithFormat:@"%d", randomInteger];
    DLog(@"用于登陆服务器的随机数:%@", stamp);
    [request addPostValue:stamp forKey:@"stamp"];
    //同步请求
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        //把enterprise的值由字符串格式转为json数组格式
        NSString *strJsonResult = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
        DLog(@"服务器返回:\n%@", strJsonResult);
        
        //重新封装json数据
        NSData *dataLoginResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dictLoginResponse = [NSJSONSerialization JSONObjectWithData:dataLoginResponse options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strLoginResult = [NSString stringWithFormat:@"%@",[[dictLoginResponse objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isLogined = [strLoginResult isEqualToString:@"1"];
        if (isLogined) {
            //保存用户名和密码
            [[MCConfig sharedInstance] saveAccount:strAccount password:cipherPwd];
            MCOrgBL *orgBL = [[MCOrgBL alloc] init];
            //获取当前所有联系人数据版本号
            NSDictionary *dictContactsVersion = [orgBL findAllVersion];
            //清空组织表
            [orgBL removeAll];
            //提取组织id
            NSArray *arrOrgInfo = [[dictLoginResponse objectForKey:@"root"] objectForKey:@"enterprise"];
            for (NSDictionary *dictOrgInfo in arrOrgInfo) {
                //保存enterprise数据
                MCOrg *org = [[MCOrg alloc] init];
                org.id = [NSString stringWithFormat:@"%@", [dictOrgInfo objectForKey:@"id"]];
                org.name = [NSString stringWithFormat:@"%@", [dictOrgInfo objectForKey:@"name"]];
                org.version = @"0";
                
                BOOL isSaved = [orgBL create:org];
                if (!isSaved) {
                    DLog(@"插入enterprise数据失败");
                }
            }
            //恢复组织对应的联系人数据版本号
            [orgBL updateAllVersion:dictContactsVersion];
            DLog(@"登陆成功");
            return 0;
        }
        else {
            DLog(@"登陆失败");
            DLog(@"手机号或密码错误");
            return 1;
        }
    }
    else {
        DLog(@"登陆请求发生错误\n %@", error);
        return 2;
    }
}

@end
