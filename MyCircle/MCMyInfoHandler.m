//
//  MCMyInfoHandler.m
//  MyCircle
//
//  Created by Samuel on 4/4/14.
//
//

#import "MCMyInfoHandler.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MCMyInfoDAO.h"
//#import "MCProvinceDAO.h"
//#import "MCCityDAO.h"
#import "MCCrypto.h"

@implementation MCMyInfoHandler

static MCMyInfoHandler *sharedInstance = nil;
+ (MCMyInfoHandler *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)getMyInfo:(NSString *)strAccount password:(NSString *)cipherPwd
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!findUserAttachInfoAjax.action"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"tel":strAccount, @"password":cipherPwd};
    [manager POST:strURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"服务器返回个人资料如下:\n%@", responseObject);
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isSuccessful = [strResult isEqualToString:@"1"];
        if (isSuccessful) {
            //把info的值由字符串格式转为json数组格式
            NSString *strInfo = [[responseObject objectForKey:@"root"] objectForKey:@"info"];
            if (!strInfo) {
                //服务器没有该用户的个人资料
                //清除信息
                [[MCMyInfoDAO sharedManager] removeAll];
                MCMyInfo *myInfo = [[MCMyInfo alloc] init];
                
                //新增
                NSString *photo = nil;
                //id
                myInfo.id = nil;
                //用户名称
                myInfo.userName = @"未设置";
                //性别
                myInfo.gender = @"未设置";
                //生日
                myInfo.birthdayString = @"未设置";
                //头像文件下载路径
                myInfo.photo = photo;
                //省份id
                myInfo.provinceId = @"未设置";
                //省份名称
                myInfo.provinceName = @"未设置";
                //城市id
                myInfo.cityId = @"未设置";
                //城市名称
                myInfo.cityName = @"未设置";
                //县区id
                //            myInfo.countyId = [dictInfo objectForKey:@"countyId"];
                //            myInfo.countyId = myInfo.countyId ? myInfo.countyId : @"未设置";
                //县区名称
                //            myInfo.countyName = [dictInfo objectForKey:@"countyName"];
                //            myInfo.countyName = myInfo.countyName ? myInfo.countyName : @"未设置";
                //手机号码，不可修改
                myInfo.mobile = strAccount;
                //地址
                //            myInfo.address = [dictInfo objectForKey:@"address"];
                //邮编
                //            myInfo.postNo = [dictInfo objectForKey:@"postNo"];
                //其他电话号码
                myInfo.phone = @"未设置";
                //电子邮件
                myInfo.email = @"未设置";
                
                //头像数据
                myInfo.avatarImage = photo ? [self downloadAvatar:photo] : nil;
                
                [[MCMyInfoDAO sharedManager] insert:myInfo];
                DLog(@"创建个人资料成功");
                
                return;
            }

            //重新封装json数据
            NSData *dataInfo = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictInfo = [NSJSONSerialization JSONObjectWithData:dataInfo options:NSJSONReadingAllowFragments error:nil];

            MCMyInfo *localMyInfo = [[MCMyInfoDAO sharedManager] findByAccount:strAccount];
            if (!localMyInfo) {
                //清除信息
                [[MCMyInfoDAO sharedManager] removeAll];
                MCMyInfo *myInfo = [[MCMyInfo alloc] init];
                
                //新增
                NSString *photo = [dictInfo objectForKey:@"photo"];
                //id
                myInfo.id = [dictInfo objectForKey:@"id"];
                //用户名称
                myInfo.userName = [dictInfo objectForKey:@"userName"];
                myInfo.userName = myInfo.userName ? myInfo.userName : @"未设置";
                //性别
                myInfo.gender = [dictInfo objectForKey:@"gender"];
                myInfo.gender = [myInfo.gender isEqualToString:@"F"] ? @"女" : @"男";
                //生日
                myInfo.birthdayString = [dictInfo objectForKey:@"birthdayString"];
                myInfo.birthdayString = myInfo.birthdayString ? myInfo.birthdayString : @"未设置";
                //头像文件下载路径
                myInfo.photo = photo;
                //省份id
                myInfo.provinceId = [dictInfo objectForKey:@"provinceId"];
                myInfo.provinceId = myInfo.provinceId ? myInfo.provinceId : @"未设置";
                //省份名称
                myInfo.provinceName = [dictInfo objectForKey:@"provinceName"];
                myInfo.provinceName = myInfo.provinceName ? myInfo.provinceName : @"未设置";
                //城市id
                myInfo.cityId = [dictInfo objectForKey:@"cityId"];
                myInfo.cityId = myInfo.cityId ? myInfo.cityId : @"未设置";
                //城市名称
                myInfo.cityName = [dictInfo objectForKey:@"cityName"];
                myInfo.cityName = myInfo.cityName ? myInfo.cityName : @"未设置";
                //县区id
                //            myInfo.countyId = [dictInfo objectForKey:@"countyId"];
                //            myInfo.countyId = myInfo.countyId ? myInfo.countyId : @"未设置";
                //县区名称
                //            myInfo.countyName = [dictInfo objectForKey:@"countyName"];
                //            myInfo.countyName = myInfo.countyName ? myInfo.countyName : @"未设置";
                //手机号码，不可修改
                myInfo.mobile = [dictInfo objectForKey:@"mobile"];
                myInfo.mobile = myInfo.mobile ? myInfo.mobile : strAccount;
                //地址
                //            myInfo.address = [dictInfo objectForKey:@"address"];
                //邮编
                //            myInfo.postNo = [dictInfo objectForKey:@"postNo"];
                //其他电话号码
                myInfo.phone = [dictInfo objectForKey:@"phone"];
                myInfo.phone = myInfo.phone ? myInfo.phone : @"未设置";
                //电子邮件
                myInfo.email = [dictInfo objectForKey:@"email"];
                myInfo.email = myInfo.email ? myInfo.email : @"未设置";
                
                //头像数据
                myInfo.avatarImage = photo ? [self downloadAvatar:photo] : nil;
                
                [[MCMyInfoDAO sharedManager] insert:myInfo];
                DLog(@"创建个人资料成功");
            }
            else {
                //更新
                NSString *photo = [dictInfo objectForKey:@"photo"];
                if (photo && ![localMyInfo.photo isEqualToString:photo]) {
                    DLog(@"-----------更新头像------------");
                    //头像文件下载路径
                    localMyInfo.photo = photo;
                    localMyInfo.avatarImage = [self downloadAvatar:photo];
                }
                
                //id
                localMyInfo.id = [dictInfo objectForKey:@"id"];
                //用户名称
                localMyInfo.userName = [dictInfo objectForKey:@"userName"];
                localMyInfo.userName = localMyInfo.userName ? localMyInfo.userName : @"未设置";
                //性别
                localMyInfo.gender = [dictInfo objectForKey:@"gender"];
                localMyInfo.gender = [localMyInfo.gender isEqualToString:@"F"] ? @"女" : @"男";
                //生日
                localMyInfo.birthdayString = [dictInfo objectForKey:@"birthdayString"];
                localMyInfo.birthdayString = localMyInfo.birthdayString ? localMyInfo.birthdayString : @"未设置";
                
                //省份id
                localMyInfo.provinceId = [dictInfo objectForKey:@"provinceId"];
                localMyInfo.provinceId = localMyInfo.provinceId ? localMyInfo.provinceId : @"未设置";
                //省份名称
                localMyInfo.provinceName = [dictInfo objectForKey:@"provinceName"];
                localMyInfo.provinceName = localMyInfo.provinceName ? localMyInfo.provinceName : @"未设置";
                //城市id
                localMyInfo.cityId = [dictInfo objectForKey:@"cityId"];
                localMyInfo.cityId = localMyInfo.cityId ? localMyInfo.cityId : @"未设置";
                //城市名称
                localMyInfo.cityName = [dictInfo objectForKey:@"cityName"];
                localMyInfo.cityName = localMyInfo.cityName ? localMyInfo.cityName : @"未设置";
                //县区id
                //            myInfo.countyId = [dictInfo objectForKey:@"countyId"];
                //            myInfo.countyId = myInfo.countyId ? myInfo.countyId : @"未设置";
                //县区名称
                //            myInfo.countyName = [dictInfo objectForKey:@"countyName"];
                //            myInfo.countyName = myInfo.countyName ? myInfo.countyName : @"未设置";
                //手机号码，不可修改
                localMyInfo.mobile = [dictInfo objectForKey:@"mobile"];
                localMyInfo.mobile = localMyInfo.mobile ? localMyInfo.mobile : strAccount;
                //地址
                //            myInfo.address = [dictInfo objectForKey:@"address"];
                //邮编
                //            myInfo.postNo = [dictInfo objectForKey:@"postNo"];
                //其他电话号码
                localMyInfo.phone = [dictInfo objectForKey:@"phone"];
                localMyInfo.phone = localMyInfo.phone ? localMyInfo.phone : @"未设置";
                //电子邮件
                localMyInfo.email = [dictInfo objectForKey:@"email"];
                localMyInfo.email = localMyInfo.email ? localMyInfo.email : @"未设置";
                
                [[MCMyInfoDAO sharedManager] modify:localMyInfo];
                DLog(@"更新个人资料成功");
            }
        }
        else {
            DLog(@"个人资料获取失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"个人资料获取请求发生错误\n %@", error);

    }];
}

- (NSData *)downloadAvatar:(NSString *)strURL
{
    strURL = [strURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"_mini.jpg"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    //同步请求
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        return response;
    }
    
    return nil;
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
