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

@interface MCMoreViewController ()
@property(strong, nonatomic) NSMutableDictionary *dictSettingsInSection;
@property(strong, nonatomic) NSArray *arrSettings;
@property(strong, nonatomic) NSString *strNewVersionUrl;
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
    
    //配置数据源
    self.dictSettingsInSection = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSArray *first = [[NSArray alloc] initWithObjects:
                      [[MCSettingModel alloc] initWithTitle: @"个人资料" image:@"AccountIcon" tag:1 title2:nil],
                      nil];
    NSArray *second = [[NSArray alloc] initWithObjects:
                       [[MCSettingModel alloc] initWithTitle:@"应用中心" image:@"AppCenterIcon" tag:2 title2:nil],
                       [[MCSettingModel alloc] initWithTitle:@"检查更新" image:@"CheckAndUpdateIcon" tag:3 title2:nil],
                       [[MCSettingModel alloc] initWithTitle:@"关于我圈圈" image:@"AboutIcon" tag:4 title2:nil],
                       nil];
    NSArray *third = [[NSArray alloc] initWithObjects:
                      [[MCSettingModel alloc] initWithTitle:nil image:@"" tag:5 title2:nil],
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
    static NSString *CellIdentifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    NSString *sectionKey = [self.arrSettings objectAtIndex:indexPath.section];
    NSArray *arrData = [self.dictSettingsInSection objectForKey:sectionKey];
    MCSettingModel *model = [arrData objectAtIndex:indexPath.row];
    if (model.tag == 5) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentView.backgroundColor = UIColorFromRGB(0xd5d5d5);
        UIButton *buttonLogOff = [[UIButton alloc] initWithFrame:CGRectMake(15, 2, 290, 40)];
        [buttonLogOff setBackgroundImage:[UIImage imageNamed:@"LogOffButtonNormalImage"] forState:UIControlStateNormal];
        [buttonLogOff setBackgroundImage:[UIImage imageNamed:@"LogOffButtonSelectedImage"] forState:UIControlStateHighlighted];
        [cell.contentView addSubview:buttonLogOff];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:model.image];
        cell.textLabel.text = model.title;
    }
    cell.tag = model.tag;
    
    return cell;
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
            [self checkAndUpdateVersion];
            break;
        case 4:
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

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-services://?action=download-manifest&url=" stringByAppendingString:self.strNewVersionUrl]]];
        }
    }
}

@end
