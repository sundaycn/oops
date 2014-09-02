//
//  MCMicroManagerVC.m
//  MyCircle
//
//  Created by Samuel on 5/21/14.
//
//

#import "MCMicroManagerLoginVC.h"
#import "MCMicroManagerAccountDAO.h"

@interface MCMicroManagerLoginVC ()
@property (weak, nonatomic) IBOutlet UILabel *labelMMUserName;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextField *textMMPassword;
@property (strong, nonatomic) MCMicroManagerAccount *mmAccount;
@end

@implementation MCMicroManagerLoginVC

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
    //根据屏幕尺寸设置不同的背景图
    self.view.backgroundColor = UIColorFromRGB(0xd5d5d5);
    //设置按钮背景色
    self.buttonLogin.backgroundColor = UIColorFromRGB(0x2a84d1);
    self.buttonBack.backgroundColor = UIColorFromRGB(0x2a84d1);
    //隐藏输入密码
    self.textMMPassword.SecureTextEntry = YES;
    //设置微管理默认用户名
    self.mmAccount = [[MCMicroManagerAccountDAO sharedManager] queryDefaultAccount];
    self.labelMMUserName.text = self.mmAccount.userCode;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (backgroundTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    //只需要点击非文字输入区域就会响应
    [self.view addGestureRecognizer: tapGestureRecognizer];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)textFieldShouldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (void)backgroundTap:(UITapGestureRecognizer *)sender
{
    //关闭所有UITextField控件的键盘
    [self.textMMPassword resignFirstResponder];
}

- (IBAction)loginMicroManager:(UIButton *)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"正在登录...";
	[HUD showWhileExecuting:@selector(loginWithSyncRequest) onTarget:self withObject:nil animated:NO];

}

- (void)loginWithSyncRequest
{
    MCMicroManagerAccount *mmAccount = [[MCMicroManagerAccountDAO sharedManager] queryDefaultAccount];
    NSString *strPassword = self.textMMPassword.text;
    NSString *strUrl = [MM_BASE_URL stringByAppendingString:@"easy-login!dologinAjax.action?user.userCode=%@&user.loginPwd=%@&acctId=%@"];
    strUrl = [NSString stringWithFormat:strUrl, mmAccount.userCode, strPassword, mmAccount.acctId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    DLog(@"response:%@", response);
    if(data == nil)
    {
        DLog(@"微管理登陆失败");
        DLog(@"Code:%d,domain:%@,localizedDesc:%@",[error code],
             [error domain],[error localizedDescription]);
    }
    else {
        NSDictionary *dictLoginResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        BOOL isSuccessful = [(NSNumber *)[NSString stringWithFormat:@"%@",[dictLoginResponse objectForKey:@"success"]] boolValue];
        if (isSuccessful) {
            NSDictionary *dictMessage = [dictLoginResponse objectForKeyedSubscript:@"message"];
            if ([(NSNumber *)[dictMessage objectForKey:@"result"] boolValue]) {
                DLog(@"微管理登陆成功");
                [self dismissViewControllerAnimated:YES completion:^{DLog(@"返回微管理");
                    [self.delegate didfinishLogin];}];
            }
            else {
                NSString *message = [dictMessage objectForKey:@"resultDesc"];
                DLog(@"微管理登录失败:%@", message);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微管理"
                                                                      message:message
                                                                     delegate:nil
                                                            cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil];
                
                [alertView show];
            }



        }
    }
}

#pragma mark- MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}
@end
