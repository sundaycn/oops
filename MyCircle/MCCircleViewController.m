//
//  MCCircleViewController.m
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import "MCCircleViewController.h"

@interface MCCircleViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation MCCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareShowCard:) name:@"DidSelectLeafNodeNotification" object:nil];
    //ios6 ios7导航条适配
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 6) {
//        DLog(@"123");
//        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    }
//    else {
//        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    }
    
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x3d97e9);
        
    }
    else {
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3d97e9);
    }
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    //修改导航栏返回按钮的文字
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    //初始化圈子树视图
    //self.data = [NSArray arrayWithObjects:phone, computer, car, bike, house, flats, motorbike, drinks, food, sweets, watches, walls, nil];
    //    self.data = [MCCircleDataHandler getDataOfCircle];
    
//    CGRect treeViewFrame = CGRectMake(0, 110, 320, self.view.frame.size.height);
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
//    RATreeView *treeView = [[RATreeView alloc] initWithFrame:treeViewFrame];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    //    [treeView reloadData];
    //    [treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    self.treeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:treeView];
    
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//        float heightPadding = statusBarViewRect.size.height;
        float heightBottom = self.tabBarController.tabBar.frame.size.height;
        //        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding-heightBottom);
    }
//    self.treeView.frame = self.view.bounds;
    
    //绑定并刷新圈子树数据
    self.data = [MCCircleDataHandler getDataOfCircle];
    [self.treeView reloadData];
    
    //检测网络连接
