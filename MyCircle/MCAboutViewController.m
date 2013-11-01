//
//  MCAboutViewController.m
//  MyCircle
//
//  Created by Samuel on 10/31/13.
//
//

#import "MCAboutViewController.h"

@interface MCAboutViewController ()

@end

@implementation MCAboutViewController

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
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x1F82D6);
        
    }
    else {
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x1F82D6);
    }
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    if (IS_R4) {
        self.labelQQConstraint.constant += HEIGHT_WITH_SCROLLING;
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    self.imageAbout.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"About")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
