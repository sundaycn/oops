//
//  MCWebBrowserViewController.m
//  MyCircle
//
//  Created by Samuel on 5/11/14.
//
//

#import "MCWebBrowserViewController.h"

@interface MCWebBrowserViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;

- (void)loadRequestFromString:(NSString*)strURL;
@end

@implementation MCWebBrowserViewController

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
    self.navigationController.toolbarHidden = NO;
    self.webView.delegate = self;
    [self loadRequestFromString:@"http://qq.com"];
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

- (void)loadRequestFromString:(NSString*)strURL
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"%@", [webView stringByEvaluatingJavaScriptFromString:@"documnet.body.innerHTML"]);
}

- (IBAction)back:(id)sender {
}
@end
