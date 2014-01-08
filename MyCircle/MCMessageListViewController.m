
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
#import "MCBookBL.h"

@interface MCMessageListViewController ()

@property (nonatomic, strong) NSUserDefaults *userInfo;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) MCChatSessionViewController *destview;

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
    self.userInfo = [NSUserDefaults standardUserDefaults];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        //企业动态
        return 1;
    }
    else {
        //聊天会话
        self.keys = [[[[MCXmppHelper sharedInstance] Messages] allKeys] copy];
        if(!self.keys){
            return 0;
        }
        else{
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
        
        MCMessage *msg = [[[MCXmppHelper sharedInstance] Messages] objectForKey:XMPP_ADMIN_JID];
        
        cell1.labelName.text = @"企业动态";
        if (msg) {
            NSData *dataMessage = [msg.message dataUsingEncoding:NSUTF8StringEncoding];
            DLog(@"dataMessage:%@", dataMessage);
            id arrMessage = [NSJSONSerialization JSONObjectWithData:dataMessage options:NSJSONReadingMutableContainers error:nil];
            if ([arrMessage isKindOfClass:[NSArray class]]) {
                DLog(@"it's array!");
            }
            else if ([arrMessage isKindOfClass:[NSDictionary class]]) {
                DLog(@"it's dictionary");
            }
            else {
                DLog(@"others!");
            }
            DLog(@"dictMessage all:%@", arrMessage);
            cell1.labelTime.text = [MCUtility getmessageTime:msg.date];
            cell1.labelMessage.text = [arrMessage lastObject];
            
            //从最近消息组中移除admin
//            [self.keys removeObject:XMPP_ADMIN_JID];
            DLog(@"dicMessage:%@", [arrMessage lastObject]);
        }

        return cell1;
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
        
        if ([msg.from isEqualToString:XMPP_ADMIN_JID]) {
            NSData *dataMessage = [msg.message dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:dataMessage options:NSJSONReadingAllowFragments error:nil];
            cell.labelName.text = @"企业动态";
            cell.labelTime.text = [MCUtility getmessageTime:msg.date];
            cell.labelMessage.text = [[[dictMessage objectForKey:@"message"] lastObject] objectForKey:@"msgTitle"];
        }
        
        NSString *mobilePhone;
        if ([msg.from isEqualToString:[[self.userInfo stringForKey:@"user"] stringByAppendingString:@"@127.0.0.1"]]) {
            NSRange separator = [msg.to rangeOfString:@"@"];
            mobilePhone = [msg.to substringWithRange:NSMakeRange(0, separator.location)];
        }
        else {
            NSRange separator = [msg.from rangeOfString:@"@"];
            mobilePhone = [msg.from substringWithRange:NSMakeRange(0, separator.location)];
        }
        
        MCBook *book = [[[MCBookBL alloc] init] findbyMobilePhone:mobilePhone];
        cell.labelName.text = book.name;
        cell.labelTime.text = [MCUtility getmessageTime:msg.date];
        cell.labelMessage.text = msg.message;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"showNotificationSession" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"showChatSession" sender:self];
    }
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showChatSession"])
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"消息"
                                                 style:UIBarButtonItemStylePlain
                                                 target:nil
                                                 action:nil];
        self.destview = segue.destinationViewController;
        self.destview.jid = [self.keys objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        MCMessageCell *cell = (MCMessageCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        self.destview.sessionTittle = cell.labelName.text;
        MCXmppHelper *xmppHelper = [MCXmppHelper sharedInstance];
        xmppHelper.msgrev = self.destview;
    }
}
/*
- (void)reachabilityChanged:(NSNotification *)notification
{
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    switch (remoteHostStatus) {
        case NotReachable:
            DLog(@"not reachable");
            break;
        case ReachableViaWiFi:
            DLog(@"wifi reachable");
//            break;
        case ReachableViaWWAN:
            DLog(@"3g reachable");
            //断开XMPP连接并重新连接
            [self.xmppHelper disconnect];
            [self.xmppHelper.xmppReconnect manualStart];
            break;
        default:
            break;
    }
}

- (void)connectXmppServer
{
    //登陆Xmpp服务器
    self.xmppHelper = [MCXmppHelper sharedInstance];
    self.userInfo = [NSUserDefaults standardUserDefaults];
    NSString *isLogined = [self.xmppHelper login:self.userInfo success:^{
        //登陆成功
        DLog(@"login successfully");
        //更新最近一条消息和未读消息数
        self.xmppHelper.msgcount = self;
        //获取聊天会话并显示
        [self fetchChatSession];
    } fail:^(NSError *err) {
        //登陆失败
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
}

- (void)resetMsgCount
{
    NSInteger cnt = [[MCChatHistoryDAO sharedManager] fetchUnReadMsgCount];
    if(cnt <= 0){
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = nil;
    }else{
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
        
    }
    [self.tableView reloadData];
}

- (void)fetchChatSession{
    NSArray *chatSession = [[MCChatSessionDAO sharedManager] findAll];
    for (MCChatSession *obj in chatSession) {
        MCXmppHelper *helper =[MCXmppHelper sharedInstance];
        if(helper.Messages == nil){
            helper.Messages = [[NSMutableDictionary alloc] init];
        }
        MCMessage *msg = [[MCMessage alloc] init];
        msg.from = obj.key;
        msg.to = nil;
        msg.message = obj.lastmsg;
        msg.date = obj.time;
        [helper.Messages setObject:msg forKey:obj.key];
    }
    [self.tableView reloadData];
    
    NSInteger cnt = [[MCChatHistoryDAO sharedManager] fetchUnReadMsgCount];
    if(cnt <= 0){
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = nil;
    }else{
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
    }
}*/

@end
