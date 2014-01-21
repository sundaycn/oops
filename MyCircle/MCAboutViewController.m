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
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImageView *imageAbout= [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    imageAbout.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"About")];
    
    [self.view addSubview:imageAbout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
