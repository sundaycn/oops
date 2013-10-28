//
//  MCMainViewController.m
//  MyCircle
//
//  Created by Samuel on 10/28/13.
//
//

#import "MCMainViewController.h"

@interface MCMainViewController ()

@end

@implementation MCMainViewController

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
    //修改TabBar文字和图标得颜色
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        [[UITabBar appearance] setTintColor:UIColorFromRGB(0x3d97e9)];
    }
    else {
        [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0xffffff)];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
