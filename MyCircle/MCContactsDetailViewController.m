//
//  MCContactsDetailViewController.m
//  MyCircle
//
//  Created by Samuel on 10/20/13.
//
//

#import "MCContactsDetailViewController.h"

@interface MCContactsDetailViewController ()

@end

@implementation MCContactsDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColorFromRGB(0x3d97e9);

    //初始化
    MCBookBL *bookBL = [[MCBookBL alloc] init];
    MCBook *book = [bookBL findById:self.bookId];
    [self.name setText:[MCCrypto DESDecrypt:book.name WithKey:DESDECRYPTED_KEY]];
    [self.mobilePhone setText:[MCCrypto DESDecrypt:book.mobilePhone WithKey:DESDECRYPTED_KEY]];
    [self.officePhone setText:[MCCrypto DESDecrypt:book.officePhone WithKey:DESDECRYPTED_KEY]];
    [self.position setText:[MCCrypto DESDecrypt:book.position WithKey:DESDECRYPTED_KEY]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.bookId = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //remove NavigationBar shadow line
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            for (UIView *view2 in view.subviews) {
                if ([view2 isKindOfClass:[UIImageView class]] && view2.frame.size.height < 1) {
                    [view2 setHidden:YES];
                    break;
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else {
        return 7;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
//    }
//    //cell.textLabel.center = [cell.superview convertPoint:cell.center toView:cell];
//    if (indexPath.row == 0) {
//        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//
//    }
//    // Configure the cell...
////    if (cell == nil) {
////        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
////        UILabel *label = (UILabel *)[cell viewWithTag:1];
////        
////        CGRect cellFrame = [cell frame];
////        cellFrame.origin = CGPointMake(0, 0);
////        
////        
////        CGRect rect = CGRectInset(cellFrame, 100, 40);
////        label.frame = rect;
////        
////        if (label.frame.size.height >= 30)
////        {
////            cellFrame.size.height = 150 + label.frame.size.height -30;
////        }
////        else
////        {
////            cellFrame.size.height = 49;
////        }
////        [cell setFrame:cellFrame];
////        
////    }
//    
//    return cell;
//}

// 自绘分割线
//- (void)drawRect:(CGRect)rect
//{
//    DLog(@"drawRect");
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
//}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = UIColorFromRGB(0x3d97e9);
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //隐藏没有内容的单元格的分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (IBAction)sendSMS:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"sms://" stringByAppendingString:self.mobilePhone.text]]];
}

- (IBAction)callSomeone:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.mobilePhone.text]]];
}
@end
