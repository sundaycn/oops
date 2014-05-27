//
//  MCMicroManagerAccountVC.m
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import "MCMicroManagerAccountVC.h"
#import "MCMicroManagerConfigHandler.h"
#import "MCConfig.h"
#import "MCMicroManagerAccountDAO.h"

@interface MCMicroManagerAccountVC ()
@property (nonatomic, strong) NSArray *arrMMUsers;
@end

@implementation MCMicroManagerAccountVC
{
    NSInteger indexOfCheckedBefore;
    NSInteger indexOfCheckedAfter;
}

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
    MCMicroManagerConfigHandler *mmConfighandler = [MCMicroManagerConfigHandler sharedInstance];
    mmConfighandler.delegate = self;
    //下载当前用户所有微管理账号
    MCMicroManagerAccount *defaultMMAccount = [[MCMicroManagerAccountDAO sharedManager] queryDefaultAccount];
    [[MCMicroManagerAccountDAO sharedManager] deleteAll];
    NSString *strAccount = [[MCConfig sharedInstance] getAccount];
    [mmConfighandler getMMAccountByAccount:strAccount defaultMMAccount:defaultMMAccount];
    //初始化数据源
    self.arrMMUsers = [[NSArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (indexOfCheckedBefore == indexOfCheckedAfter) {
        return;
    }
    MCMicroManagerAccount *mmAccount = self.arrMMUsers[indexOfCheckedBefore];
    mmAccount.isChecked = NO;
    [[MCMicroManagerAccountDAO sharedManager] update:mmAccount];
    mmAccount = self.arrMMUsers[indexOfCheckedAfter];
    mmAccount.isChecked = YES;
    [[MCMicroManagerAccountDAO sharedManager] update:mmAccount];
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
    return [self.arrMMUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MMUsersCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell...
    if (self.arrMMUsers) {
        MCMicroManagerAccount *mmAccount = self.arrMMUsers[indexPath.row];
        cell.textLabel.text = mmAccount.userCode;
        cell.detailTextLabel.text = mmAccount.orgName;
        if (mmAccount.isChecked) {
            indexOfCheckedBefore = indexPath.row;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexOfCheckedAfter = indexPath.row;
    if (indexOfCheckedBefore == indexOfCheckedAfter) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    NSIndexPath *indexPathBefore = [NSIndexPath indexPathForItem:indexOfCheckedBefore inSection:0];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPathBefore];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - MCMicroManager Delegate
- (void)didFinishGetMicroManagerAccount:(MCMicroManagerAccount *)mmAccount
{
    self.arrMMUsers = [[MCMicroManagerAccountDAO sharedManager] queryAll];
    [self.tableView reloadData];
}
@end
