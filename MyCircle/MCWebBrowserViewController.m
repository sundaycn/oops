//
//  MCWebBrowserViewController.m
//  MyCircle
//
//  Created by Samuel on 5/11/14.
//
//

#import "MCWebBrowserViewController.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "MCMicroManagerLoginVC.h"
#import <AFNetworking/AFNetworking.h>
#import "MCConfig.h"
#import "MCMicroManagerAccountDAO.h"
#import "MCFilePreviewViewController.h"

@protocol JS_MCWebBrowserViewController <JSExport>
- (void)login;
- (void)showLoading;
- (void)hideLoading;
- (void)showMask:(NSString *)strText;
- (void)hideMask;
- (void)getUserName;
- (void)getUserId;
- (BOOL)isSupportPramas;
- (BOOL)isSupportDownload;
- (void)download:(NSString *)file;
- (void)finish:(BOOL)isRefresh;
@end

@interface UIWebView (JavaScriptAlert) <UIAlertViewDelegate>
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;

@end

@implementation UIWebView (JavaScriptAlert)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame
{
    
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"移动办公"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    customAlert.tag = 1;
    [customAlert show];
}
/*
#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    DLog(@"~~~~~~~~~~~~~~~~~~~~~~~");
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            DLog(@"------------------im alert delegate-------------------");
            [self reload];
            DLog(@"reload......");
        }
    }
}*/
@end

@interface MCWebBrowserViewController () <TSWebViewDelegate, JS_MCWebBrowserViewController, MCWebViewRefreshDelegate>
@property (strong, nonatomic) UIWebView *webView;
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
    //设置navigation bar title
    self.navigationItem.title = self.title;
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = refreshBarButtonItem;

    //设置view尺寸-iOS7
    CGRect newFrame = self.view.frame;
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    newFrame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - statusBarHeight - navigationBarHeight);
    self.view.frame = newFrame;
    //初始化webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.webView.delegate = self;
    [self loadRequestFromURL:self.url];
    
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromURL:(NSURL *)url
{
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
//    DLog(@"request headers with cookies:\n%@", headers);
    
    // we are just recycling the original request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setAllHTTPHeaderFields:headers];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showMMLogin"]) {
        MCMicroManagerLoginVC *mmLoginVC = [segue destinationViewController];
        mmLoginVC.delegate = self;
    }
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

#pragma mark - MCMicroManager Delegate
- (void)didfinishLogin
{
    [self loadRequestFromURL:self.url];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    DLog(@"============did finish load============");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"error:%@", [error localizedDescription]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *strUrl = request.URL.absoluteString;
    DLog(@"url:%@", strUrl);
    NSRange index = [strUrl rangeOfString:@"index.html"];
    if (index.location != NSNotFound) {
        DLog(@"not intercept");
        return YES;
    }
    else {
        if ([self.url.absoluteString isEqualToString:strUrl]) {
            return YES;
        }
        DLog(@"intercept");
        MCWebBrowserViewController *newWebBrowserVC = [[MCWebBrowserViewController alloc] init];
        newWebBrowserVC.title = self.title;
        newWebBrowserVC.url = request.URL;
//        //在切换界面的过程中禁止滑动手势，避免界面卡死
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
        newWebBrowserVC.delegate = self;
        [self.navigationController pushViewController:newWebBrowserVC animated:YES];
        return NO;
    }
}

- (void)refresh:(UIBarButtonItem *)sender
{
    [self.webView reload];
}
/*
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame {
    
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"我是JS Alert"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    
    [customAlert show];
}*/

#pragma mark - TSWebViewDelegate
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
    /*
     ctx[@"sayHello"] = ^{
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     UIAlertView* av = [[UIAlertView alloc] initWithTitle: @"Hello, World!"
     message: nil
     delegate: nil
     cancelButtonTitle: @"OK"
     otherButtonTitles: nil];
     
     [av show];
     });
     };*/
    ctx[@"APP"] = self;
}

#pragma mark - MCWebViewRefreshDelegate
- (void)webViewDidPop:(BOOL)isRefresh
{
    if (isRefresh) {
        [self.webView reload];
    }
}

#pragma mark - Call from Javascript of UIWebView
- (void)login
{
    [self performSegueWithIdentifier:@"showMMLogin" sender:self];
}

- (void)showLoading
{
    DLog(@"showLoading...");
}

- (void)hideLoading
{
    DLog(@"hideLoading");
}

- (void)showMask:(NSString *)strText
{
    DLog(@"im showMask:%@", strText);
}

- (void)hideMask
{
    DLog(@"im hideMask");
}

- (BOOL)isSupportPramas
{
    return YES;
}

- (BOOL)isSupportDownload
{
    return YES;
}

- (void)download:(NSString *)file
{
    NSString *strSeparator = @"@shownName=";
    NSRange rangeSeparator = [file rangeOfString:strSeparator];
    NSString *strFilePath = [file substringWithRange:NSMakeRange(0, rangeSeparator.location)];
    DLog(@"download file path:%@", strFilePath);
    NSString *strFileName = [file substringWithRange:NSMakeRange(rangeSeparator.location+strSeparator.length, file.length-rangeSeparator.location-strSeparator.length)];
    DLog(@"download file name:%@", strFileName);
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    MCFilePreviewViewController *filePreviewVC = [storyboard instantiateViewControllerWithIdentifier:@"FilePreviewSB"];
    filePreviewVC.strFileName = strFileName;
    filePreviewVC.strFilePath = strFilePath;
    
    [self.navigationController pushViewController:filePreviewVC animated:YES];
    
    /*
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.progress = 0.0f;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:strFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progressView.progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *downloadsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDownloadsDirectory  inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        DLog(@"docments directory url: %@", downloadsDirectoryURL);
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return [downloadsDirectoryURL URLByAppendingPathComponent:strFileName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        DLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];*/
}

- (void)finish:(BOOL)isRefresh
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate webViewDidPop:isRefresh];
}

//faked function for javascript
- (void)getUserName
{
    //
}

- (void)getUserId
{
    //
}
@end
