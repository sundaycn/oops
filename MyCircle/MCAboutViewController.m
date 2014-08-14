//
//  MCAboutViewController.m
//  MyCircle
//
//  Created by Samuel on 10/31/13.
//
//

#import "MCAboutViewController.h"
#import "MCUtility.h"

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
    UIImageView *imageAbout= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageAbout.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"About")];
    
    UILabel *labelVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, 0, 0)];
    labelVersion.font = [UIFont systemFontOfSize:20];
    labelVersion.textColor = UIColorFromRGB(0x5a5a5a);
    labelVersion.text = [MCUtility versionBuild];
    [labelVersion sizeToFit];
    CGRect newframe = labelVersion.frame;
    newframe.origin.x = (self.view.frame.size.width - labelVersion.frame.size.width) / 2;
    labelVersion.frame = newframe;
    [imageAbout addSubview:labelVersion];
    
    UILabel *labelCopyrightCN = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, 0, 0)];
    labelCopyrightCN.font = [UIFont systemFontOfSize:10];
    labelCopyrightCN.textColor = UIColorFromRGB(0x5a5a5a);
    labelCopyrightCN.text = @"江西电信信息产业有限公司 版权所有";
    [labelCopyrightCN sizeToFit];
    newframe = labelCopyrightCN.frame;
    newframe.origin.x = (self.view.frame.size.width - labelCopyrightCN.frame.size.width) / 2;
    labelCopyrightCN.frame = newframe;
    [imageAbout addSubview:labelCopyrightCN];
    
    UILabel *labelCopyrightEN = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-20, 0, 0)];
    labelCopyrightEN.font = [UIFont systemFontOfSize:10];
    labelCopyrightEN.textColor = UIColorFromRGB(0x5a5a5a);
    labelCopyrightEN.text = @"Copyright © 2013-2014 All Rights Reserved.";
    [labelCopyrightEN sizeToFit];
    newframe = labelCopyrightEN.frame;
    newframe.origin.x = (self.view.frame.size.width - labelCopyrightEN.frame.size.width) / 2;
    labelCopyrightEN.frame = newframe;
    [imageAbout addSubview:labelCopyrightEN];
    
    [self.view addSubview:imageAbout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
