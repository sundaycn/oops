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
#import "MCConfig.h"
#import "MCChatSessionDAO.h"
#import "MCChatSession.h"
#import "MCChatHistoryDAO.h"
#import "MCMyInfoHandler.h"
#import "MCUtility.h"
//#import "MCBookBL.h"
    
@interface MCMainViewController ()

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
    
//    if (self.isFirstLogined) {
//        [self loginInXmppServer];
//    }
    
    //获取并保存用户信息
    self.strAccount = [[MCConfig sharedInstance] getAccount];
    NSString *cipherPwd = [[MCConfig sharedInstance] getCipherPassword];
    [[MCMyInfoHandler sharedInstance] getMyInfo:self.strAccount password:cipherPwd];
    
    
    //监听应用程序从后台切换到前台的动作
//    [defaultCenter addObserver:self
//                      selector:@selector(loginInXmppServer)
//                          name:UIApplicationDidBecomeActiveNotification
//                        object:nil];
    
    //监听应用程序从前台切换到后台的动作
//    [defaultCenter addObserver:self
//                      selector:@selector(loginOffXmppServer)
//                          name:UIApplicationWillResignActiveNotification
//                        object:nil];
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
            break;
        default:
            break;
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
