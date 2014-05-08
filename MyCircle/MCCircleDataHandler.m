//
//  MCCircleDataHandler.m
//  MyCircle
//
//  Created by Samuel on 10/21/13.
//
//

#import "MCCircleDataHandler.h"
#import "MCConfig.h"
#import "MCLoginHandler.h"
#import "MCContactsSearchLibrary.h"

@implementation MCCircleDataHandler

+ (NSMutableArray *)getDataOfCircle
{
    NSMutableArray *root = [[NSMutableArray alloc] init];
    MCOrgBL *orgBL = [[MCOrgBL alloc] init];
    NSArray *arrOrg = [orgBL findAll];
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    for (MCOrg *org in arrOrg) {
        NSArray *arrDept = [deptBL findByUpDeptId:org.id upDepartmentId:@"-1"];
        if ([arrDept count] == 1) {
            MCDept *dept = [arrDept lastObject];
            NSMutableArray *nodesList = [self getNodesOfOrg:org.id upDepartmentId:dept.id];
            MCDataObject *deptNode = [MCDataObject dataObjectWithId:dept.id type:@"dept" name:dept.name children:nodesList];
            [root addObject:deptNode];
        }
        else
#warning 提示用户圈子根节点不唯一
            DLog(@"根部门不唯一");
    }

    return root;
}

+ (NSMutableArray *)getNodesOfOrg:(NSString *)orgId upDepartmentId:(NSString *)upDeptId {
#warning 可以优化
    NSMutableArray *result = [[NSMutableArray alloc] init];
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    NSArray *arrDept = [deptBL findByUpDeptId:orgId upDepartmentId:upDeptId];
    if ([arrDept count] != 0) {
        for (MCDept *dept in arrDept) {
            NSMutableArray *nodesList = [self getNodesOfOrg:orgId upDepartmentId:dept.id];
            MCDataObject *deptNode = [MCDataObject dataObjectWithId:dept.id type:@"dept" name:dept.name children:nodesList];
            [result addObject:deptNode];
        }
    }
    else {
        MCBookBL *bookBL = [[MCBookBL alloc] init];
        NSArray *arrBook = [bookBL findByBelongDeptId:orgId upDepartmentId:upDeptId];
        for (MCBook *book in arrBook) {
            NSMutableArray *nodesList = [self getNodesOfOrg:orgId upDepartmentId:book.belongDepartmentId];
            MCDataObject *bookNode = [MCDataObject dataObjectWithId:book.id type:@"member" name:book.name children:nodesList];
            [result addObject:bookNode];
        }
    }
    
    return result;
}

//更新联系人数据
+ (void)updateContactsData:(NSString *)strAccount
{
    MCOrgBL *orgBL = [[MCOrgBL alloc] init];
    NSArray *arrOrgId = [orgBL findAllId];
    //    NSArray *arrOrgObj = [orgBL findAll];
    //    for (MCOrg *obj in arrOrgObj) {
    //        DLog(@"name:%@ version:%@", obj.name, obj.version);
    //    }
    //删除不再归属当前用户的联系人数据
    MCBookBL *bookBL = [[MCBookBL alloc] init];
    [bookBL removeStaffNotInOrgIdSet:arrOrgId];
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    [deptBL removeDeptNotInOrgIdSet:arrOrgId];
#warning data might be nil, need to handle error
    //更新联系人数据
    for (NSString *strOrgId in arrOrgId) {
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:[BASE_URL stringByAppendingString:@"Contact/contact!syncAjax.action?orgId=%@&tel=%@"], strOrgId, strAccount]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //保存数据
        NSDictionary *dictRoot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //判断本地保存的数据版本号与服务器返回是否一致，如不同则保存新的数据版本号并更新本地联系人数据
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        NSString *remoteContactsVersion = [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"newestVersion"]];
        DLog(@"服务器%@联系人版本号:%@", strOrgId, remoteContactsVersion);
        NSString *localContactsVersion = [orgBL findVersionByOrgId:strOrgId];
        DLog(@"本地%@联系人版本号:%@", strOrgId, localContactsVersion);
        if ([localContactsVersion isEqualToString:remoteContactsVersion]) {
            //版本号一致，该组织联系人数据无需更新
            continue;
        }
        
        //判断是否清除该组织的所有人员和部门数据
        NSString *strClearAll = [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"clearLocaldataAll"]];
        BOOL isClearAll = [strClearAll isEqualToString:@"1"];
        if (isClearAll) {
            //删除人员数据
            BOOL isDeletedAll = [bookBL removeByOrgId:strOrgId];
            if (isDeletedAll) {
                DLog(@"%@ 的人员删除完毕", strOrgId);
            }
            //删除部门数据
            isDeletedAll = [deptBL removeByOrgId:strOrgId];
            if (isDeletedAll) {
                DLog(@"%@ 的部门删除完毕", strOrgId);
            }
        }
        
        //更新人员数据
        NSArray *arrBook = [[dictRoot objectForKey:@"root"] objectForKey:@"book"];
        [self updateStaffData:arrBook];
