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

@protocol JS_MCWebBrowserViewController <JSExport>
- (void)login;
- (void)showLoading;
- (void)hideLoading;
- (void)showMask:(NSString *)strText;
- (void)hideMask;
- (void)getUserName;
@end

@interface MCWebBrowserViewController () <TSWebViewDelegate, JS_MCWebBrowserViewController>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
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
    self.webView.delegate = self;
    [self loadRequestFromHtml:self.strHtmlPath];
    /*NSString *strUrl = @"http://117.21.209.104/EasyOA/easy-login!dologinAjax.action?user.userCode=sundi&user.loginPwd=79109958&acctId=0660b5b440b8d3800140b9cdb55b00b4";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:60.0];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if(data == nil)
    {
        DLog(@"Code:%d,domain:%@,localizedDesc:%@",[error code],
             [error domain],[error localizedDescription]);
        
    }
    else {
        DLog(@"success");
    }*/
    
//    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
//    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"RESPONSE HEADERS: \n%@", [response allHeaderFields]);
    
    // If you want to get all of the cookies:
//    NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"http://www.3weike.com"]];
//    NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:strUrl]];
//    NSLog(@"How many Cookies: %d", all.count);
    // Store the cookies:
    // NSHTTPCookieStorage is a Singleton.
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:@"http://www.3weike.com"] mainDocumentURL:nil];
    
    // Now we can print all of the cookies we have:
//    for (NSHTTPCookie *cookie in all)
//        NSLog(@"Name: %@ : Value: %@, Expires: %@, Domain:%@, Path:%@, isSessionOnly:%d", cookie.name, cookie.value, cookie.expiresDate, cookie.domain, cookie.path, cookie.isSessionOnly);
    
    
    // Now lets go back the other way.  We want the server to know we have some cookies available:
    // this availableCookies array is going to be the same as the 'all' array above.  We could
    // have just used the 'all' array, but this shows you how to get the cookies back from the singleton.
//    NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://3weike.com"]];
    /*NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    DLog(@"availableCookies array:%@", availableCookies);
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
//    DLog(@"headers:\n%@", headers);
    
    // we are just recycling the original request
    NSString *strPath = [[NSBundle mainBundle] pathForResource:self.strHtmlPath ofType:@"html"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:strPath]];
    [urlRequest setAllHTTPHeaderFields:headers];
    [self.webView loadRequest:urlRequest];*/
    
//    NSString *strPath = [[NSBundle mainBundle] pathForResource:self.strHtmlPath ofType:@"html"];
//    DLog(@"strPath:%@", strPath);
//    request.URL = [NSURL fileURLWithPath:strPath];
//    DLog(@"request.url:%@", request.URL);
//    error = nil;
//    response = nil;
//    [self addCookies:all forRequest:request];
//    [self.webView loadRequest:request];

    
//    request.URL = [NSURL URLWithString:@"http://temp/gomh/authenticate.py"];
//    error       = nil;
//    response    = nil;
    
//    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"The server saw:\n%@", [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding]);
//    NSArray *cooks = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
//    [self addCookies:all forRequest:request];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCookies:(NSArray *)cookies forRequest:(NSMutableURLRequest *)request
{
    if ([cookies count] > 0)
    {
        NSHTTPCookie *cookie;
        NSString *cookieHeader = nil;
        for (cookie in cookies)
        {
            if (!cookieHeader)
            {
                cookieHeader = [NSString stringWithFormat: @"%@=%@",[cookie name],[cookie value]];
            }
            else
            {
                cookieHeader = [NSString stringWithFormat: @"%@; %@=%@",cookieHeader,[cookie name],[cookie value]];
            }
        }
        if (cookieHeader)
        {
            [request setValue:cookieHeader forHTTPHeaderField:@"Cookie"];
        }
    }
}

- (void)loadRequestFromString:(NSString *)strURL
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    [self.webView loadRequest:urlRequest];
}

- (void)loadRequestFromHtml:(NSString *)strFilePath
{
//    DLog(@"html file path:%@", strFilePath);
    NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    DLog(@"availableCookies array:%@", availableCookies);
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
    DLog(@"request headers with cookies:\n%@", headers);
    
    // we are just recycling the original request
    NSString *strPath = [[NSBundle mainBundle] pathForResource:strFilePath ofType:@"html"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:strPath]];
    [urlRequest setAllHTTPHeaderFields:headers];
    [self.webView loadRequest:urlRequest];
}

