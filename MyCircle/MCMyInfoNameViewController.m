//
//  MCMyInfoNameViewController.m
//  MyCircle
//
//  Created by Samuel on 4/8/14.
//
//

#import "MCMyInfoNameViewController.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "MCConfig.h"
#import "MCMyInfoDAO.h"

@interface MCMyInfoNameViewController ()
@property (nonatomic, strong) UITextField *textName;
@end

@implementation MCMyInfoNameViewController

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
    self.navigationItem.title = @"名字";
    self.view.backgroundColor = UIColorFromRGB(0xd5d5d5);
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    paddingView.backgroundColor = [UIColor whiteColor];
    self.textName = [[UITextField alloc] initWithFrame:CGRectMake(0, 79, 320, 40)];
    self.textName.borderStyle = UITextBorderStyleNone;
    self.textName.backgroundColor = [UIColor whiteColor];
    self.textName.leftView = paddingView;
    self.textName.leftViewMode = UITextFieldViewModeAlways;
    self.textName.textColor = [UIColor blackColor];
    self.textName.font = [UIFont systemFontOfSize:17.0f];
    self.textName.textAlignment = NSTextAlignmentLeft;
    self.textName.clearButtonMode = UITextFieldViewModeAlways;
    self.textName.keyboardType = UIKeyboardTypeDefault;
    self.textName.returnKeyType = UIReturnKeyDone;
    self.textName.text = self.strName;
    self.textName.delegate = self;
    [self.textName becomeFirstResponder];
    
    [self.view addSubview:self.textName];
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
    if ([self.strName isEqualToString:self.textName.text]) {
        return;
    }
    
    //获取账号和密码
    NSString *strAccount = [[MCConfig sharedInstance] getAccount];
    NSString *strPassword = [[MCConfig sharedInstance] getCipherPassword];
    DLog(@"password:%@", strPassword);
    NSString *strInfo = [[@"{\"userName\":\"" stringByAppendingString:self.textName.text] stringByAppendingString:@"\"}"];
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
            DLog(@"个人资料－姓名修改成功");
            //保存到本地
            MCMyInfo *myInfo = [[MCMyInfoDAO sharedManager] findByAccount:strAccount];
            myInfo.userName = self.textName.text;
            [[MCMyInfoDAO sharedManager] modify:myInfo];
            [self.myInfoModifyDelegate updateValueOfCell:self.textName.text index:1];
        }
        else {
            DLog(@"个人资料－姓名修改失败");
        }
    }

}

@end
