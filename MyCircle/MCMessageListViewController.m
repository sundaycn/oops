
//  MCMessageListViewController.m
//  MyCircle
//
//  Created by Samuel on 12/11/13.
//
//

#import "MCMessageListViewController.h"
#import "MCXmppHelper+Message.h"
#import "MCMessageCell.h"
#import "MCUtility.h"
#import "MCChatSessionViewController.h"
#import "MCNotificationSessionViewController.h"
#import "MCBookBL.h"
#import "MCConfig.h"

@interface MCMessageListViewController ()

@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) MCChatSessionViewController *chatSessionVC;
@property (nonatomic, strong) MCNotificationSessionViewController *notificationSessionVC;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MCMessageListViewController

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
    self.navigationItem.title = @"消息";
    self.tableView.separatorColor = UIColorFromRGB(0xd5d5d5);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
        //企业动态
        return 1;
    }
    else if (section == 1) {
        //通知公告
        return 1;
    }
    else {
        //聊天会话
        self.keys = [[[[MCXmppHelper sharedInstance] Messages] allKeys] mutableCopy];
        if(!self.keys) {
            return 0;
        }
        else {
            [self.keys removeObject:MSG_KEY_COMPANY_NEWS];
            [self.keys removeObject:MSG_KEY_ORG_NEWS];
            [self.keys removeObject:XMPP_ADMIN_JID];

            return self.keys.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier1 = @"ComanpyNewsCell";
        MCMessageCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell1 == nil) {
            cell1 = [[MCMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        
        cell1.imageViewAvatar.image = [UIImage imageNamed:@"CompanyNewsLogo"];
        cell1.imageViewIcon.image = [UIImage imageNamed:@"NotificationIcon"];
        cell1.labelName.text = @"企业动态";
        MCMessage *msg = [[[MCXmppHelper sharedInstance] Messages] objectForKey:MSG_KEY_COMPANY_NEWS];
        if (msg) {
            //消息前缀WOQUANQUAN_CB462135_MSG:
            NSRange rangeJsonMessage = [msg.message rangeOfString:@":"];
            NSString *strJsonMessage = [msg.message substringWithRange:NSMakeRange(rangeJsonMessage.location+1, msg.message.length-(rangeJsonMessage.location+1))];
            NSData *dataMessage = [strJsonMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:dataMessage options:NSJSONReadingAllowFragments error:nil];
            if ([[dictMessage objectForKey:@"msgType"] isEqualToString:MSG_TYPE_COMPANY_NEWS]) {
                cell1.labelTime.text = [MCUtility getMessageTime:msg.date];
                cell1.labelMessage.text = [dictMessage objectForKey:@"msgTitle"];
            }
        }
        else {
            cell1.labelMessage.text = @"暂时没有企业动态";
        }

        return cell1;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier2 = @"NotificationsCell";
        MCMessageCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell2 == nil) {
            cell2 = [[MCMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        
        cell2.imageViewAvatar.image = [UIImage imageNamed:@"NotificationLogo"];
        cell2.imageViewIcon.image = [UIImage imageNamed:@"NotificationIcon"];
        cell2.labelName.text = @"通知公告";
        MCMessage *msg = [[[MCXmppHelper sharedInstance] Messages] objectForKey:MSG_KEY_ORG_NEWS];
        if (msg) {
            //消息前缀WOQUANQUAN_CB462135_MSG:
            NSRange rangeJsonMessage = [msg.message rangeOfString:@":"];
            NSString *strJsonMessage = [msg.message substringWithRange:NSMakeRange(rangeJsonMessage.location+1, msg.message.length-(rangeJsonMessage.location+1))];
            NSData *dataMessage = [strJsonMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:dataMessage options:NSJSONReadingAllowFragments error:nil];
            if ([[dictMessage objectForKey:@"msgType"] isEqualToString:MSG_TYPE_ORG_NEWS]) {
                cell2.labelTime.text = [MCUtility getMessageTime:msg.date];
                cell2.labelMessage.text = [dictMessage objectForKey:@"msgTitle"];
            }
        }
        else {
            cell2.labelMessage.text = @"暂时没有通知公告";
        }
        
        return cell2;
    }
    else {
        static NSString *CellIdentifier = @"MsgListCell";
        MCMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MCMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        NSString *jid = [self.keys objectAtIndex:indexPath.row];
        MCMessage *msg = [[[MCXmppHelper sharedInstance] Messages] objectForKey:jid];
        NSString *mobilePhone;
        NSString *account = [[MCConfig sharedInstance] getAccount];
        if ([msg.from isEqualToString:[account stringByAppendingString:XMPP_DOMAIN]]) {
            NSRange separator = [msg.to rangeOfString:@"@"];
            mobilePhone = [msg.to substringWithRange:NSMakeRange(0, separator.location)];
        }
        else {
            NSRange separator = [msg.from rangeOfString:@"@"];
            mobilePhone = [msg.from substringWithRange:NSMakeRange(0, separator.location)];
        }
        
        cell.imageViewIcon.image = [UIImage imageNamed:@"MessageIcon"];
        MCBook *book = [[[MCBookBL alloc] init] findbyMobilePhone:mobilePhone];
        cell.labelName.text = book.name;
        DLog(@"MessageList msg.date:%@", msg.date);
        cell.labelTime.text = [MCUtility getMessageTime:msg.date];
        DLog(@"MessageList cell.lableTime.text:%@", cell.labelTime.text);
        cell.labelMessage.text = msg.message;
        
        return cell;
    }
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    if (indexPath.section != 2) {
        [self performSegueWithIdentifier:@"showNotificationSession" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"showChatSession" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 20.0f;
    }
    else {
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        view.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 19, tableView.frame.size.width, 0.5)];
        separator.backgroundColor = UIColorFromRGB(0xa8a8a8);
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 15)];
        labelTitle.font = [UIFont systemFontOfSize:12];
        labelTitle.textColor = UIColorFromRGB(0x8b8b8b);
        labelTitle.text = @"联系人消息";
        
        [view addSubview:separator];
        [view addSubview:labelTitle];
        
        return view;
    }
    else {
        return nil;
    }
}

//从会话列表删除会话
- (void)removeChatSession:(NSUInteger)index
{
    NSString *key = [self.keys objectAtIndex:index];
    [self.keys removeObjectAtIndex:index];
    [[MCXmppHelper sharedInstance] removeLastMessage:key];
    [[MCXmppHelper sharedInstance] removeLastMessageFromDB:key];
}

//滑动Cell时调用此函数
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
        return  UITableViewCellEditingStyleDelete;
    else
        return  UITableViewCellEditingStyleNone;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self removeChatSession:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showChatSession"])
    {
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
//                                                 initWithTitle:@"消息"
//                                                 style:UIBarButtonItemStylePlain
//                                                 target:nil
//                                                 action:nil];
        self.chatSessionVC = segue.destinationViewController;
//        self.chatSessionVC.jid = [self.keys objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        self.chatSessionVC.jid = [self.keys objectAtIndex:self.indexPath.row];
//        MCMessageCell *cell = (MCMessageCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        MCMessageCell *cell = (MCMessageCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
        DLog(@"cell name:%@", cell.labelName.text);
        self.chatSessionVC.buddyName = cell.labelName.text;
        self.chatSessionVC.msgType = MSG_TYPE_NORMAL_CHAT;
        MCXmppHelper *xmppHelper = [MCXmppHelper sharedInstance];
        xmppHelper.msgrev = self.chatSessionVC;
    }
    else if ([[segue identifier] isEqualToString:@"showNotificationSession"]) {
        self.notificationSessionVC = segue.destinationViewController;
        //msgType
//        MCMessageCell *cell = (MCMessageCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        MCMessageCell *cell = (MCMessageCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
        DLog(@"cell name:%@", cell.labelName.text);

        if ([cell.labelName.text isEqualToString:@"企业动态"]) {
            self.notificationSessionVC.msgType = MSG_TYPE_COMPANY_NEWS;
        }
        else if ([cell.labelName.text isEqualToString:@"通知公告"]) {
            self.notificationSessionVC.msgType = MSG_TYPE_ORG_NEWS;
        }
        MCXmppHelper *xmppHelper = [MCXmppHelper sharedInstance];
        xmppHelper.msgrev = self.notificationSessionVC;
    }
}

@end
