//
//  MCMyInfoHandler.m
//  MyCircle
//
//  Created by Samuel on 4/4/14.
//
//

#import "MCMyInfoHandler.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "MCMyInfoDAO.h"
#import "MCCrypto.h"

@implementation MCMyInfoHandler
+ (NSInteger)isGetMyInfoSuccessfully:(NSString *)strAccount password:(NSString *)cipherPwd
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!findUserAttachInfoAjax.action"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:strAccount forKey:@"tel"];
    [request addPostValue:cipherPwd forKey:@"password"];
    //同步请求
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        //把info的值由字符串格式转为json数组格式
        NSString *strJsonResult = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
        DLog(@"服务器返回:\n%@", strJsonResult);
        
        //重新封装json数据
        NSData *dataResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[[dictResponse objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isSuccessful = [strResult isEqualToString:@"1"];
        if (isSuccessful) {
            //清除信息
            [[MCMyInfoDAO sharedManager] removeAll];
            //保存信息
            MCMyInfo *myInfo = [[MCMyInfo alloc] init];
            myInfo.userName = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"userName"];
            myInfo.userName = myInfo.userName ? myInfo.userName : @"未设置";
            myInfo.gender = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"gender"];
            myInfo.gender = [myInfo.gender isEqualToString:@"M"] ? @"男" : @"女";
//            myInfo.photo = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"photo"];
            myInfo.provinceId = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"provinceId"];
            myInfo.provinceId = myInfo.provinceId ? myInfo.provinceId : @"未设置";
            myInfo.cityId = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"cityId"];
            myInfo.cityId = myInfo.cityId ? myInfo.cityId : @"未设置";
            myInfo.countyId = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"countyId"];
            myInfo.countyId = myInfo.countyId ? myInfo.countyId : @"未设置";
            myInfo.mobile = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"mobile"];
//            myInfo.address = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"address"];
            myInfo.id = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"id"];
//            myInfo.postNo = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"postNo"];
            myInfo.phone = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"phone"];
            myInfo.phone = myInfo.phone ? myInfo.phone : @"未设置";
            myInfo.birthdayString = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"birthdayString"];
            myInfo.birthdayString = myInfo.birthdayString ? myInfo.birthdayString : @"未设置";
            myInfo.email = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"email"];
            myInfo.email = myInfo.email ? myInfo.email : @"未设置";
            [[MCMyInfoDAO sharedManager] insert:myInfo];

            DLog(@"个人资料获取成功");
            [MCMyInfoHandler downloadAvatar:myInfo.photo account:strAccount];
            DLog(@"个人头像保存成功");
            return 0;
        }
        else {
            DLog(@"个人资料获取失败");
            return 1;
        }
    }
    else {
        DLog(@"个人资料获取请求发生错误\n %@", error);
        return 2;
    }
}

+ (void)downloadAvatar:(NSString *)url account:(NSString *)strAccount
{
    //头像图片文件名编码
    NSString *strEncodedImageFileName = [MCCrypto DESEncrypt:strAccount WithKey:DESENCRYPTED_KEY];
    //拼装图片文件路径
    NSString *strImageFilePath = [[@"ContactManage/TcmContactUserAttachInfo/" stringByAppendingString:strEncodedImageFileName] stringByAppendingString:@".jpg"];
    
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"TsysFilesInfo/tsysfilesinfo!downloadByPath.action"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:@"true" forKey:@"pathNoNeedOrgId"];
    [request addPostValue:strImageFilePath forKey:@"path"];
    //同步请求
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        [[MCMyInfoDAO sharedManager] insertAvatar:response byAccount:strAccount];
    }
}
@end
