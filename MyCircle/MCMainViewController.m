//
//  MCMainViewController.m
//  MyCircle
//
//  Created by Samuel on 12/23/13.
//
//

#import "MCMainViewController.h"
#import <Reachability/Reachability.h>
#import "MCMessageListViewController.h"
#import "MCXmppHelper+Login.h"
#import "MCXmppHelper+Message.h"
#import "MCConfig.h"
#import "MCChatSessionDAO.h"
#import "MCChatSession.h"
#import "MCChatHistoryDAO.h"
#import "MCMyInfoHandler.h"
#import "MCUtility.h"
//#import "MCBookBL.h"
    
@interface MCMainViewController ()

@property (nonatomic, strong) MCXmppHelper *xmppHelper;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, copy) NSString *strAccount;
@property (nonatomic, copy) NSString *strNewVersionUrl;

@end

@implementation MCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //监听wifi/3g网络切换
    [defaultCenter addObserver:self
                      selector:@selector(reachabilityChanged:)
                          name:kReachabilityChangedNotification
                        object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    if (self.isFirstLogined) {
        [self loginInXmppServer];
    }
    
    //获取并保存用户信息
    self.strAccount = [[MCConfig sharedInstance] getAccount];
    NSString *cipherPwd = [[MCConfig sharedInstance] getCipherPassword];
    [[MCMyInfoHandler sharedInstance] getMyInfo:self.strAccount password:cipherPwd];
    
    
    //监听应用程序从后台切换到前台的动作
    [defaultCenter addObserver:self
                      selector:@selector(loginInXmppServer)
                          name:UIApplicationDidBecomeActiveNotification
                        object:nil];
    
    //监听应用程序从前台切换到后台的动作
    [defaultCenter addObserver:self
                      selector:@selector(loginOffXmppServer)
                          name:UIApplicationWillResignActiveNotification
                        object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    //暂时取消版本检查功能
    //[self checkAndUpdateVersion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    switch (remoteHostStatus) {
        case NotReachable:
            DLog(@"not reachable");
            break;
        case ReachableViaWiFi:
            DLog(@"wifi reachable");
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

- (void)loginInXmppServer
{
    //登陆Xmpp服务器
    self.xmppHelper = [MCXmppHelper sharedInstance];
    
    NSString *strPassword = [[MCConfig sharedInstance] getPlainPassword];
    [self.xmppHelper loginByAccount:self.strAccount password:strPassword success:^{
        //登陆成功
        DLog(@"login in xmpp server successfully");
        //更新最近一条消息和未读消息数
        self.xmppHelper.msgcount = self;
        //获取聊天会话并显示
        [self fetchChatSession];
    } fail:^(NSError *err) {
        //登陆失败
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息中心连接失败" message:err.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
}

- (void)loginOffXmppServer
{
    //登出Xmpp服务器
    [self.xmppHelper disconnect];
    DLog(@"login off xmpp server successfully");
}

- (void)resetMsgCount
{
    NSInteger cnt = [[MCChatHistoryDAO sharedManager] fetchUnReadMsgCount];
    if(cnt <= 0) {
        UIViewController *tabBarVC = [self.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = nil;
    }else {
        UIViewController *tabBarVC = [self.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
        
    }
    MCMessageListViewController *messageListVC = [[[self.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
    [messageListVC.tableView reloadData];
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
    MCMessageListViewController *messageListVC = [[[self.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
    [messageListVC.tableView reloadData];
    
    NSInteger cnt = [[MCChatHistoryDAO sharedManager] fetchUnReadMsgCount];
    if(cnt <= 0){
        UIViewController *tabBarVC = [self.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = nil;
    }else{
        UIViewController *tabBarVC = [self.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
    }
}

//检查更新
- (void)checkAndUpdateVersion
{
    self.strNewVersionUrl = [MCUtility checkAndUpdateVersion];
    DLog(@"新版本下载地址:%@", self.strNewVersionUrl);
    if (self.strNewVersionUrl) {
        //pop alert dialog
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:@"如需下载更新请点击确定按钮" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        //optional - add more buttons:
        [alert addButtonWithTitle:@"确定"];
        alert.tag = 1;
        [alert show];
    }
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-services://?action=download-manifest&url=" stringByAppendingString:self.strNewVersionUrl]]];
        }
    }
}

@end
