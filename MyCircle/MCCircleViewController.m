//
//  MCCircleViewController.m
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import "MCCircleViewController.h"
#import <Reachability/Reachability.h>
#import "MCConfig.h"
#import "MCCircleViewController.h"
#import "RATreeView.h"
#import "MCDataObject.h"
#import "MCLoginHandler.h"
#import "MCCircleDataHandler.h"
#import "MCCircleOrgAndDeptCell.h"
#import "MCCircleMemberCell.h"
#import "MCContactsDetailViewController.h"
#import "MCViewController.h"
#import "MCBook.h"
#import "MCBookBL.h"
#import "MCCrypto.h"
#import "MCContactsSearchLibrary.h"
#import "SearchCoreManager.h"

@interface MCCircleViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;
@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation MCCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareShowCard:) name:@"DidSelectLeafNodeNotification" object:nil];
    //create searchDisplayController and searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    searchBar.delegate = self;
    searchBar.showsCancelButton = NO;
    searchBar.placeholder = @"请输入联系人姓名或手机号码";

    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.mySearchDisplayController.searchResultsDataSource = self;
    self.mySearchDisplayController.searchResultsDelegate = self;
    self.mySearchDisplayController.delegate = self;
    //用于保存搜索结果
    self.searchByName = [[NSMutableArray alloc] init];
    self.searchByPhone = [[NSMutableArray alloc] init];

    //修改导航栏返回按钮的文字
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = barButtonItem;
    //添加刷新按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = rightButton;

    float statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    float navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    float tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    float heightPadding = statusBarHeight + navigationBarHeight + tabBarHeight;;
    
    //初始化圈子树
    CGRect treeViewFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-heightPadding);
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:treeViewFrame];

    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    treeView.separatorColor = UIColorFromRGB(0xd1cfcf);
    treeView.backgroundColor = UIColorFromRGB(0xF7F7F7);
    treeView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    treeView.treeHeaderView = self.mySearchDisplayController.searchBar;
    self.treeView = treeView;
    self.data = [MCCircleDataHandler getDataOfCircle];
    [self.treeView reloadData];
    [self.view addSubview:treeView];
    
    //初始化搜索库
    [MCContactsSearchLibrary initContactsSearchLibrary];

    
//    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
//        self.treeView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
//        self.treeView.contentOffset = CGPointMake(0.0, 44.0);
//
//    }

    //检测网络连接
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // The search bar is hidden when the view becomes visible at the first time
//    self.treeView.contentOffset = CGPointMake(0, CGRectGetHeight(self.mySearchDisplayController.searchBar.bounds));
//    self.treeView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 是否启动wifi
- (BOOL)isEnableWIFI {
    return([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否启动3G
- (BOOL)isEnable3G {
    return([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

- (void)refresh
{
    //提示用户正在刷新
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"正在同步...";
	
	[HUD showWhileExecuting:@selector(updateContactsData) onTarget:self withObject:nil animated:NO];

}

- (void)showHUD:(NSInteger)type {
    // UIImageView is a UIKit class, we have to initialize it on the main thread
    __block UIImageView *imageView;
    switch (type) {
        case 0:
            //成功
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageNamed:@"HUDSuccessImage"];
                imageView = [[UIImageView alloc] initWithImage:image];
            });
            HUD.customView = imageView;
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"同步成功";
            sleep(1);
            break;
        case 1:
            //失败
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageNamed:@"HUDFailureImage"];
                imageView = [[UIImageView alloc] initWithImage:image];
            });
            HUD.customView = imageView;
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"同步失败";
            sleep(1);
            break;
        default:
            break;
    }
}

//更新联系人数据
- (void)updateContactsData
{
    NSString *strAccount = [[MCConfig sharedInstance] getAccount];
    NSString *strCipherPwd = [[MCConfig sharedInstance] getCipherPassword];
    if ([MCLoginHandler isLoginedSuccessfully:strAccount password:strCipherPwd] != 0) {
        //登陆获取组织数据失败
        [self showHUD:1];
        return;
    }

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
    //初始化联系人搜索库
    [bookBL updateSearchId];
    [MCContactsSearchLibrary initContactsSearchLibrary];
    
    [self showHUD:0];
}

