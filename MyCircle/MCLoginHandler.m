//
//  MCLoginHandler.m
//  MyCircle
//
//  Created by Samuel on 11/6/13.
//
//

#import "MCLoginHandler.h"

@implementation MCLoginHandler

+ (NSInteger)isLoginedSuccessfully:(NSString *)strAccount password:(NSString *)cipherPwd {
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://117.21.209.104/EasyContact/Contact/contact!loginAjax.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:strAccount forKey:@"tel"];
    [request addPostValue:cipherPwd forKey:@"password"];
#warning 修改为随机数
    [request addPostValue:@"12345" forKey:@"stamp"];
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
        DLog(@"\n 服务器返回:\n%@", strJsonResult);
        
        //重新封装json数据
        NSData *dataLoginResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dictLoginResponse = [NSJSONSerialization JSONObjectWithData:dataLoginResponse options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strLoginResult = [NSString stringWithFormat:@"%@",[[dictLoginResponse objectForKey:@"root"] objectForKey:@"result"]];
        DLog(@"\n 登陆结果:%@", [strLoginResult isEqualToString:@"1"] ? @"true" : @"false");
        BOOL isLogined = [strLoginResult isEqualToString:@"1"];
        if (isLogined) {
            //保存用户名和密码
            [self saveNSUserDefaults:strAccount password:cipherPwd];
            
            //提取组织id
            NSArray *arrOrgInfo = [[dictLoginResponse objectForKey:@"root"] objectForKey:@"enterprise"];
            //        //删除数据
            //        MCBookBL *bookBL = [[MCBookBL alloc] init];
            //        BOOL isDeletedAll = [bookBL removeAll];
            //        if (isDeletedAll) {
            //            DLog(@"删除完毕");
            //        }
            //构建下载队列获取人员部门信息
            //        NSInvocationOperation *operation;
            //        self.downloadQueue = [NSOperationQueue new];
            //        [self.downloadQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
            //        [self.downloadQueue setMaxConcurrentOperationCount:1];
            
            
            //清除不再拥有的enterprise数据以及下属的联系人数据
            MCOrgBL *orgBL = [[MCOrgBL alloc] init];
#warning AAA优先处理
//            NSMutableArray *orgList = [orgBL findAll];
//            for (MCOrg *org in orgList) {
//                for (NSDictionary *dictOrgInfo in arrOrgInfo) {
//                    if ([org.id isEqualToString:[NSString stringWithFormat:@"%@", [dictOrgInfo objectForKey:@"id"]]]) {
//                        continue;
//                    }
//                }
//
//            }
            
            BOOL isClear = [orgBL removeAll];
            if (!isClear) {
#warning 提示用户数据处理异常
                DLog(@"清空enterprise数据失败");
            }
            else {
                for (NSDictionary *dictOrgInfo in arrOrgInfo) {
                    //保存enterprise数据
                    MCOrg *org = [[MCOrg alloc] init];
                    org.id = [NSString stringWithFormat:@"%@", [dictOrgInfo objectForKey:@"id"]];
                    org.name = [NSString stringWithFormat:@"%@", [dictOrgInfo objectForKey:@"name"]];
                    
                    BOOL isSaved = [orgBL create:org];
                    if (!isSaved) {
#warning 提示用户数据更新不完整
                        DLog(@"插入enterprise数据失败");
                    }
                    
//                    MCOrgBL *orgBLTemp = [[MCOrgBL alloc] init];
//                    NSMutableArray *orgList = [orgBLTemp findAll];
//                    DLog(@"enterprise amount:%d", orgList.count);
                    //使用队列下载圈子数据
                    //                NSURL *bookAndDepartmentUrl = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://117.21.209.104/EasyContact/Contact/contact!syncAjax.action?orgId=%@&tel=%@",[dictOrgInfo objectForKey:@"id"],strAccount]];
                    //                operation = [[NSInvocationOperation alloc]
                    //                             initWithTarget:self
                    //                             selector:@selector(download:)
                    //                             object:bookAndDepartmentUrl];
                    //                [self.downloadQueue addOperation:operation];
                }
            }
            DLog(@"\n 登陆成功");
            return 0;
        }
        else {
            DLog(@"\n 登陆失败");
            DLog(@"手机号或密码错误");
            return 1;
        }
    }
    else {
        DLog(@"\n 登陆请求发生错误\n %@", error);
        return 2;
    }
}

