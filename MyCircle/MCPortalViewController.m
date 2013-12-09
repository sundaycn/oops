//
//  MCPortalViewController.m
//  MyCircle
//
//  Created by Samuel on 11/25/13.
//
//

#import "MCPortalViewController.h"

@interface MCPortalViewController ()
@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSString *pageSize;
@end

@implementation MCPortalViewController

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
    self.pageSize = @"10";
    self.pageNo = 1;
    DLog(@"pageNo:%d", self.pageNo);
    self.arrPortal = [[NSMutableArray alloc] init];
    [self.arrPortal addObjectsFromArray:[[MCPortalDataHandler getPortalList:self.pageSize pageNo:[NSString stringWithFormat:@"%d", self.pageNo++]] copy]];

    //修改导航栏返回按钮的文字
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = barButtonItem;
    //缩进分割线
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
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
    return [self.arrPortal count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PortalCell";
    MCPortalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MCPortalCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    cell.labelTitle.text = [[self.arrPortal objectAtIndex:indexPath.row] objectForKey:@"companyName"];
    cell.labelDetail.text = [[self.arrPortal objectAtIndex:indexPath.row] objectForKey:@"officeAddress"];
    NSString *strURL = [[BASE_URL stringByAppendingString:[[self.arrPortal objectAtIndex:indexPath.row] objectForKey:@"image"]] stringByAppendingString:IMAGE_SWITCH];
    [cell.imageViewLogo setImageWithURL:[NSURL URLWithString:strURL]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    self.bookId = cell.bookId;
    DLog(@"did selected");
    self.id = [[self.arrPortal objectAtIndex:indexPath.row] objectForKey:@"id"];
    self.belongOrgId = [[self.arrPortal objectAtIndex:indexPath.row] objectForKey:@"belongOrgId"];
    [self performSegueWithIdentifier:@"showContents" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGPoint offset1 = scrollView.contentOffset;
//    CGRect bounds1 = scrollView.bounds;
//    CGSize size1 = scrollView.contentSize;
//    UIEdgeInsets inset1 = scrollView.contentInset;
//    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
//    float h1 = size1.height;
//    DLog(@"offset1.y:%f", offset1.y);
//    DLog(@"bounds1.size.height:%f", bounds1.size.height);
//    DLog(@"inset1.bottom:%f", inset1.bottom);
//    DLog(@"y1:%f", y1);
//    DLog(@"h1:%f", h1);
//    DLog(@"tableview.frame.size.height:%f", self.tableView.frame.size.height);
    
    DLog(@"tableview.contentOffset.y:%f", self.tableView.contentOffset.y);
    DLog(@"tableview.contentSize.height:%f", self.tableView.contentSize.height);
    DLog(@"tableview.bounds.size.height:%f", self.tableView.bounds.size.height);
    if(self.tableView.contentOffset.y<0)
    {
        //it means table view is pulled down like refresh
        DLog(@"hit top!");
        return;
    }
    else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        DLog(@"hit bottom!");
        DLog(@"pageNo:%d", self.pageNo);
        [self.arrPortal addObjectsFromArray:[MCPortalDataHandler getPortalList:self.pageSize pageNo:[NSString stringWithFormat:@"%d", self.pageNo++]]];
        [self.tableView reloadData];
    }
    
    
    
//    if (y1 > self.tableView.frame.size.height) {
//        isRefresh = NO;
//    }
//    else if (y1 < self.tableView.frame.size.height) {
//        isRefresh = YES;
//    }
//    else if (y1 == self.tableView.frame.size.height) {
//        DLog(@"%@", isRefresh ? @"上拉刷新" : @"下拉刷新");
//    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showContents"]) {
        MCContensViewController *contentsViewController = [segue destinationViewController];
        contentsViewController.id = self.id;
        contentsViewController.belongOrgId = self.belongOrgId;
    }
}

@end