- (void)updateStaffData:(NSArray *)arrBook
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

- (void)updateDeptData:(NSArray *) arrDept
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

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 40;
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
//    if (treeNodeInfo.treeDepthLevel == 0) {
//        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
//    } else if (treeNodeInfo.treeDepthLevel == 1) {
//        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
//    } else if (treeNodeInfo.treeDepthLevel == 2) {
//        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
//    } else if (treeNodeInfo.treeDepthLevel == 3) {
//        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
//    } else if (treeNodeInfo.treeDepthLevel == 4) {
//        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
//    }
    
    cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //关闭编辑模式
    return UITableViewCellEditingStyleNone;
}

#pragma mark TreeView Data Source
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    static NSString *deptCellIdentifier = @"dept";
    MCCircleOrgAndDeptCell *depCell;
    static NSString *memberCellIdentifier = @"member";
    MCCircleMemberCell *memberCell;
    
    if ([((MCDataObject *)item).type isEqualToString:@"dept"]) {
        depCell= [treeView dequeueReusableCellWithIdentifier:deptCellIdentifier];
        if (depCell == nil) {
            depCell = [[MCCircleOrgAndDeptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deptCellIdentifier];
        }
        
        depCell.lableText.text = ((MCDataObject *)item).name;
        depCell.lableText.font = [UIFont fontWithName:@"Heiti SC" size:15];
        depCell.lableText.textColor = UIColorFromRGB(0x585858);
//        depCell.lableText.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        
        if (treeNodeInfo.treeDepthLevel == 0) {
            depCell.imageViewTree.image = [UIImage imageNamed:@"TreeRootImage"];
        }
        else
        {
            depCell.imageViewTree.image = [UIImage imageNamed:@"TreeBranchImage"];
        }
        
        return depCell;
    }
    else {
        memberCell = [treeView dequeueReusableCellWithIdentifier:memberCellIdentifier];
        if (memberCell == nil) {
            memberCell = [[MCCircleMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:memberCellIdentifier];
            memberCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        MCBookBL *bookBL = [[MCBookBL alloc] init];
        MCBook *book = [bookBL findById:((MCDataObject *)item).bookId];
        memberCell.lableName.text = ((MCDataObject *)item).name;
        memberCell.lableName.font = [UIFont fontWithName:@"Heiti SC" size:15];
        memberCell.lableName.textColor = UIColorFromRGB(0x585858);
        CGSize sizeName = [memberCell.lableName.text sizeWithFont:memberCell.lableName.font];
        CGRect newFrame = memberCell.lableName.frame;
        newFrame.size.width = sizeName.width;
        memberCell.lableName.frame = newFrame;
        memberCell.labelTitle.text = book.position;
        memberCell.labelTitle.font = [UIFont fontWithName:@"Heiti SC" size:12];
        memberCell.labelTitle.textColor = UIColorFromRGB(0x1f82d6);
        memberCell.labelTitle.frame = CGRectMake(CGRectGetMaxX(memberCell.lableName.frame)+5, memberCell.labelTitle.frame.origin.y, memberCell.labelTitle.frame.size.width, memberCell.labelTitle.frame.size.height);
        memberCell.lablePhone.text = book.mobilePhone;
        memberCell.lablePhone.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        memberCell.lablePhone.textColor = UIColorFromRGB(0x8b8b8b);
        
        return memberCell;
    }
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

#pragma mark - UITableView data source and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.mySearchDisplayController.searchBar.text length] <= 0) {
        return 1;
    } else {
        return [self.searchByName count] + [self.searchByPhone count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *searchResultsCellIdentifier = @"searchResultsCell";
	MCCircleMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultsCellIdentifier];
    if (cell == nil) {
        cell = [[MCCircleMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchResultsCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([self.mySearchDisplayController.searchBar.text length] <= 0) {
//        cell.lableName.text = @"samuel";
//        cell.lableName.font = [UIFont fontWithName:@"Heiti SC" size:15];
//        cell.lableName.textColor = UIColorFromRGB(0x585858);
//        CGSize sizeName = [cell.lableName.text sizeWithFont:cell.lableName.font];
//        CGRect newFrame = cell.lableName.frame;
//        newFrame.size.width = sizeName.width;
//        cell.lableName.frame = newFrame;
//        cell.labelTitle.text = @"COO";
//        cell.labelTitle.font = [UIFont fontWithName:@"Heiti SC" size:12];
//        cell.labelTitle.textColor = UIColorFromRGB(0x1f82d6);
//        cell.labelTitle.frame = CGRectMake(CGRectGetMaxX(cell.lableName.frame)+5, cell.labelTitle.frame.origin.y, cell.labelTitle.frame.size.width, cell.labelTitle.frame.size.height);
//        cell.lablePhone.text = @"18979109958";
//        cell.lablePhone.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
//        cell.lablePhone.textColor = UIColorFromRGB(0x8b8b8b);

        return cell;
    }

    NSNumber *searchId = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];

    if (indexPath.row < [self.searchByName count]) {
        searchId = [self.searchByName objectAtIndex:indexPath.row];
        
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        if ([self.mySearchDisplayController.searchBar.text length]) {
            [[SearchCoreManager share] GetPinYin:searchId pinYin:matchString matchPos:matchPos];
        }
    } else {
        searchId = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
        NSMutableArray *matchPhones = [NSMutableArray array];
        
        //号码匹配 获取对应匹配的号码串 及高亮位置
        if ([self.mySearchDisplayController.searchBar.text length]) {
            [[SearchCoreManager share] GetPhoneNum:searchId phone:matchPhones matchPos:matchPos];
            [matchString appendString:[matchPhones objectAtIndex:0]];
        }
    }
    
    MCBookBL *bookBL = [[MCBookBL alloc] init];
    MCBook *book = [bookBL findBySearchId:searchId];
    cell.bookId = book.id;
    cell.lableName.text = book.name;
    cell.lableName.font = [UIFont fontWithName:@"Heiti SC" size:15];
    cell.lableName.textColor = UIColorFromRGB(0x585858);
    [cell.lableName sizeToFit];
    cell.lablePhone.text = book.mobilePhone;
    cell.lablePhone.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    cell.lablePhone.textColor = UIColorFromRGB(0x8b8b8b);
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    MCDept *dept = [deptBL findByDeptId:book.belongDepartmentId belongOrgId:book.belongOrgId];
    cell.labelTitle.text = dept.name;
    cell.labelTitle.font = [UIFont fontWithName:@"Heiti SC" size:12];
    cell.labelTitle.textColor = UIColorFromRGB(0x1f82d6);
    cell.labelTitle.frame = CGRectMake(CGRectGetMaxX(cell.lableName.frame)+5, cell.labelTitle.frame.origin.y, cell.labelTitle.frame.size.width, cell.labelTitle.frame.size.height);

    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCCircleMemberCell *cell = (MCCircleMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.bookId = cell.bookId;
    [self performSegueWithIdentifier:@"showCard" sender:self];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [[SearchCoreManager share] Search:searchString searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark- UISearchBarDelegate
/*
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Text changed");
//    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
//    if (self.searchDisplayController.searchBar.text.length == 0) {
//        [self setSearchControllerHidden:YES]; //控制下拉列表的隐现
//    }else{
//        [self setSearchControllerHidden:NO];
//        
//        
//    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
#warning ios6 and ios7 is different when setting button title
    self.mySearchDisplayController.searchBar.showsCancelButton = YES;
//    for(id cc in [searchBar subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"取消"  forState:UIControlStateNormal];
//        }
//    }
    DLog(@"should begin");
//    [self updateFilteredContentForName:@""];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.mySearchDisplayController.searchBar.text = @"";
    NSLog(@"did begin");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"did end");
    self.mySearchDisplayController.searchBar.showsCancelButton = NO;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search clicked");
}

//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancle clicked");
    self.mySearchDisplayController.searchBar.text = @"";
    [self.mySearchDisplayController.searchBar resignFirstResponder];
//    [self setSearchControllerHidden:YES];
}*/

#pragma mark- handle the notification
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
        MCContactsDetailViewController *detailViewController = segue.destinationViewController;
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
