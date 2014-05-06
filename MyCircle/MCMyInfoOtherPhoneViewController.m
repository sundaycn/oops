//
//  MCMyInfoOtherPhoneViewController.m
//  MyCircle
//
//  Created by Samuel on 4/23/14.
//
//

#import "MCMyInfoOtherPhoneViewController.h"
#import "MCConfig.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "MCMyInfoDAO.h"

@interface MCMyInfoOtherPhoneViewController ()
@property (nonatomic, strong) UITextField *textOtherPhone;
@end

@implementation MCMyInfoOtherPhoneViewController

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
    self.navigationItem.title = @"其他电话";
    self.view.backgroundColor = UIColorFromRGB(0xd5d5d5);
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    paddingView.backgroundColor = [UIColor whiteColor];
    self.textOtherPhone = [[UITextField alloc] initWithFrame:CGRectMake(0, 79, 320, 40)];
    self.textOtherPhone.borderStyle = UITextBorderStyleNone;
    self.textOtherPhone.backgroundColor = [UIColor whiteColor];
    self.textOtherPhone.leftView = paddingView;
    self.textOtherPhone.leftViewMode = UITextFieldViewModeAlways;
    self.textOtherPhone.textColor = [UIColor blackColor];
    self.textOtherPhone.font = [UIFont systemFontOfSize:17.0f];
    self.textOtherPhone.textAlignment = NSTextAlignmentLeft;
    self.textOtherPhone.clearButtonMode = UITextFieldViewModeAlways;
    self.textOtherPhone.keyboardType = UIKeyboardTypeDefault;
    self.textOtherPhone.returnKeyType = UIReturnKeyDone;
    self.textOtherPhone.text = self.strOtherPhone;
    self.textOtherPhone.delegate = self;
    [self.textOtherPhone becomeFirstResponder];
    
    [self.view addSubview:self.textOtherPhone];

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

#pragma UITextField Delegate
//最多输入18个字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 18) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self postData];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

//提交修改值
- (void)postData
{
    //没修改不提交
    if ([self.strOtherPhone isEqualToString:self.textOtherPhone.text]) {
        return;
    }
    
    //获取账号和密码
    NSString *strAccount = [[MCConfig sharedInstance] getAccount];
    NSString *strPassword = [[MCConfig sharedInstance] getCipherPassword];
    DLog(@"password:%@", strPassword);
    NSString *strInfo = [[@"{\"phone\":\"" stringByAppendingString:self.textOtherPhone.text] stringByAppendingString:@"\"}"];
    DLog(@"info:%@", strInfo);
    
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!changeUserAttachInfoAjax.action"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:strAccount forKey:@"tel"];
    [request addPostValue:strPassword forKey:@"password"];
    [request addPostValue:strInfo forKey:@"info"];
    //同步请求
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[[dictResponse objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isOK = [strResult isEqualToString:@"1"];
        if (isOK) {
            DLog(@"个人资料－其他手机修改成功");
            //保存到本地
            MCMyInfo *myInfo = [[MCMyInfoDAO sharedManager] findByAccount:strAccount];
            myInfo.phone = self.textOtherPhone.text;
            [[MCMyInfoDAO sharedManager] modify:myInfo];
            [self.myInfoModifyDelegate updateValueOfCell:self.textOtherPhone.text index:6];
        }
        else {
            DLog(@"个人资料－其他手机修改失败");
        }
    }
    
}

@end
