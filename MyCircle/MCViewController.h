//
//  MCViewController.h
//  MyCircle
//
//  Created by Samuel on 10/1/13.
//
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MCLoginHandler.h"

@interface MCViewController : UIViewController <UIAlertViewDelegate, MBProgressHUDDelegate> {
    //键盘是否出现
    BOOL keyboardVisible;
    //事件进度提示窗
    MBProgressHUD *HUD;
    //登录账号
}
@property (weak, nonatomic) IBOutlet UIImageView *imageLoginBackground;

@property (weak, nonatomic) IBOutlet UITextField *textFieldAccount;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPwd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonSMSPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

//下载队列
@property (strong, nonatomic) NSOperationQueue *downloadQueue;
//接收从服务器返回数据。
@property (strong,nonatomic) NSMutableData *datas;

- (IBAction)textFieldShoudReturn:(id)sender;
- (IBAction)login:(UIButton *)sender;
- (IBAction)getPasswordFromSMS:(UIButton *)sender;

//登陆视图是否为根视图
+ (BOOL)isInitLoginView;
//开始请求web service
- (void)startRequest;
//向web service发送获短信密码的异步请求
- (void)startRequestPasswordFromSMS:(NSString *)strAccount;

@end
