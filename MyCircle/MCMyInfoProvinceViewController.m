//
//  MCMyInfoProvinceViewController.m
//  MyCircle
//
//  Created by Samuel on 5/2/14.
//
//

#import "MCMyInfoProvinceViewController.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
//#import "MCProvinceDAO.h"
#import "MCMyInfoCityViewController.h"

@interface MCMyInfoProvinceViewController ()
@property (nonatomic, strong) NSArray *arrProvince;
@end

@implementation MCMyInfoProvinceViewController

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
    
//    self.arrProvince = [[MCProvinceDAO sharedManager] findAll];
//    if (self.arrProvince.count == 0) {
//        //第一次初始化地区－省数据
//        DLog(@"第一次初始化地区－省数据");
//        [self getProvinceData];
//    }
    
    NSString *strProvincePlistPath = [[NSBundle mainBundle] pathForResource:@"MyInfoRegionProvince" ofType:@"plist"];
    self.arrProvince = [[NSArray alloc] initWithContentsOfFile:strProvincePlistPath];
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
    return [self.arrProvince count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProvinceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell...
    cell.textLabel.text = [self.arrProvince[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showCity" sender:self];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showCity"]) {
        MCMyInfoCityViewController *cityVC = [segue destinationViewController];
        cityVC.pid = [self.arrProvince[[self.tableView indexPathForSelectedRow].row] objectForKey:@"pid"];
        cityVC.pName = [self.arrProvince[[self.tableView indexPathForSelectedRow].row] objectForKey:@"name"];
    }
}

/*
//第一次启动应用时从服务器获取省数据
- (void)getProvinceData
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
            
            DLog(@"province name :%@", province.name);
            
            [[MCProvinceDAO sharedManager] create:province];
        }

        self.arrProvince = [[MCProvinceDAO sharedManager] findAll];
        [self.tableView reloadData];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSString *strDetail = [error.localizedDescription stringByAppendingString:@"\n 请返回重新尝试"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取省数据失败" message:strDetail delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    //异步获取数据
    [request startAsynchronous];
}*/

@end