//-(void)download:(NSURL *)url
//{
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    //doSomethingHereWithData;
//    //保存数据
//    NSDictionary *dictRoot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    //判断是否清除该组织的所有人员和部门数据
//    NSString *strClearAll = [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"clearLocaldataAll"]];
//    BOOL isClearAll = [strClearAll isEqualToString:@"1"];
//    if (isClearAll) {
//        //获取belongOrgId
//#warning 获取方式可以优化为截取字符串
//        NSString *belongOrgId = [NSString stringWithFormat:@"%@", [[[[dictRoot objectForKey:@"root"] objectForKey:@"book"] lastObject] objectForKey:@"belongOrgId"]];
//        //删除人员数据
//        MCBookBL *bookBL = [[MCBookBL alloc] init];
//        BOOL isDeletedAll = [bookBL removeByOrgId:belongOrgId];
//        if (isDeletedAll) {
//            DLog(@"%@ 的人员删除完毕", belongOrgId);
//        }
//        //删除部门数据
//        MCDeptBL *deptBL = [[MCDeptBL alloc] init];
//        isDeletedAll = [deptBL removeByOrgId:belongOrgId];
//        if (isDeletedAll) {
//            DLog(@"%@ 的部门删除完毕", belongOrgId);
//        }
//
//    }
//    //更新人员数据
//    NSArray *arrBook = [[dictRoot objectForKey:@"root"] objectForKey:@"book"];
//    for (NSDictionary *dict in arrBook) {
//        MCBook *book = [[MCBook alloc] init];
//        book.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
//        book.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"personName"]];
//        book.mobilePhone = [NSString stringWithFormat:@"%@", [dict objectForKey:@"mobilePhone"]];
//        book.officePhone = [NSString stringWithFormat:@"%@", [dict objectForKey:@"officePhone"]];
//        book.position = [NSString stringWithFormat:@"%@", [dict objectForKey:@"position"]];
//        book.sort = [dict objectForKey:@"sort"];
//        book.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
//        book.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
//        book.belongDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongDepartmentId"]];
//        book.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
//
//        MCBookBL *bookBL = [[MCBookBL alloc] init];
//        BOOL isCreatedSuccessfully = [bookBL create:book];
//        if (!isCreatedSuccessfully) {
//#warning 提示用户数据更新不完整
//            DLog(@"插入book失败");
//        }
//    }
//
//    MCBookBL *bookBL = [[MCBookBL alloc] init];
//    NSMutableArray *bookList = [bookBL findAll];
//    DLog(@"book amount:%d", bookList.count);
//
//    //更新部门数据
//    NSArray *arrDept = [[dictRoot objectForKey:@"root"] objectForKey:@"department"];
//    for (NSDictionary *dict in arrDept) {
//        MCDept *dept = [[MCDept alloc] init];
//        dept.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
//        dept.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
//        dept.sort = [dict objectForKey:@"sort"];
//        dept.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
//        dept.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
//        dept.upDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"upDepartmentId"]];
//        dept.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
//
//        MCDeptBL *deptBL = [[MCDeptBL alloc] init];
//        BOOL isCreatedSuccessfully = [deptBL create:dept];
//        if (!isCreatedSuccessfully) {
//#warning 提示用户数据更新不完整
//            DLog(@"插入dept失败");
//        }
//    }
//
//    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
//    NSMutableArray *deptList = [deptBL findAll];
//    DLog(@"department amount:%d", deptList.count);
//
//
//}

//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([self.downloadQueue.operations count] == 0)
//    {
//#warning 提示用户获取数据成功
//        DLog(@"圈子数据更新完毕");
//    }
//}

//保存数据到NSUserDefaults
+ (void)saveNSUserDefaults:(NSString *)user password:(NSString *)pwd {
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user forKey:@"user"];
    [userDefaults setObject:pwd forKey:@"password"];
    
    //这里建议同步存储到磁盘中，但是不是必须的
    [userDefaults synchronize];
    
}

@end
