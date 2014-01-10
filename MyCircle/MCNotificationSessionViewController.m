//
//  MCNotificationSessionViewController.m
//  MyCircle
//
//  Created by Samuel on 1/8/14.
//
//

#import "MCNotificationSessionViewController.h"
#import "MCNotificationCell.h"
#import "MCChatHistoryDAO.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "MCXmppHelper+Message.m"

@interface MCNotificationSessionViewController ()
@property (strong, nonatomic) NSMutableArray *arrNotification;
@end

@implementation MCNotificationSessionViewController

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
    self.tableView.backgroundColor = UIColorFromRGB(0xF7F7F7);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //为数据源分配空间
    self.arrNotification = [[NSMutableArray alloc] init];
    
    //加载消息记录
    myJid = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] bare];
    timeOfFirstMessage = nil;
    [self loadRecord];
    
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉查看历史记录"];
    //    self.refreshControl.tag = 99;
    [self.refreshControl addTarget:self
                            action:@selector(refreshTableView)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self.refreshControl endRefreshing];
}

- (void)loadRecord
{
    //加载消息记录
    NSArray *arrRecentMessage = [[MCChatHistoryDAO sharedManager] findRecentMessageByType:self.msgType jid:XMPP_ADMIN_JID myJid:myJid];
    if (arrRecentMessage.count < 10) {
        refreshControlVisable = NO;
    }
    else {
        refreshControlVisable = YES;
    }
    MCChatHistory *obj;
    NSEnumerator *enumer = [arrRecentMessage reverseObjectEnumerator];
    while (obj = [enumer nextObject]) {
        NSDictionary *dictMessage = [self getJsonFromMessage:obj.message];
        //向服务器请求通知详情
        NSDictionary *dictDetail = [self requestNotificationDetail:[dictMessage objectForKey:@"toPhone"] msgType:[dictMessage objectForKey:@"msgType"] msgId:[dictMessage objectForKey:@"msgId"]];
        NSDictionary *dictBody = [[dictDetail objectForKey:@"message"] lastObject];
        [self.arrNotification addObject:dictBody];

    }
    //保存已展示的第一条记录的时间，便于获取更多历史记录
    if (!timeOfFirstMessage) {
        timeOfFirstMessage = [[arrRecentMessage lastObject] time];
    }
    //修改未读记录为已读
    [[MCChatHistoryDAO sharedManager] updateByJid:XMPP_ADMIN_JID];
    //重设计数器
    [self resetUnreadBadge];
    //刷新表视图并滚动到最新记录处
    [self.tableView reloadData];
//    [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX) animated:YES];
    [self scrollTableToFoot:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self resetUnreadBadge];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.arrNotification.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    MCNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MCNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *dictBody = [self.arrNotification objectAtIndex:indexPath.row];
    cell.labelTitle.text = [dictBody objectForKey:@"msgTitle"];
    cell.textView.text = [dictBody objectForKey:@"msgDescription"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)refreshmsg:(MCMessage *)msg
{
    if([msg.from isEqualToString:XMPP_ADMIN_JID])
    {
        //获取admin消息中的msgId,msgType,toPhone
        NSDictionary *dictMessage = [self getJsonFromMessage:msg.message];
        //向服务器请求通知详情
        NSDictionary *dictDetail = [self requestNotificationDetail:[dictMessage objectForKey:@"toPhone"] msgType:[dictMessage objectForKey:@"msgType"] msgId:[dictMessage objectForKey:@"msgId"]];
        if (!dictDetail) {
            return;
        }
        //解析msgCreateDate,msgDescription,mstTitle,msgType,msgUrl
        //追加数据
        NSDictionary *dictBody = [[dictDetail objectForKey:@"message"] lastObject];
        [self.arrNotification addObject:dictBody];
        [self.tableView reloadData];
        [self scrollToBottom];
        //根据jid和msgType更新消息未读标识
        [[MCChatHistoryDAO sharedManager] updateByJid:XMPP_ADMIN_JID];
    }
}

- (NSDictionary *)getJsonFromMessage:(NSString *)strMessage
{
    //消息前缀WOQUANQUAN_CB462135_MSG:
    NSRange rangeJsonMessage = [strMessage rangeOfString:@":"];
    NSString *strJsonMessage = [strMessage substringWithRange:NSMakeRange(rangeJsonMessage.location+1, strMessage.length-(rangeJsonMessage.location+1))];
    NSData *dataMessage = [strJsonMessage dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:dataMessage options:NSJSONReadingAllowFragments error:nil];
    return dictMessage;
}

- (NSDictionary *)requestNotificationDetail:(NSString *)mobilePhone msgType:(NSString *)msgType msgId:(NSString *)msgId
{
    NSString *strURL = [BASE_URL stringByAppendingString:@"SystemPhoneMessage/systemphonemessage!queryMessageDetailsAjaxp.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:mobilePhone forKey:@"mobilePhone"];
    [request addPostValue:msgType forKey:@"msgType"];
    [request addPostValue:msgId forKey:@"msgId"];

    //同步请求
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        NSDictionary *dictDetail = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        return dictDetail;
    }
    else {
        DLog(@"\n 请求通知公告详情发生错误\n %@", error);
        return nil;
    }
}

- (void)resetUnreadBadge
{
    NSInteger cnt = [[MCChatHistoryDAO sharedManager] fetchUnReadMsgCount];
    if(cnt <= 0){
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = nil;
    }else{
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
    }
}

- (void)refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在加载..."];
        //加载更多数据
        NSArray *arrEarlyMessage = [[MCChatHistoryDAO sharedManager] findSomeMessageByType:self.msgType time:timeOfFirstMessage jid:XMPP_ADMIN_JID myJid:myJid];
        if (arrEarlyMessage.count < 10) {
            refreshControlVisable = NO;
        }
        for (MCChatHistory *obj in arrEarlyMessage)
        {
            NSDictionary *dictMessage = [self getJsonFromMessage:obj.message];
            //向服务器请求通知详情
            NSDictionary *dictDetail = [self requestNotificationDetail:[dictMessage objectForKey:@"toPhone"] msgType:[dictMessage objectForKey:@"msgType"] msgId:[dictMessage objectForKey:@"msgId"]];
            NSDictionary *dictBody = [[dictDetail objectForKey:@"message"] lastObject];
            [self.arrNotification addObject:dictBody];
        }
        //保存已展示的第一条记录的时间
        timeOfFirstMessage = [[arrEarlyMessage lastObject] time];
        //回调方法
        [self performSelector:@selector(callBackMethod:) withObject:nil];
    }
}

- (void)callBackMethod:(id)obj
{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉查看历史记录"];
    if (!refreshControlVisable) {
        //没有更多记录则移除refreshControl
        for (id subview in self.tableView.subviews) {
            if ([subview isKindOfClass:[UIRefreshControl class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)scrollToBottom
{
    /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRowIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];*/
//    CGPoint bottomOffset = CGFLOAT_MAX;
    CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height-self.tableView.bounds.size.height);
    [self.tableView setContentOffset:bottomOffset animated:YES];
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];
    if (s < 1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r < 1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

@end
