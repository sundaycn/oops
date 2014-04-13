//
//  MCMyInfoNameViewController.m
//  MyCircle
//
//  Created by Samuel on 4/8/14.
//
//

#import "MCMyInfoNameViewController.h"

@interface MCMyInfoNameViewController ()
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
    UITextField *textName = [[UITextField alloc] initWithFrame:CGRectMake(0, 79, 320, 40)];
    textName.borderStyle = UITextBorderStyleNone;
    textName.backgroundColor = [UIColor whiteColor];
    textName.leftView = paddingView;
    textName.leftViewMode = UITextFieldViewModeAlways;
    textName.textColor = [UIColor blackColor];
    textName.font = [UIFont systemFontOfSize:17.0f];
    textName.textAlignment = NSTextAlignmentLeft;
    textName.clearButtonMode = UITextFieldViewModeAlways;
    textName.keyboardType = UIKeyboardTypeDefault;
    textName.returnKeyType = UIReturnKeyDone;
    textName.text = self.strName;
    textName.delegate = self;
    [textName becomeFirstResponder];
    
    [self.view addSubview:textName];
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
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

@end