/*
- (void)userCookie:(NSString *)theCookie
{
    //JSESSIONID=25F6DBC6AB286542F37D58B8EDBB84BD; Path=/pad, cookie_user=fsdf#~#sdfs.com; Expires=Tue, 26-Nov-2013 06:31:33 GMT, cookie_pwd=123465; Expires=Tue, 26-Nov-2013 06:31:33 GMT
    //为了拿到对应的键值，需要处理cookies字符串，下面的代码是为了能正确分割这个字符串以便拿到 JSESSIONID,Path,cookie_user,Expires,cookie_pwd,Expires这几个key以及对应的value。
    
    NSMutableArray *cookisArray=[NSMutableArray arrayWithCapacity:20];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    
    NSArray *theArray = [theCookie componentsSeparatedByString:@"; "];
    for (int i =0 ; i<[theArray count]; i++) {
        NSString *val=theArray[i];
        if ([val rangeOfString:@"="].length>0)
        {
            NSArray *subArray = [val componentsSeparatedByString:@"="];
            for (int i =0 ; i<[subArray count]; i++) {
                NSString *subVal=subArray[i];
                if ([subVal rangeOfString:@", "].length>0)
                {
                    NSArray *subArray2 = [subVal componentsSeparatedByString:@", "];
                    for (int i =0 ; i<[subArray2 count]; i++) {
                        NSString *subVal2=subArray2[i];
                        [cookisArray addObject:subVal2];
                    }
                }
                else
                {
                    [cookisArray addObject:subVal];
                }
            }
        }
        else
        {
            [cookisArray addObject:val];
        }
    }
    for (int idx=0; idx<cookisArray.count; idx+=2) {
        NSString *key=cookisArray[idx];
        NSString *value;
        if ([key isEqualToString:@"Expires"])
        {
            value=[NSString stringWithFormat:@"%@, %@",cookisArray[idx+1],cookisArray[idx+2]];
            idx+=1;
        }
        else
        {
            value=cookisArray[idx+1];
        }
        Log(@"cookie value:%@=%@",key,value);
        [cookieProperties setObject:value forKey:key];
    }
    
    [cookieProperties setObject:@"sfsdf" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"sdfsdf" forKey:NSHTTPCookieValue];
    //关键在这里，要设置好domain的值，这样webview发起请求的时候就会带上我们设置好的cookies
    [cookieProperties setObject:[NSString stringWithFormat:@"mail.%@",[PMUser domainName]] forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:[PMUser domainName] forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    ／／ [cookieProperties setObject:@"gtergr" forKey:@"Device-Model"];／／使用cookie传递参数
    Log(@"%@",cookieProperties);
    //cookie同步webview
    NSHTTPCookie * userCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:userCookie];
}*/

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

#pragma mark - MCMicroManager Delegate
- (void)didfinishLogin
{
    [self loadRequestFromHtml:self.strHtmlPath];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    DLog(@"============did finish load============");
//    [webView stringByEvaluatingJavaScriptFromString:@"helloWorld('从iOS对象中调用JS Ok.')"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"error:%@", [error localizedDescription]);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *strUrl = request.URL.absoluteString;
    NSRange index = [strUrl rangeOfString:@"index.html"];
    if (index.location != NSNotFound) {
        return YES;
    }
    else {
        UIViewController *newVC = [[UIViewController alloc] init];
        //        DLog(@"view fram size height:%f", self.view.frame.size.height);
        UIWebView *newWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 568)];
        [newWebView loadRequest:[NSURLRequest requestWithURL:request.URL]];
        [newVC.view addSubview:newWebView];
        [self.navigationController pushViewController:newVC animated:NO];
        return NO;
    }
    
    return YES;
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

#pragma mark - Call from Javascript of UIWebView
- (void)login
{
    DLog(@"hello, im login");
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
    //
}

- (void)hideMask
{
    //
}

//faked function for javascript
- (void)getUserName
{
    //
}
@end
