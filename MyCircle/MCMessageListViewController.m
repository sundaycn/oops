
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

@interface MCMessageListViewController ()

@property (nonatomic, strong) NSUserDefaults *userInfo;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) MCChatSessionViewController *chatSessionVC;
@property (nonatomic, strong) MCNotificationSessionViewController *notificationSessionVC;

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
        self.keys = [[[[MCXmppHelper sharedInstance] Messages] allKeys] mutableCopy];
        if(!self.keys){
            return 0;
        }
        else{
            for (NSString *key in self.keys) {
                if ([key isEqualToString:XMPP_ADMIN_JID]) {
                    [self.keys removeObject:key];
                    break;
                }
            }

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

        cell1.labelName.text = @"企业动态";
        MCMessage *msg = [[[MCXmppHelper sharedInstance] Messages] objectForKey:XMPP_ADMIN_JID];
        if (msg) {
            //消息前缀WOQUANQUAN_CB462135_MSG:
            NSRange rangeJsonMessage = [msg.message rangeOfString:@":"];
            NSString *strJsonMessage = [msg.message substringWithRange:NSMakeRange(rangeJsonMessage.location+1, msg.message.length-(rangeJsonMessage.location+1))];
            NSData *dataMessage = [strJsonMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:dataMessage options:NSJSONReadingAllowFragments error:nil];
            
            cell1.labelTime.text = [MCUtility getmessageTime:msg.date];
            cell1.labelMessage.text = [dictMessage objectForKey:@"msgTitle"];
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
        self.chatSessionVC = segue.destinationViewController;
        self.chatSessionVC.jid = [self.keys objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        MCMessageCell *cell = (MCMessageCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        self.chatSessionVC.sessionTittle = cell.labelName.text;
        self.chatSessionVC.msgType = MSG_TYPE_NORMAL_CHAT;
        MCXmppHelper *xmppHelper = [MCXmppHelper sharedInstance];
        xmppHelper.msgrev = self.chatSessionVC;
    }
    else if ([[segue identifier] isEqualToString:@"showNotificationSession"]) {
        self.notificationSessionVC = segue.destinationViewController;
        //msgType
        MCMessageCell *cell = (MCMessageCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        if ([cell.labelName.text isEqualToString:@"企业动态"]) {
            self.notificationSessionVC.msgType = MSG_TYPE_COMPANY_NEWS;
        }
        MCXmppHelper *xmppHelper = [MCXmppHelper sharedInstance];
        xmppHelper.msgrev = self.notificationSessionVC;
    }
}

@end
