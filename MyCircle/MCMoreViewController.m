//
//  MCMoreViewController.m
//  MyCircle
//
//  Created by Samuel on 1/16/14.
//
//

#import "MCMoreViewController.h"
#import "MCMoreCell.h"

@interface MCMoreViewController ()

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
    self.tableView.backgroundColor = UIColorFromRGB(0xd8d8d8);
    self.tableView.separatorColor = UIColorFromRGB(0xd8d8d8);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 1;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreCell";
    MCMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MCMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.opaque = YES;
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //
        }
        else {
            UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 100, 16)];
            labelInfo.text = @"个人资料";
            [cell.contentView addSubview:labelInfo];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 100, 16)];
        labelInfo.text = @"关于我圈圈";
        [cell.contentView addSubview:labelInfo];
        return cell;
    }
    else {
        cell.backgroundColor = UIColorFromRGB(0xe7342d);
        UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 130, 20)];
        labelText.font = [UIFont systemFontOfSize:20];
        labelText.textColor = [UIColor whiteColor];
        labelText.text = @"退出当前账号";
        [cell.contentView addSubview:labelText];
        return cell;
    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xd8d8d8);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"showMyInfo" sender:self];
        }
    }
    else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"showAbout" sender:self];
    }
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

@end
