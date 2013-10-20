//
//  MCViewController.h
//  MyCircle
//
//  Created by Samuel on 10/1/13.
//
//

#import <UIKit/UIKit.h>
#import "MCGlobal.h"
#import "NSString+URLEncoding.h"
#import "NSNumber+Message.h"
#import "MCCrypto.h"
#import "MCBookBL.h"
#import "MCDeptBL.h"

@interface MCViewController : UIViewController <UIAlertViewDelegate> {
    //键盘是否出现
    BOOL keyboardVisible;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldAccount;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPwd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;

//下载队列
@property (strong, nonatomic) NSOperationQueue *downloadQueue;
//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;
//接收从服务器返回数据。
@property (strong,nonatomic) NSMutableData *datas;

- (IBAction)textFieldShoudReturn:(id)sender;
- (IBAction)login:(UIButton *)sender;

//重新加载表视图
//- (void)reloadView:(NSDictionary*)res;
//开始请求web service
- (void)startRequest;
//向web service发送获取人员部门信息的异步请求
- (void)startRequestBookAndDepartmentInfomation:(NSString *)strAccount belongOrgId:(NSString *)strOrgId;

@end
