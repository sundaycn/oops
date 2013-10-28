//
//  MCAbountViewController.m
//  MyCircle
//
//  Created by Samuel on 10/27/13.
//
//

#import "MCAbountViewController.h"

@interface MCAbountViewController ()

@end

@implementation MCAbountViewController

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
