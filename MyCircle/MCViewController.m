//
//  MCViewController.m
//  MyCircle
//
//  Created by Samuel on 10/1/13.
//
//

#import "MCViewController.h"
#import <Reachability/Reachability.h>
#import "MCCrypto.h"
#import "APService.h"
#import "MCMainViewController.h"
#import "MCOrgBL.h"
#import "MCDeptBL.h"
#import "MCBookBL.h"
#import "MCCircleDataHandler.h"

@interface MCViewController ()

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.buttonLogin.backgroundColor = UIColorFromRGB(0x2a84d1);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (backgroundTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;    
    //只需要点击非文字输入区域就会响应
    [self.view addGestureRecognizer: tapGestureRecognizer];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    
    self.buttonSMSPassword.layer.cornerRadius = 5.0;
    self.buttonSMSPassword.backgroundColor = UIColorFromRGB(0xed6969);
    //隐藏输入密码
    self.textFieldPwd.SecureTextEntry = YES;
    
    UIAlertView *alertView;
    //检测网络连接
    Reachability *reachability = [Reachability reachabilityWithHostname:MYCIRCLE_HOST];
    switch([reachability currentReachabilityStatus])
    {
        case NotReachable:
            // 没有网络连接
            alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器，请确认网络连接是否可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:)
												 name: UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    
    //根据屏幕尺寸设置不同的背景图
    self.imageLoginBackground.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"LoginImage")];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewWillDisappear:(BOOL)animated {
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (keyboardVisible) {//键盘已经出现要忽略通知
		return;
	}
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //改变InputView Constraints
    if (self.view.frame.size.height != IPHONE5_VIEW_HEIGHT && self.view.frame.size.height != (IPHONE5_VIEW_HEIGHT-20)) {
        self.inputViewHeight.constant -= HEIGHT_WITH_SCROLLING;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    keyboardVisible = YES;
}

- (void)keyboardWillHide: (NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //改变InputView Constraints
    if (self.view.frame.size.height != IPHONE5_VIEW_HEIGHT  && self.view.frame.size.height != (IPHONE5_VIEW_HEIGHT-20)) {
        self.inputViewHeight.constant += HEIGHT_WITH_SCROLLING;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];

    if (!keyboardVisible) {
		return;
	}
    
	keyboardVisible = NO;
}

- (IBAction)textFieldShoudReturn:(id)sender {
    [sender resignFirstResponder];
}

- (void)backgroundTap:(UITapGestureRecognizer *)sender {
    //关闭所有UITextField控件的键盘
    [self.textFieldAccount resignFirstResponder];
    [self.textFieldPwd resignFirstResponder];
}

//点击登录按钮
- (IBAction)login:(UIButton *)sender {
    //验证输入的用户名和密码是否合法,需要一个model处理
    
    //提示用户正在登录中
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"正在登录";
	
	[HUD showWhileExecuting:@selector(startRequest) onTarget:self withObject:nil animated:NO];
}

//点击获取短信密码按钮
- (IBAction)getPasswordFromSMS:(UIButton *)sender {
    NSString *strAccount = self.textFieldAccount.text;
    [self startRequestPasswordFromSMS:strAccount];
}

//开始请求Web Service
-(void)startRequest{
    UIAlertView *alert;
    NSString *strAccount = self.textFieldAccount.text;
    NSString *strPwd = self.textFieldPwd.text;
    NSString *cipherPwd = [MCCrypto DESEncrypt:strPwd WithKey:DESENCRYPTED_KEY];
    
    NSInteger loginResult = [MCLoginHandler isLoginedSuccessfully:strAccount password:cipherPwd];
    switch (loginResult) {
        case 0:
            //同步圈子数据
            [MCCircleDataHandler updateContactsData:strAccount];
            //登陆成功，注册jpush alias
            [APService setAlias:strAccount callbackSelector:nil object:nil];
            //跳转到主页面
            DLog(@"\n 登陆成功，跳转到主页面");
            [self performSegueWithIdentifier:@"showMain" sender:self];
            break;
        case 1:
            //登录失败，密码错误
            alert = [[UIAlertView alloc] initWithTitle:@"手机号或密码错误" message:@"请检查账号是否正确，或重新输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //optional - add more buttons:
            //        [alert addButtonWithTitle:@"Yes"];
            alert.tag = 2;
            [alert show];
            break;
        case 2:
            //登陆请求发送失败或反馈错误
            alert = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"请检查网络连接是否正常，并尝试重新登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //optional - add more buttons:
            //[alert addButtonWithTitle:@"Yes"];
            alert.tag = 1;
            [alert show];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMain"]) {
        MCMainViewController *mainVC = segue.destinationViewController;
        mainVC.isFirstLogined = YES;
    }
}

//- (NSMutableData *)datas {
//    if (_datas == nil) {
//        NSLog(@"初始化datas");
//        _datas = [NSMutableData new];
//    }
//    
//    return _datas;
//}

//向web service发送获短信密码的异步请求
- (void)startRequestPasswordFromSMS:(NSString *)strAccount {
    NSString *strURL = [[NSString alloc] initWithFormat:[BASE_URL stringByAppendingString:@"Contact/contact!applyRanAjax.action?tel=%@"],strAccount];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
	NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    if (connection) {
        self.datas = [NSMutableData new];
    }
}
 
#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.datas appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    DLog(@"异步请求发生错误\n %@",[error localizedDescription]);
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSDictionary *dictRoot = [NSJSONSerialization JSONObjectWithData:self.datas options:NSJSONReadingAllowFragments error:nil];
    NSString *strResult = [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"result"]];
    BOOL isSuccessful = [strResult isEqualToString:@"1"];
    if (isSuccessful) {
        //pop alert dialog
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取短信密码成功" message: [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"resultDesc"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //optional - add more buttons:
        //        [alert addButtonWithTitle:@"Yes"];
        alert.tag = 2;
        [alert show];
    }
    else {
        //pop alert dialog
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取短信密码失败" message: [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"resultDesc"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //optional - add more buttons:
        //        [alert addButtonWithTitle:@"Yes"];
        alert.tag = 2;
        [alert show];
    }
}

#pragma mark- UIAlertViewDelegate 委托方法
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
        }
    }
    else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self.textFieldPwd becomeFirstResponder];
        }
    }
    else if (alertView.tag == 3) {
        //
    }
}
#pragma mark- MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
