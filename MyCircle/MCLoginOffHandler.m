//
//  MCLoginOffHandler.m
//  MyCircle
//
//  Created by Samuel on 1/26/14.
//
//

#import "MCLoginOffHandler.h"
#import "MCConfig.h"
#import "MCOrgBL.h"
#import "MCDeptBL.h"
#import "MCBookBL.h"
#import "MCChatHistoryDAO.h"
#import "MCChatSessionDAO.h"
#import "MCMicroManagerDAO.h"
#import "MCMicroManagerAccountDAO.h"

@implementation MCLoginOffHandler

+ (void)prepareForLoginOff
{
    //2.登陆状态改为未登录
    [[MCConfig sharedInstance] setLoginOff];
    //3.清除ContactsData
    MCOrgBL *orgBL = [[MCOrgBL alloc] init];
    [orgBL removeAll];
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    [deptBL removeAll];
    MCBookBL *bookBL = [[MCBookBL alloc] init];
    [bookBL removeAll];

    //5.清除MicroManager,MicroManagerAccount
    [[MCMicroManagerDAO sharedManager] deleteAll];
    [[MCMicroManagerAccountDAO sharedManager] deleteAll];
    //6.清除cookie
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //7.删除Documents文件夹里下载的文件
}

@end
