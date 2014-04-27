//
//  MCGuidPageViewController.m
//  MyCircle
//
//  Created by Samuel on 4/24/14.
//
//

#import "MCGuidPageViewController.h"

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
//    page1.title = @"Hello world";
    //    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"ImageGuidPage1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"This is page 2";
    //    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"ImageGuidPage2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"This is page 3";
    //    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"ImageGuidPage3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
//    page4.title = @"This is page 4";
    //    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"ImageGuidPage4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroPage *page5 = [EAIntroPage page];
//    page5.title = @"This is page5";
    //    page4.desc = sampleDescription4;
    page5.bgImage = [UIImage imageNamed:@"ImageGuidPage5"];
    page5.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title5"]];
    
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
    DLog(@"introDidFinish callback");
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

@end