#warning 检测网络连接
//    Reachability *r= [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch([r currentReachabilityStatus])
//    {    case NotReachable:
//            // 没有网络连接
//            break;
//        case ReachableViaWWAN:
//            // 使用3G网络
//            break;
//        case ReachableViaWiFi:
//            // 使用WiFi网络
//            break;
//    }
    if ([self IsEnableWIFI] || [self IsEnable3G]) {
        //同步圈子数据
        //提示用户正在同步中
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"正在同步圈子数据";
        
        [HUD showWhileExecuting:@selector(startSynchronizeData) onTarget:self withObject:nil animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
////        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
//        float heightPadding = statusBarViewRect.size.height;
//        float heightBottom = self.tabBarController.tabBar.frame.size.height;
////        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
//        self.treeView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
//        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding-heightBottom);
//    }
    self.treeView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 是否启动wifi
- (BOOL) IsEnableWIFI {
    return([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否启动3G
- (BOOL) IsEnable3G {
    return([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

- (void)startSynchronizeData
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *strAccount = [userDefaultes stringForKey:@"user"];
//    DLog(@"%@", strAccount);
    MCOrgBL *orgBL = [[MCOrgBL alloc] init];
    NSMutableArray *orgList = [orgBL findAll];
    for (MCOrg *org in orgList) {
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://117.21.209.104/EasyContact/Contact/contact!syncAjax.action?orgId=%@&tel=%@",org.id,strAccount]];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//        
//        //同步请求
//        NSError *error = nil;
//        NSData *response  = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        if (response == nil) {
//            DLog(@"同步请求发生错误\n %@", error);
//            //弹出警告窗
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"请检查网络连接是否正常，并尝试重新登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            //optional - add more buttons:
//            //[alert addButtonWithTitle:@"Yes"];
//            alert.tag = 1;
//            [alert show];
//            
//            return;
//        }
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        //保存数据
        NSDictionary *dictRoot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //判断是否清除该组织的所有人员和部门数据
        NSString *strClearAll = [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"clearLocaldataAll"]];
        BOOL isClearAll = [strClearAll isEqualToString:@"1"];
        if (isClearAll) {
            //获取belongOrgId
#warning 获取方式可以优化为截取字符串
            NSString *belongOrgId = [NSString stringWithFormat:@"%@", [[[[dictRoot objectForKey:@"root"] objectForKey:@"book"] lastObject] objectForKey:@"belongOrgId"]];
            //删除人员数据
            MCBookBL *bookBL = [[MCBookBL alloc] init];
            BOOL isDeletedAll = [bookBL removeByOrgId:belongOrgId];
            if (isDeletedAll) {
                DLog(@"%@ 的人员删除完毕", belongOrgId);
            }
            //删除部门数据
            MCDeptBL *deptBL = [[MCDeptBL alloc] init];
            isDeletedAll = [deptBL removeByOrgId:belongOrgId];
            if (isDeletedAll) {
                DLog(@"%@ 的部门删除完毕", belongOrgId);
            }
            
        }
        //更新人员数据
        NSArray *arrBook = [[dictRoot objectForKey:@"root"] objectForKey:@"book"];
        for (NSDictionary *dict in arrBook) {
            MCBook *book = [[MCBook alloc] init];
            book.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
            book.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"personName"]];
            book.mobilePhone = [NSString stringWithFormat:@"%@", [dict objectForKey:@"mobilePhone"]];
            book.officePhone = [NSString stringWithFormat:@"%@", [dict objectForKey:@"officePhone"]];
            book.position = [NSString stringWithFormat:@"%@", [dict objectForKey:@"position"]];
            book.sort = [dict objectForKey:@"sort"];
            book.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
            book.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
            book.belongDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongDepartmentId"]];
            book.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
            
            MCBookBL *bookBL = [[MCBookBL alloc] init];
            BOOL isCreatedSuccessfully = [bookBL create:book];
            if (!isCreatedSuccessfully) {
#warning 提示用户数据更新不完整
                DLog(@"插入book失败");
            }
        }
        
        MCBookBL *bookBL = [[MCBookBL alloc] init];
        NSMutableArray *bookList = [bookBL findAll];
        DLog(@"book amount:%d", bookList.count);
        
        //更新部门数据
        NSArray *arrDept = [[dictRoot objectForKey:@"root"] objectForKey:@"department"];
        for (NSDictionary *dict in arrDept) {
            MCDept *dept = [[MCDept alloc] init];
            dept.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
            dept.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
            dept.sort = [dict objectForKey:@"sort"];
            dept.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
            dept.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
            dept.upDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"upDepartmentId"]];
            dept.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
            
            MCDeptBL *deptBL = [[MCDeptBL alloc] init];
            BOOL isCreatedSuccessfully = [deptBL create:dept];
            if (!isCreatedSuccessfully) {
#warning 提示用户数据更新不完整
                DLog(@"插入dept失败");
            }
        }
        
        MCDeptBL *deptBL = [[MCDeptBL alloc] init];
        NSMutableArray *deptList = [deptBL findAll];
        DLog(@"department amount:%d", deptList.count);

    }
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded]) {
        return YES;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    } else if (treeNodeInfo.treeDepthLevel == 3) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 4) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
    
//    cell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
//    NSInteger numberOfChildren = [treeNodeInfo.children count];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %d", numberOfChildren];
    cell.textLabel.text = ((MCDataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (treeNodeInfo.treeDepthLevel == 0) {
//        cell.detailTextLabel.textColor = [UIColor blackColor];
//    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    MCDataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    MCDataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

#pragma mark handle the notification
- (void)prepareShowCard:(NSNotification *)notification
{
    NSDictionary *dictUserInfo = [notification userInfo];
    self.bookId = [dictUserInfo objectForKey:@"id"];
    [self performSegueWithIdentifier:@"showCard" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCard"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        
//        ABRecordRef thisPerson = CFBridgingRetain([self.listContacts objectAtIndex:[indexPath row]]);
//        MCContactsDetailViewController *detailViewController = [segue destinationViewController];
//        
//        ABRecordID personID = ABRecordGetRecordID(thisPerson);
//        NSNumber *personIDAsNumber = [NSNumber numberWithInt:personID];
//        detailViewController.personIDAsNumber = personIDAsNumber;
//        
//        CFRelease(thisPerson);
        MCContactsDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.bookId = self.bookId;
    }
}

#pragma mark- MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
    
    //绑定并刷新圈子树数据
    self.data = [MCCircleDataHandler getDataOfCircle];
    [self.treeView reloadData];
}

@end
