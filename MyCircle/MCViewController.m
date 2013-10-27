//
//  MCViewController.m
//  MyCircle
//
//  Created by Samuel on 10/1/13.
//
//

#import "MCViewController.h"

@interface MCViewController ()

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (backgroundTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;    
    //只需要点击非文字输入区域就会响应
    [self.view addGestureRecognizer: tapGestureRecognizer];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    
    self.buttonSMSPassword.layer.cornerRadius = 5.0;
    self.buttonSMSPassword.backgroundColor = UIColorFromRGB(0xff6f3d);
    //隐藏输入密码
    self.textFieldPwd.SecureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:)
												 name: UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
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

- (void) keyboardWillHide: (NSNotification *)notification {
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
    //判断网络是否联通

    
    //验证输入的用户名和密码是否合法,需要一个model处理
    
    //提示用户正在登
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"正在登录";
	
	[HUD showWhileExecuting:@selector(startRequest) onTarget:self withObject:nil animated:YES];
}

//点击获取短信密码按钮
- (IBAction)getPasswordFromSMS:(UIButton *)sender {
    NSString *strAccount = self.textFieldAccount.text;
    [self startRequestPasswordFromSMS:strAccount];
}

//开始请求Web Service
-(void)startRequest{
    NSString *strAccount = self.textFieldAccount.text;
    NSString *strPwd = self.textFieldPwd.text;
    NSString *encryptedKey = DESENCRYPTED_KEY;
    NSString *cipherPwd = [MCCrypto DESEncrypt:strPwd WithKey:encryptedKey];

    NSString *strURL = [[NSString alloc] initWithFormat:@"http://117.21.209.104/EasyContact/Contact/contact!loginAjax.action?tel=%@&password=%@&stamp=%@",strAccount,cipherPwd,@"12345"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    //同步请求
    NSError *error = nil;
    NSData *response  = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (response == nil) {
        if (ISDEBUG) {
            NSLog(@"同步请求发生错误\n %@", error);
//            NSLog(@"测试\n %@\n %@", error.localizedDescription, error.localizedFailureReason);
        }

        //弹出警告窗
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"请检查网络连接是否正常，并尝试重新登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //optional - add more buttons:
        //[alert addButtonWithTitle:@"Yes"];
        alert.tag = 1;
        [alert show];

        return;

    }

    //把enterprise的值由字符串格式转为json数组格式
    NSString *strJsonResult = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\"[" withString:@"["];
    strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    strJsonResult = [strJsonResult stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    if (ISDEBUG) {
        NSLog(@"\n 服务器返回:\n%@", strJsonResult);
    }

    //重新封装json数据
    NSData *dataLoginResponse = [strJsonResult dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dictLoginResponse = [NSJSONSerialization JSONObjectWithData:dataLoginResponse options:NSJSONReadingAllowFragments error:nil];
    //判断服务器返回结果
    NSString *strLoginResult = [NSString stringWithFormat:@"%@",[[dictLoginResponse objectForKey:@"root"] objectForKey:@"result"]];
    DLog(@"\n 登陆结果:%@", [strLoginResult isEqualToString:@"1"] ? @"true" : @"false");
    BOOL isLoginedSuccessfully = [strLoginResult isEqualToString:@"1"];
    if (isLoginedSuccessfully) {
        
        //提取组织id
        NSArray *arrOrgInfo = [[dictLoginResponse objectForKey:@"root"] objectForKey:@"enterprise"];
//        //删除数据
//        MCBookBL *bookBL = [[MCBookBL alloc] init];
//        BOOL isDeletedAll = [bookBL removeAll];
//        if (isDeletedAll) {
//            DLog(@"删除完毕");
//        }
        //构建下载队列获取人员部门信息
        NSInvocationOperation *operation;
        self.downloadQueue = [NSOperationQueue new];
        [self.downloadQueue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
        [self.downloadQueue setMaxConcurrentOperationCount:1];

        //清空enterprise数据
        MCOrgBL *orgBL = [[MCOrgBL alloc] init];
        BOOL isClear = [orgBL removeAll];
        if (!isClear) {
#warning 提示用户数据处理异常
            DLog(@"清空enterprise数据失败");
        }
        else {
        
        for (NSDictionary *dictOrgInfo in arrOrgInfo) {
            //向web service发送获取人员部门信息的异步请求
//            [self startRequestBookAndDepartmentInfomation:strAccount belongOrgId:[dictOrgInfo objectForKey:@"id"]];
            //保存enterprise数据
            MCOrg *org = [[MCOrg alloc] init];
            org.id = [NSString stringWithFormat:@"%@", [dictOrgInfo objectForKey:@"id"]];
            org.name = [NSString stringWithFormat:@"%@", [dictOrgInfo objectForKey:@"name"]];
            
            BOOL isCreatedSuccessfully = [orgBL create:org];
            if (!isCreatedSuccessfully) {
#warning 提示用户数据更新不完整
                DLog(@"插入enterprise数据失败");
            }

#warning 测试代码
            MCOrgBL *orgBLTemp = [[MCOrgBL alloc] init];
            NSMutableArray *orgList = [orgBLTemp findAll];
            DLog(@"enterprise amount:%d", orgList.count);
            
            NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://117.21.209.104/EasyContact/Contact/contact!syncAjax.action?orgId=%@&tel=%@",[dictOrgInfo objectForKey:@"id"],strAccount]];
            operation = [[NSInvocationOperation alloc]
                         initWithTarget:self
                         selector:@selector(download:)
                         object:url];
            [self.downloadQueue addOperation:operation];
        }
        
        //跳转到主页面
        DLog(@"\n 登陆成功，跳转到主页面");
        [self performSegueWithIdentifier:@"showMain" sender:self];
        }
    }
    else {
        DLog(@"\n 登陆失败");
        //pop alert dialog
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号或密码错误" message:@"请检查账号是否正确，或重新输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //optional - add more buttons:
//        [alert addButtonWithTitle:@"Yes"];
        alert.tag = 2;
        [alert show];

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

-(void)download:(NSURL *)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    //doSomethingHereWithData;
    //保存数据
    NSDictionary *dictRoot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //判断是否清除该组织的所有人员和部门数据
    NSString *strClearAll = [NSString stringWithFormat:@"%@", [[dictRoot objectForKey:@"root"] objectForKey:@"clearLocaldataAll"]];
    BOOL isClearAll = [strClearAll isEqualToString:@"1"];
    if (isClearAll) {
        //获取belongOrgId
#warning 获取方式可以优化为截取字符串
        NSString *belongOrgId = [NSString stringWithFormat:@"%@", [[[[dictRoot objectForKey:@"root"] objectForKey:@"book"] lastObject] objectForKey:@"belongOrgId"]];
        //删除人员数据
        MCBookBL *bookBL = [[MCBookBL alloc] init];
        BOOL isDeletedAll = [bookBL removeByOrgId:belongOrgId];
        if (isDeletedAll) {
            DLog(@"%@ 的人员删除完毕", belongOrgId);
        }
        //删除部门数据
        MCDeptBL *deptBL = [[MCDeptBL alloc] init];
        isDeletedAll = [deptBL removeByOrgId:belongOrgId];
        if (isDeletedAll) {
            DLog(@"%@ 的部门删除完毕", belongOrgId);
        }

    }
    //更新人员数据
    NSArray *arrBook = [[dictRoot objectForKey:@"root"] objectForKey:@"book"];
    for (NSDictionary *dict in arrBook) {
        MCBook *book = [[MCBook alloc] init];
        book.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        book.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"personName"]];
        book.mobilePhone = [NSString stringWithFormat:@"%@", [dict objectForKey:@"mobilePhone"]];
        book.officePhone = [NSString stringWithFormat:@"%@", [dict objectForKey:@"officePhone"]];
        book.position = [NSString stringWithFormat:@"%@", [dict objectForKey:@"position"]];
        book.sort = [dict objectForKey:@"sort"];
        book.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        book.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
        book.belongDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongDepartmentId"]];
        book.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
        
        MCBookBL *bookBL = [[MCBookBL alloc] init];
        BOOL isCreatedSuccessfully = [bookBL create:book];
        if (!isCreatedSuccessfully) {
#warning 提示用户数据更新不完整
            DLog(@"插入book失败");
        }
    }

    MCBookBL *bookBL = [[MCBookBL alloc] init];
    NSMutableArray *bookList = [bookBL findAll];
    DLog(@"book amount:%d", bookList.count);
    
    //更新部门数据
    NSArray *arrDept = [[dictRoot objectForKey:@"root"] objectForKey:@"department"];
    for (NSDictionary *dict in arrDept) {
        MCDept *dept = [[MCDept alloc] init];
        dept.id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        dept.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
        dept.sort = [dict objectForKey:@"sort"];
        dept.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
        dept.syncFlag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"syncFlag"]];
        dept.upDepartmentId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"upDepartmentId"]];
        dept.belongOrgId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"belongOrgId"]];
        
        MCDeptBL *deptBL = [[MCDeptBL alloc] init];
        BOOL isCreatedSuccessfully = [deptBL create:dept];
        if (!isCreatedSuccessfully) {
#warning 提示用户数据更新不完整
            DLog(@"插入dept失败");
        }
    }
    
    MCDeptBL *deptBL = [[MCDeptBL alloc] init];
    NSMutableArray *deptList = [deptBL findAll];
    DLog(@"department amount:%d", deptList.count);


}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([self.downloadQueue.operations count] == 0)
    {
#warning 提示用户获取数据成功
        DLog(@"圈子数据更新完毕");
    }
}


//向web service发送获短信密码的异步请求
- (void)startRequestPasswordFromSMS:(NSString *)strAccount {
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://117.21.209.104/EasyContact/Contact/contact!applyRanAjax.action?tel=%@",strAccount];
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


- (void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
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
