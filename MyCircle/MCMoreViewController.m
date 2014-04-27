//
//  MCMoreViewController.m
//  MyCircle
//
//  Created by Samuel on 1/16/14.
//
//

#import "MCMoreViewController.h"
#import "MCSettingModel.h"
#import "MCUtility.h"
#import "MCLoginOffHandler.h"
#import "MCMoreAccountCell.h"
#import "MCConfig.h"
#import "MCMyInfoDAO.h"

@interface MCMoreViewController ()
@property (strong, nonatomic) NSMutableDictionary *dictSettingsInSection;
@property (strong, nonatomic) NSArray *arrSettings;
@property (strong, nonatomic) NSString *strNewVersionUrl;
@property (strong, nonatomic) MCMyInfo *myInfo;
@end

@implementation MCMoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = UIColorFromRGB(0xd5d5d5);
    self.tableView.separatorColor = UIColorFromRGB(0xd5d5d5);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    
    //获取用户姓名
    NSString *strAccount = [[MCConfig sharedInstance] getAccount];
    self.myInfo = [[MCMyInfoDAO sharedManager] findByAccount:strAccount];
    
    //配置数据源
    self.dictSettingsInSection = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSArray *first = [[NSArray alloc] initWithObjects:
                      [[MCSettingModel alloc] initWithTitle:self.myInfo.userName image:@"ContactsDefaultAvatar" tag:1 title2:@"微管理账号："],
                      nil];
    NSArray *second = [[NSArray alloc] initWithObjects:
                       [[MCSettingModel alloc] initWithTitle:@"微管理" image:@"AppCenterIcon" tag:3 title2:nil],
                       [[MCSettingModel alloc] initWithTitle:@"搜周边" image:@"SearchNearbyIcon" tag:4 title2:nil],
                       [[MCSettingModel alloc] initWithTitle:@"检查更新" image:@"CheckAndUpdateIcon" tag:5 title2:nil],
                       [[MCSettingModel alloc] initWithTitle:@"关于三微客" image:@"AboutIcon" tag:6 title2:nil],
                       nil];
    NSArray *third = [[NSArray alloc] initWithObjects:
                      [[MCSettingModel alloc] initWithTitle:nil image:@"" tag:7 title2:nil],
                      nil];
    [self.dictSettingsInSection setObject:first forKey:@"firstSection"];
    [self.dictSettingsInSection setObject:second forKey:@"secondSection"];
    [self.dictSettingsInSection setObject:third forKey:@"thirdSection"];
    self.arrSettings = [[NSArray alloc] initWithObjects:@"firstSection",@"secondSection",@"thirdSection",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.arrSettings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionKey = [self.arrSettings objectAtIndex:section];
    
    return [[self.dictSettingsInSection objectForKey:sectionKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSString *sectionKey = [self.arrSettings objectAtIndex:indexPath.section];
    NSArray *arrData = [self.dictSettingsInSection objectForKey:sectionKey];
    MCSettingModel *model = [arrData objectAtIndex:indexPath.row];
    if (model.tag == 1) {
        static NSString *CellIdentifier = @"MoreAccountCell";
        MCMoreAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MCMoreAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.labelName.text = model.title;
        cell.labelDetail.text = model.title2;
        cell.imageViewAvatar.image = [UIImage imageWithData:self.myInfo.avatarImage];
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"MoreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (model.tag == 7) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.contentView.backgroundColor = UIColorFromRGB(0xd5d5d5);
            UIButton *buttonLogOff = [[UIButton alloc] initWithFrame:CGRectMake(15, 2, 290, 40)];
            [buttonLogOff setBackgroundImage:[UIImage imageNamed:@"LogOffButtonNormalImage"] forState:UIControlStateNormal];
            [buttonLogOff setBackgroundImage:[UIImage imageNamed:@"LogOffButtonSelectedImage"] forState:UIControlStateHighlighted];
            [buttonLogOff addTarget:self action:@selector(loginOff) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:buttonLogOff];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:model.image];
            cell.textLabel.text = model.title;
        }
        
        return cell;
    }
    
//    cell.tag = model.tag;
    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            //
//        }
//        else {
//            UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 100, 16)];
//            labelInfo.text = @"个人资料";
//            [cell.contentView addSubview:labelInfo];
//        }
//        return cell;
//    }
//    else if (indexPath.section == 1) {
//        UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 100, 16)];
//        labelInfo.text = @"关于我圈圈";
//        [cell.contentView addSubview:labelInfo];
//        return cell;
//    }
//    else {
//        cell.backgroundColor = UIColorFromRGB(0xe7342d);
//        UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 130, 20)];
//        labelText.font = [UIFont systemFontOfSize:20];
//        labelText.textColor = [UIColor whiteColor];
//        labelText.text = @"退出当前账号";
//        [cell.contentView addSubview:labelText];
//        return cell;
//    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }
    }
    
    return 44;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = UIColorFromRGB(0xd8d8d8);
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [self.arrSettings objectAtIndex:indexPath.section];
    NSArray *arrData = [self.dictSettingsInSection objectForKey:sectionKey];
    MCSettingModel *model = [arrData objectAtIndex:indexPath.row];
    
    switch (model.tag) {
        case 1:
            [self performSegueWithIdentifier:@"showMyInfo" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"showMicroManager" sender:self];
            break;
        case 4:
//            [self performSegueWithIdentifier:@"showSearchNearby" sender:self];
            break;
        case 5:
            [self checkAndUpdateVersion];
            break;
        case 6:
            [self performSegueWithIdentifier:@"showAbout" sender:self];
            break;
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAbout"]) {
        //
    }
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//检查更新
- (void)checkAndUpdateVersion
{
    self.strNewVersionUrl = [MCUtility checkAndUpdateVersion];
    DLog(@"新版本下载地址:%@", self.strNewVersionUrl);
    if (self.strNewVersionUrl) {
        //pop alert dialog
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:@"如需下载更新请点击确定按钮" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        //optional - add more buttons:
        [alert addButtonWithTitle:@"确定"];
        alert.tag = 1;
        [alert show];
    }
    else {
        //pop alert dialog
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有检测到新版本" message:@"当前版本已经是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
    }
}

//退出登陆
- (void)loginOff
{
    //清除相关数据
    [MCLoginOffHandler prepareForLoginOff];
    //返回loginView
    [self performSegueWithIdentifier:@"showLoginView" sender:self];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-services://?action=download-manifest&url=" stringByAppendingString:self.strNewVersionUrl]]];
        }
    }
}

@end
