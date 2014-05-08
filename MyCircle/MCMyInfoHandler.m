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
#import "MCProvinceDAO.h"
#import "MCCityDAO.h"
#import "MCCrypto.h"

@implementation MCMyInfoHandler
+ (void)isGetMyInfoSuccessfully:(NSString *)strAccount password:(NSString *)cipherPwd
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!findUserAttachInfoAjax.action"]];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:strAccount forKey:@"tel"];
    [request addPostValue:cipherPwd forKey:@"password"];
    
    [request setCompletionBlock:^{
        // Use when fetching binary data
        NSData *response = [request responseData];
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
            myInfo.gender = [myInfo.gender isEqualToString:@"F"] ? @"女" : @"男";
            //            myInfo.photo = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"photo"];
            myInfo.provinceId = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"provinceId"];
            myInfo.provinceId = myInfo.provinceId ? myInfo.provinceId : @"未设置";
            myInfo.provinceName = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"provinceName"];
            myInfo.provinceName = myInfo.provinceName ? myInfo.provinceName : @"未设置";
            myInfo.cityId = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"cityId"];
            myInfo.cityId = myInfo.cityId ? myInfo.cityId : @"未设置";
            myInfo.cityName = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"cityName"];
            myInfo.cityName = myInfo.cityName ? myInfo.cityName : @"未设置";
            myInfo.countyId = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"countyId"];
            myInfo.countyId = myInfo.countyId ? myInfo.countyId : @"未设置";
            myInfo.countyName = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"countyName"];
            myInfo.countyName = myInfo.countyName ? myInfo.countyName : @"未设置";
            myInfo.mobile = [[[dictResponse objectForKey:@"root"] objectForKey:@"info"] objectForKey:@"mobile"];
            myInfo.mobile = myInfo.mobile ? myInfo.mobile : strAccount;
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
        }
        else {
            DLog(@"个人资料获取失败");
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        DLog(@"个人资料获取请求发生错误\n %@", error);
    }];
    
    //异步请求
    [request startAsynchronous];
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

/*
//提取地区－省名称
+ (NSString *)getProvinceNameById:(NSString *)pid
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyInfoRegionProvince" ofType:@"plist"];
    NSArray *arrProvince = [[NSArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *obj in arrProvince) {
        if ([[obj objectForKey:@"pid"] isEqualToString:pid]) {
            return [obj objectForKey:@"name"];
        }
    }
    
    return nil;
}

//提取地区－市名称
+ (NSString *)getCityNameById:(NSString *)cid pid:(NSString *)pid
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyInfoRegionCity" ofType:@"plist"];
    NSDictionary *dictCity = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *arrCity = [dictCity objectForKey:@"pid"];
    for (NSDictionary *obj in arrCity) {
        if ([[obj objectForKey:@"id"] isEqualToString:cid]) {
            return [obj objectForKey:@"name"];
        }
    }
    
    return nil;
}*/

/*
//第一次启动应用并登陆时获取地区数据
+ (void)downloadRegion
{
    [self getProvinceDataBySync];
    NSArray *arrProvince = [[MCProvinceDAO sharedManager] findAll];
    for (MCProvince *object in arrProvince) {
        [self getCityDataBySync:object.pid];
    }
}

//从服务器获取省数据
+ (void)getProvinceDataByAsync
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!queryProvinceAjax.action"]];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request setCompletionBlock:^{
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        // Use when fetching text data
        //        NSString *strResponse = [request responseString];
        //把province的值由字符串格式转为json数组格式
        NSString *strJsonResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
        //        DLog(@"服务器返回省数据:\n%@", strJsonResult);
        
        //重新封装json数据
        NSData *dataResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingAllowFragments error:nil];
        NSArray *arrRoot = [[dictResponse objectForKey:@"root"] objectForKey:@"info"];
        for (NSDictionary *dictItem in arrRoot) {
            
            MCProvince *province = [[MCProvince alloc] init];
            province.existsChild = [dictItem objectForKey:@"existChild"];
            province.pid = [dictItem objectForKey:@"id"];
            province.name = [dictItem objectForKey:@"name"];
            
            [[MCProvinceDAO sharedManager] create:province];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSString *strDetail = [error.localizedDescription stringByAppendingString:@"\n 请返回重新尝试"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取省数据失败" message:strDetail delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    //异步获取数据
    [request startAsynchronous];
}

//从服务器获取省数据
+ (void)getProvinceDataBySync
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!queryProvinceAjax.action"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    //同步获取数据
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        // Use when fetching text data
        //        NSString *strResponse = [request responseString];
        //把province的值由字符串格式转为json数组格式
        NSString *strJsonResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
        DLog(@"---------------------服务器返回省数据:\n%@", strJsonResult);
        
        //重新封装json数据
        NSData *dataResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingAllowFragments error:nil];
        NSArray *arrRoot = [[dictResponse objectForKey:@"root"] objectForKey:@"info"];
        for (NSDictionary *dictItem in arrRoot) {
            
            MCProvince *province = [[MCProvince alloc] init];
            province.existsChild = [dictItem objectForKey:@"existChild"];
            province.pid = [dictItem objectForKey:@"id"];
            province.name = [dictItem objectForKey:@"name"];
            
            [[MCProvinceDAO sharedManager] create:province];
        }
    }
}

//从服务器获取市数据
+ (void)getCityDataByAsync:(NSString *)pid
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!queryCityAjax.action"]];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:pid forKey:@"provinceId"];
    [request setCompletionBlock:^{
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        //把province的值由字符串格式转为json数组格式
        NSString *strJsonResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
        //        DLog(@"服务器返回省数据:\n%@", strJsonResult);
        
        //重新封装json数据
        NSData *dataResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingAllowFragments error:nil];
        NSArray *arrRoot = [[dictResponse objectForKey:@"root"] objectForKey:@"info"];

        [[MCCityDAO sharedManager] create:arrRoot pid:pid];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSString *strDetail = [error.localizedDescription stringByAppendingString:@"\n 请返回重新尝试"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取市数据失败" message:strDetail delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    //异步获取数据
    [request startAsynchronous];
}

//从服务器获取市数据
+ (void)getCityDataBySync:(NSString *)pid
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!queryCityAjax.action"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:pid forKey:@"provinceId"];
    
    //同步获取数据
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        
        //把province的值由字符串格式转为json数组格式
        NSString *strJsonResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
        
        DLog(@"---------------------服务器返回市数据:\n%@", strJsonResult);

        //重新封装json数据
        NSData *dataResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingAllowFragments error:nil];
        NSArray *arrRoot = [[dictResponse objectForKey:@"root"] objectForKey:@"info"];

        [[MCCityDAO sharedManager] create:arrRoot pid:pid];
    }
}*/
@end
