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
#import "MCChatSessionDAO.h"
#import "MCChatSession.h"
#import "MCChatHistoryDAO.h"
//#import "MCBookBL.h"

@interface MCMainViewController ()

@property (nonatomic, strong) MCXmppHelper *xmppHelper;
@property (nonatomic, strong) Reachability* reachability;

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
    //监听wifi/3g网络切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    //监听应用程序从后台切换到前台的动作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInXmppServer) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //监听应用程序从前台切换到后台的动作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOffXmppServer) name:UIApplicationWillResignActiveNotification object:nil];
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
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *isLogined = [self.xmppHelper login:userInfo success:^{
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
    if(cnt <= 0){
//        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        self.tabBarItem.badgeValue = nil;
    }else{
//        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
        
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
//        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        self.tabBarItem.badgeValue = nil;
    }else{
//        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
    }
}

@end
