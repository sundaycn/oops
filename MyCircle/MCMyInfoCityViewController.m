//
//  MCMyInfoCityViewController.m
//  MyCircle
//
//  Created by Samuel on 5/2/14.
//
//

#import "MCMyInfoCityViewController.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
//#import "MCCityDAO.h"
#import "MCMyInfoDAO.h"
#import "MCConfig.h"
#import "MCMyInfoViewController.h"

@interface MCMyInfoCityViewController ()
@property (nonatomic, strong) NSArray *arrCity;
@end

@implementation MCMyInfoCityViewController

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
    
    /*self.arrCity = [[MCCityDAO sharedManager] findByPid:self.pid];
    if (self.arrCity.count == 0) {
        //第一次初始化地区－市数据
        DLog(@"第一次初始化地区－市数据");
        [self getCityData];
    }*/
    
    NSString *strCityPlistPath = [[NSBundle mainBundle] pathForResource:@"MyInfoRegionCity" ofType:@"plist"];
    self.arrCity = [[[NSDictionary alloc] initWithContentsOfFile:strCityPlistPath] objectForKey:self.pid];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.arrCity count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.arrCity[indexPath.row] objectForKey:@"name"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCMyInfoViewController *myInfoVC = [self.navigationController.viewControllers objectAtIndex:1];
    int ret = [self postData:[self.arrCity[indexPath.row] objectForKey:@"id"] name:[self.arrCity[indexPath.row] objectForKey:@"name"]];
    if (ret == 0) {
        self.myInfoModifyDelegate = myInfoVC;
        NSString *regionName = [[self.pName stringByAppendingString:@" "] stringByAppendingString:[self.arrCity[indexPath.row] objectForKey:@"name"]];
        [self.myInfoModifyDelegate updateValueOfCell:regionName index:4];
    }
    
    [self.navigationController popToViewController:myInfoVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//提交修改值
- (int)postData:(NSString *)cid name:(NSString *)name
{
    //没修改不提交
//    if ([self.strName isEqualToString:self.textName.text]) {
//        return;
//    }
    
    BOOL provinceModified = NO;
    BOOL cityModified = NO;
    
    //获取账号和密码
    NSString *strAccount = [[MCConfig sharedInstance] getAccount];
    NSString *strPassword = [[MCConfig sharedInstance] getCipherPassword];
    
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!changeUserAttachInfoAjax.action"]];
    ASIFormDataRequest *requestProvince = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    //修改省
    NSString *strInfo = [[@"{\"provinceId\":\"" stringByAppendingString:self.pid] stringByAppendingString:@"\"}"];
    [requestProvince addPostValue:strAccount forKey:@"tel"];
    [requestProvince addPostValue:strPassword forKey:@"password"];
    [requestProvince addPostValue:strInfo forKey:@"info"];
    //同步请求
    [requestProvince startSynchronous];
    
    NSError *error = [requestProvince error];
    if (!error) {
        NSData *response  = [requestProvince responseData];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[[dictResponse objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isOK = [strResult isEqualToString:@"1"];
        if (isOK) {
            DLog(@"个人资料－省份修改成功");
            //保存到本地
            MCMyInfo *myInfo = [[MCMyInfoDAO sharedManager] findByAccount:strAccount];
            myInfo.provinceId = self.pid;
            myInfo.provinceName = self.pName;
            [[MCMyInfoDAO sharedManager] modify:myInfo];
            provinceModified = YES;
        }
        else {
            DLog(@"个人资料－省份修改失败");
        }
    }
    
    //修改城市
    ASIFormDataRequest *requestCity = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    strInfo = [[@"{\"cityId\":\"" stringByAppendingString:cid] stringByAppendingString:@"\"}"];
    [requestCity addPostValue:strAccount forKey:@"tel"];
    [requestCity addPostValue:strPassword forKey:@"password"];
    [requestCity addPostValue:strInfo forKey:@"info"];
    //同步请求
    [requestCity startSynchronous];
    
    error = [requestCity error];
    if (!error) {
        NSData *response  = [requestCity responseData];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[[dictResponse objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isOK = [strResult isEqualToString:@"1"];
        if (isOK) {
            DLog(@"个人资料－城市修改成功");
            //保存到本地
            MCMyInfo *myInfo = [[MCMyInfoDAO sharedManager] findByAccount:strAccount];
            myInfo.cityId = cid;
            myInfo.cityName = name;
            [[MCMyInfoDAO sharedManager] modify:myInfo];
            cityModified = YES;
        }
        else {
            DLog(@"个人资料－城市修改失败");
        }
    }
    
    //省市修改成功
    if (provinceModified && cityModified) {
        return 0;
    }
    
    return 1;
}

/*
//第一次启动应用时从服务器获取市数据
- (void)getCityData
{
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!queryCityAjax.action"]];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:self.pid forKey:@"provinceId"];
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
        [[MCCityDAO sharedManager] create:arrRoot pid:self.pid];
        
        self.arrCity = [[MCCityDAO sharedManager] findByPid:self.pid];
        [self.tableView reloadData];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSString *strDetail = [error.localizedDescription stringByAppendingString:@"\n 请返回重新尝试"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取市数据失败" message:strDetail delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    //异步获取数据
    [request startAsynchronous];
}*/

@end
