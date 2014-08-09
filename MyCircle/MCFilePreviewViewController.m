//
//  MCFilePreviewViewController.m
//  MyCircle
//
//  Created by Samuel on 8/8/14.
//
//

#import "MCFilePreviewViewController.h"

@interface MCFilePreviewViewController ()

@end

@implementation MCFilePreviewViewController

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
    //设置view尺寸-iOS7
    CGRect newFrame = self.view.frame;
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    newFrame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - statusBarHeight - navigationBarHeight);
    self.view.frame = newFrame;
    //初始化webView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:webView];
    [self loadFile:self.path inView:webView];
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

- (void)loadFile:(NSURL *)path inView:(UIWebView *)webView
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:path];
    [webView loadRequest:urlRequest];
}

@end