#ifdef DEBUG
        NSArray *bookList = [bookBL findAll];
        DLog(@"book amount:%d", bookList.count);
#endif
        
        //更新部门数据
        NSArray *arrDept = [[dictRoot objectForKey:@"root"] objectForKey:@"department"];
        [self updateDeptData:arrDept];
#ifdef DEBUG
        NSArray *deptList = [deptBL findAll];
        DLog(@"department amount:%d", deptList.count);
#endif
        
        //保存最新联系人数据版本号
        [orgBL updateVersionByOrgId:strOrgId version:remoteContactsVersion];
        
    }
    
    //保存用户姓名
    MCBook *book = [bookBL findbyMobilePhone:strAccount];
    [[MCConfig sharedInstance]saveUserName:book.name];
    
    //初始化联系人搜索库
    [bookBL updateSearchId];
    [MCContactsSearchLibrary initContactsSearchLibrary];
}

+ (void)updateStaffData:(NSArray *)arrBook
{
    for (NSDictionary *dict in arrBook) {
        MCBook *book = [[MCBook alloc] init];
        book.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        //姓名
        book.name = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"personName"]] WithKey:DESDECRYPTED_KEY];
        //移动电话
        book.mobilePhone = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"mobilePhone"]] WithKey:DESDECRYPTED_KEY];
        //其他移动电话(未加密)
        book.deputyMobilePhone = [dict objectForKey:@"deputyMobilePhone"];
        //办公电话
        book.officePhone = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"officePhone"]] WithKey:DESDECRYPTED_KEY];
        //住宅电话
        book.homePhone = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"addressPhone"]] WithKey:DESDECRYPTED_KEY];
        //短号
        book.mobileShort = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"mobileShort"]] WithKey:DESDECRYPTED_KEY];
        //传真号码
        book.faxNumber = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"faxNumber"]] WithKey:DESDECRYPTED_KEY];
        //电子邮箱
        book.email = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"email"]] WithKey:DESDECRYPTED_KEY];
        //工作职位
        book.position = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"position"]] WithKey:DESDECRYPTED_KEY];
        book.sort = [dict objectForKey:@"sort"];
        book.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        book.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
        book.belongDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongDepartmentId"]];
        book.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
        
        MCBookBL *bookBL = [[MCBookBL alloc] init];
        if ([book.syncFlag isEqualToString:@"A"]) {
            //增加
            //可能更新不完整
            [bookBL create:book];
        }
        else if ([book.syncFlag isEqualToString:@"M"]) {
            //修改
            [bookBL modify:book];
        }
        else if ([book.syncFlag isEqualToString:@"D"]) {
            //删除
            [bookBL remove:book];
        }
    }
}

+ (void)updateDeptData:(NSArray *) arrDept
{
    for (NSDictionary *dict in arrDept) {
        MCDept *dept = [[MCDept alloc] init];
        dept.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        dept.name = [MCCrypto DESDecrypt:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]] WithKey:DESDECRYPTED_KEY];
        dept.sort = [dict objectForKey:@"sort"];
        dept.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        dept.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
        dept.upDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"upDepartmentId"]];
        dept.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
        
        MCDeptBL *deptBL = [[MCDeptBL alloc] init];
        if ([dept.syncFlag isEqualToString:@"A"]) {
            //增加
            //可能更新不完整
            [deptBL create:dept];
        }
        else if ([dept.syncFlag isEqualToString:@"M"]) {
            //修改
            [deptBL modify:dept];
        }
        else if ([dept.syncFlag isEqualToString:@"D"]) {
            //删除
            [deptBL remove:dept];
        }
    }
}

@end
