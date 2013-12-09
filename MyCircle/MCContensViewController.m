//
//  MCContensViewController.m
//  MyCircle
//
//  Created by Samuel on 12/1/13.
//
//

#import "MCContensViewController.h"

@interface MCContensViewController ()

@end

@implementation MCContensViewController

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
    [self initStartPage];
    [self.view addSubview:self.viewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initStartPage
{
    self.viewController = [[CDVViewController alloc] init];
    self.viewController.wwwFolderName = @"www";
    NSString *strURL = [[[@"i.html?from=activity&id=" stringByAppendingString:self.id] stringByAppendingString:@"&belongOrgId="] stringByAppendingString:self.belongOrgId];
    self.viewController.startPage = strURL;
    //y = 14.9
    self.viewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
