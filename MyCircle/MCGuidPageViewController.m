//
//  MCGuidPageViewController.m
//  MyCircle
//
//  Created by Samuel on 4/24/14.
//
//

#import "MCGuidPageViewController.h"
#import "MCMicroManagerConfigHandler.h"

@interface MCGuidPageViewController ()
@end

@implementation MCGuidPageViewController

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
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"ImageGuidPage1")];
    page1.showTitleView = NO;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"ImageGuidPage2")];
    page2.showTitleView = NO;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"ImageGuidPage3")];
    page3.showTitleView = NO;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"ImageGuidPage4")];
    page4.showTitleView = NO;
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.bgImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"ImageGuidPage5")];
    page5.showTitleView = NO;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];
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

#pragma mark - EAIntro Delegate
- (void)introDidFinish:(EAIntroView *)introView {
    //从plist导入微管理功能模块配置
    [[MCMicroManagerConfigHandler sharedInstance] initConfig];
    //跳转到登录页
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

@end