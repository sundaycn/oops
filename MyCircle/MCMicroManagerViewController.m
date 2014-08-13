//
//  MCMicroManagerViewController.m
//  MyCircle
//
//  Created by Samuel on 4/27/14.
//
//

#import "MCMicroManagerViewController.h"
#import "MCMicroManagerCell.h"
#import "MCMicroManagerAccountDAO.h"
#import "MCMicroManagerDAO.h"
#import "MCMicroManagerConfigDAO.h"
#import "MCMicroManagerConfigHandler.h"
#import "MCConfig.h"
#import "MCWebBrowserViewController.h"

@interface MCMicroManagerViewController ()
@property (nonatomic ,strong) NSMutableArray *arrMicroManagerMenu;
@end

@implementation MCMicroManagerViewController

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
    self.navigationItem.title = @"微管理";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    //如果默认账号为空，从服务器下载账号信息
    MCMicroManagerAccount *mmAccount = [[MCMicroManagerAccountDAO sharedManager] queryDefaultAccount];
    [MCMicroManagerConfigHandler sharedInstance].delegate = self;
    if (!mmAccount) {
        //异步下载
        NSString *strAccount = [[MCConfig sharedInstance] getAccount];
        [[MCMicroManagerConfigHandler sharedInstance] getMMAccountByAccount:strAccount defaultMMAccount:nil];
    }
    else {
        DLog(@"微管理默认账号:%@", mmAccount.acctId);
        //获取当前账号所有功能模块
        [[MCMicroManagerDAO sharedManager] deleteAll];
        [[MCMicroManagerConfigHandler sharedInstance] getCodeByUserCode:mmAccount.userCode acctId:mmAccount.acctId];

    }
    
    self.arrMicroManagerMenu = [[NSMutableArray alloc] init];
    [self.collectionView registerClass:[MCMicroManagerCell class] forCellWithReuseIdentifier:@"MicroMangerCell"];
    
    //global layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(52.5, 67.5)];
    [flowLayout setMinimumInteritemSpacing:14.0f];
    [flowLayout setSectionInset:UIEdgeInsetsMake(40, 35, 0, 35)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
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
    [super viewWillDisappear:animated];
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

//切换微管理账号
- (IBAction)switchMMAccount:(id)sender {
    //
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showWebBrowser"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        MCMicroManagerConfig *mmConfig = [self.arrMicroManagerMenu objectAtIndex:(indexPath.section*3) + indexPath.row];
        NSString *strPath = [[NSBundle mainBundle] pathForResource:mmConfig.pagePath ofType:@"html"];
        MCWebBrowserViewController *webBrowserVC = [segue destinationViewController];
        webBrowserVC.title = mmConfig.name;
        webBrowserVC.url = [NSURL fileURLWithPath:strPath];
    }
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (IBAction)unwindToMicroManagerVC:(UIStoryboardSegue *)unwindSegue
{
//    UIViewController* sourceViewController = unwindSegue.sourceViewController;
//    
//    if ([sourceViewController isKindOfClass:[BlueViewController class]])
//    {
//        NSLog(@"Coming from BLUE!");
//    }
//    else if ([sourceViewController isKindOfClass:[GreenViewController class]])
//    {
//        NSLog(@"Coming from GREEN!");
//    }
}

#pragma mark - UICollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ceil([self.arrMicroManagerMenu count] / 3.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrMicroManagerMenu.count == 0) {
        return 0;
    }
    else {
        return section == ceil([self.arrMicroManagerMenu count] / 3.0) - 1 ? ([self.arrMicroManagerMenu count] % 3 == 0 ? 3 : [self.arrMicroManagerMenu count] % 3) : 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCMicroManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MicroMangerCell" forIndexPath:indexPath];
    MCMicroManagerConfig *mmConfig = [self.arrMicroManagerMenu objectAtIndex:(indexPath.section*3 + indexPath.row)];
    cell.imageView.image = [UIImage imageNamed:mmConfig.iconImage];
    cell.labelName.text = mmConfig.name;
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showWebBrowser" sender:self];
//    [self developingAlert];
}

//微管理开发中提示
- (void)developingAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开发中..." message:@"该功能尚在开发，敬请期待" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
}

#pragma mark - MCMicroManager Delegate
- (void)didFinishGetMicroManagerAccount:(MCMicroManagerAccount *)mmAccount
{
    //获取当前账号所有功能模块
    DLog(@"--------didFinsishGetMMAccount-----------");
    DLog(@"微管理获取当前账号所有功能模块");
    if (!mmAccount.acctId) {
        //没有绑定默认微管理账号
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"当前没有移动办公账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];

    }
    else {
        [[MCMicroManagerDAO sharedManager] deleteAll];
        [[MCMicroManagerConfigHandler sharedInstance] getCodeByUserCode:mmAccount.userCode acctId:mmAccount.acctId];
    }
}

- (void)didFinishGetMicroManagerWidget
{
    //组装数据源
    DLog(@"--------didFinsishGetMMWidget-----------");
    DLog(@"微管理菜单组装数据源");
    NSArray *arrWidgetCodes = [[MCMicroManagerDAO sharedManager] queryAllCodes];
    NSArray *arrWidgetConfig = [[MCMicroManagerConfigDAO sharedManager] queryByWidgetCodes:arrWidgetCodes];
    for (MCMicroManagerConfig *obj in arrWidgetConfig) {
        if ([obj.upCode isEqualToString:@"-1"]) {
            [self.arrMicroManagerMenu addObject:obj];
        }
    }

    [self.collectionView reloadData];
}
@end