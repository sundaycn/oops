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
}

- (void)loadRecord
{
    //1.加载消息记录
    //2.修改未读记录为已读
    //3.重设计数器
    NSArray *arrRecentMessage = [[MCChatHistoryDAO sharedManager] findRecentMessageByJid:XMPP_ADMIN_JID myJid:myJid];
    if (arrRecentMessage.count < 10) {
        refreshControlVisable = NO;
    }
    else {
        refreshControlVisable = YES;
    }
    for (MCChatHistory *obj in arrRecentMessage)
    {
        NSBubbleData *data;
        if ([obj.from isEqualToString:self.jid]) {
            data = [NSBubbleData dataWithText:obj.message date:obj.time type:BubbleTypeSomeoneElse];
        }
        else
        {
            data = [NSBubbleData dataWithText:obj.message date:obj.time type:BubbleTypeMine];
        }
        [self.bubbleData addObject:data];
    }
    //保存已展示的第一条记录的时间，便于获取更多历史记录
    if (!timeOfFirstMessage) {
        timeOfFirstMessage = [[arrRecentMessage lastObject] time];
    }
    
    [[MCChatHistoryDAO sharedManager] updateByJid:self.jid];
    [self resetUnreadBadge];
    [self.bubbleTableView reloadData];
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
        //消息前缀WOQUANQUAN_CB462135_MSG:
        NSRange rangeJsonMessage = [msg.message rangeOfString:@":"];
        NSString *strJsonMessage = [msg.message substringWithRange:NSMakeRange(rangeJsonMessage.location+1, msg.message.length-(rangeJsonMessage.location+1))];
        DLog(@"来自ADMIN的通知消息体\n %@", strJsonMessage);
        NSData *dataMessage = [strJsonMessage dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:dataMessage options:NSJSONReadingAllowFragments error:nil];
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
        //根据jid和msgType更新消息未读标识
        [[MCChatHistoryDAO sharedManager] updateByJid:XMPP_ADMIN_JID];
    }
}

- (NSDictionary *)requestNotificationDetail:(NSString *)mobilePhone msgType:(NSString *)msgType msgId:(NSString *)msgId
{
    NSString *strURL = [BASE_URL stringByAppendingString:@"SystemPhoneMessage/systemphonemessage!queryMessageDetailsAjaxp.action?"];
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

@end
