//
//  MCMicroManagerViewController.m
//  MyCircle
//
//  Created by Samuel on 4/27/14.
//
//

#import "MCMicroManagerViewController.h"
#import "MCMicroManagerCell.h"

@interface MCMicroManagerViewController ()
@property (nonatomic ,strong) NSArray *arrIconMicroMianager;
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
    NSBundle *bundle  = [NSBundle mainBundle];
    NSString *strIconMicroManagerPlistPath = [bundle pathForResource:@"IconMicroManagerCollection" ofType:@"plist"];
    self.arrIconMicroMianager = [[NSArray alloc] initWithContentsOfFile:strIconMicroManagerPlistPath];
    
    [self.collectionView registerClass:[MCMicroManagerCell class] forCellWithReuseIdentifier:@"MicroMangerCell"];
    
    //global layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(52.5, 67.5)];
    [flowLayout setMinimumInteritemSpacing:14.0f];
    [flowLayout setSectionInset:UIEdgeInsetsMake(40, 35, 0, 35)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
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

#pragma mark - UICollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ceil([self.arrIconMicroMianager count] / 3.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == ceil([self.arrIconMicroMianager count] / 3.0) - 1 ? [self.arrIconMicroMianager count] % 3 : 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCMicroManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MicroMangerCell" forIndexPath:indexPath];
    NSDictionary *dictIcon = [self.arrIconMicroMianager objectAtIndex:(indexPath.section*3 + indexPath.row)];
    cell.imageView.image = [UIImage imageNamed:[dictIcon objectForKey:@"icon"]];
    cell.labelName.text = [dictIcon objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"select MicroManager Item:%@", [[self.arrIconMicroMianager objectAtIndex:(indexPath.section*3 + indexPath.row)] objectForKey:@"name"]);
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

@end
