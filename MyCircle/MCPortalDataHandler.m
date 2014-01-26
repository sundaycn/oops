//
//  MCPortalDataHandler.m
//  MyCircle
//
//  Created by Samuel on 11/25/13.
//
//

#import "MCPortalDataHandler.h"

static int totalPages;

@implementation MCPortalDataHandler

+ (NSArray *)getPortalList:(NSString *)pageSize pageNo:(NSString *)pageNo
{
    NSString *strURL = [BASE_URL stringByAppendingString:@"TcompanyInfo/tcompanyinfo!listAjaxp.action"];
    NSURL *url = [NSURL URLWithString:strURL];
//    NSURL *url = [NSURL URLWithString:@"http://59.52.226.85:8888/EasyContactFY/TcompanyInfo/tcompanyinfo!listAjaxp.action"];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:pageSize forKey:@"page.pageSize"];
    [request addPostValue:pageNo forKey:@"page.pageNo"];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strRequestResult = [NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"success"]];
        DLog(@"微门户列表请求结果:%@", [strRequestResult isEqualToString:@"1"] ? @"true" : @"false");
        BOOL requestResult = [strRequestResult isEqualToString:@"1"];
        if (requestResult) {
//            DLog(@"\n pageSize:%@", [[dictResponse objectForKey:@"message"] objectForKey:@"pageSize"]);
//            DLog(@"\n pageNo:%@", [[dictResponse objectForKey:@"message"] objectForKey:@"pageNo"]);
            NSArray *arrResult = [[dictResponse objectForKey:@"message"] objectForKey:@"result"];
            totalPages = [(NSNumber *)[[dictResponse objectForKey:@"message"] objectForKey:@"totalPages"] intValue];
            return arrResult;
        }
    }
    return  nil;
}

+ (NSInteger)getPortalListCount
{
    return totalPages;
}

@end
