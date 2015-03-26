//
//  MCContactsDetailViewController.m
//  MyCircle
//
//  Created by Samuel on 10/20/13.
//
//

#import "MCContactsDetailViewController.h"
#import "MCMessageListViewController.h"
#import "MCChatSessionViewController.h"
#import "MCBook.h"
#import "MCBookBL.h"
#import "MCCrypto.h"
#import "MCConfig.h"

@interface MCContactsDetailViewController ()
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *mobilePhone;
@property (copy, nonatomic) NSString *deputyMobilePhone;
@property (copy, nonatomic) NSString *officePhone;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *homePhone;
@property (copy, nonatomic) NSString *mobileShort;
@property (copy, nonatomic) NSString *fax;

//@property (strong, nonatomic) NSArray *arrContactInfo;
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

    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);//bule 0x2b87d6
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //配置数据源
    MCBookBL *bookBL = [[MCBookBL alloc] init];
    MCBook *book = [bookBL findById:self.bookId];
    self.name = book.name;
    self.mobilePhone = book.mobilePhone;
    self.deputyMobilePhone = book.deputyMobilePhone;
    self.officePhone = book.officePhone;
    self.email = book.email;
    self.position = book.position;
    self.homePhone = book.homePhone;
    self.mobileShort = book.mobileShort;
    self.fax = book.faxNumber;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.bookId = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
        //remove NavigationBar shadow line
        for (UIView *view in self.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                UIView *shadowLineCover = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, 0.5)];
                shadowLineCover.backgroundColor = UIColorFromRGB(0x2b87d6);
                [self.navigationController.navigationBar addSubview:shadowLineCover];
                //            for (UIView *view2 in view.subviews) {
                //                if ([view2 isKindOfClass:[UIImageView class]] && view2.frame.size.height < 1) {
                //                    [view2 setHidden:YES];
                //                    break;
                //                }
                //            }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = UIColorFromRGB(0xf7f7f7);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 140)];
        headerImageView.image = [UIImage imageNamed:@"ContactsHeaderImage"];
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(133, 15.5, 54, 54)];
        avatarImageView.image = [UIImage imageNamed:@"ContactsDefaultAvatar"];
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2;
        avatarImageView.layer.masksToBounds = YES;
        [headerImageView addSubview:avatarImageView];

        [cell.contentView addSubview:headerImageView];

        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 0, 0)];
        labelName.backgroundColor = [UIColor clearColor];
        labelName.text = self.name;
        labelName.textColor = [UIColor whiteColor];
        labelName.font = [UIFont systemFontOfSize:17];
        [labelName sizeToFit];
//        CGSize sizeName = [labelName.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HiraKakuProN-W6" size:15]}];
        CGRect newNameFrame = labelName.frame;
        newNameFrame.origin.x = (self.tableView.frame.size.width - labelName.frame.size.width) / 2;
        labelName.frame = newNameFrame;
        [cell.contentView addSubview:labelName];
        
        UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(0, 95+newNameFrame.size.height, 0, 0)];
        labelPhone.backgroundColor = [UIColor clearColor];
        labelPhone.text = self.mobilePhone;
        labelPhone.textColor = [UIColor whiteColor];
        labelPhone.font = [UIFont systemFontOfSize:13];
        [labelPhone sizeToFit];
        CGRect newPhoneFrame = labelPhone.frame;
        newPhoneFrame.origin.x = (self.tableView.frame.size.width - labelPhone.frame.size.width) / 2;
        labelPhone.frame = newPhoneFrame;
        [cell.contentView addSubview:labelPhone];
        
        UIButton *buttonSMS = [[UIButton alloc] initWithFrame:CGRectMake(220, 30, 40, 40)];;
        [buttonSMS setBackgroundImage:[UIImage imageNamed:@"SMS"] forState:UIControlStateNormal];
        [buttonSMS addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buttonSMS];
        
        UIButton *buttonCALL = [[UIButton alloc] initWithFrame:CGRectMake(60, 30, 40, 40)];
        [buttonCALL setBackgroundImage:[UIImage imageNamed:@"CALL"] forState:UIControlStateNormal];
        [buttonCALL addTarget:self action:@selector(callMainPhone) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buttonCALL];
    }
    else {
        if (indexPath.row != 0) {
            UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-30, 0.5)];
            separatorLineView.backgroundColor = UIColorFromRGB(0xd5d5d5);
            [cell.contentView addSubview:separatorLineView];
        }
        
        NSString *name;
        NSString *value;
        switch (indexPath.row) {
            case 0:
                name = @"手机副号：";
                value = self.deputyMobilePhone;
                break;
            case 1:
                name = @"办公电话：";
                value = self.officePhone;
                break;
            case 2:
                name = @"住宅电话：";
                value = self.homePhone;
                break;
            case 3:
                name = @"短号：";
                value = self.mobileShort;
                break;
            case 4:
                name = @"传真号码：";
                value = self.fax;
                break;
            case 5:
                name = @"电子邮箱：";
                value = self.email;
                break;
            case 6:
                name = @"工作职位：";
                value = self.position;
                break;
            default:
                break;
        }
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(35, 9, 0, 21)];
        labelName.backgroundColor = [UIColor clearColor];
        labelName.text = name;
        labelName.textColor = UIColorFromRGB(0x2b87d6);
//        labelName.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:17];
        labelName.font = [UIFont systemFontOfSize:17];
        [labelName sizeToFit];
        [cell.contentView addSubview:labelName];

        UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 0, 21)];
        labelValue.backgroundColor = [UIColor clearColor];
        labelValue.text = value;
        labelValue.textColor = UIColorFromRGB(0x2b87d6);
//        labelValue.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        labelValue.font = [UIFont systemFontOfSize:15];
        [labelValue sizeToFit];
        CGRect newValueFrame = labelValue.frame;
        newValueFrame.origin.x = CGRectGetMaxX(labelName.frame)+5;
        labelValue.frame = newValueFrame;
        if (indexPath.row == 0) {
            //手机副号
            [labelValue setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet)];
            [tapGestureRecognizer setNumberOfTapsRequired:1];
            [labelValue addGestureRecognizer:tapGestureRecognizer];
        }
        else if (indexPath.row >= 1 && indexPath.row <= 3) {
            //办公电话，住宅电话，短号
            [labelValue setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone)];
            [tapGestureRecognizer setNumberOfTapsRequired:1];
            [labelValue addGestureRecognizer:tapGestureRecognizer];
        }
        [cell.contentView addSubview:labelValue];
    }
    
    return cell;
}

//- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
//{
////    cell.backgroundColor = UIColorFromRGB(0x2b87d6);
////    cell.backgroundColor = UIColorFromRGB(0x000000);
////    cell.textLabel.backgroundColor = [UIColor clearColor];
////    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  140;
    }
    else {
        return 40;
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}

//- (IBAction)backButtonDidClick
//{
//    DLog(@"Did Click!");
//}

#pragma mark - UIActionsheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self callPhone];
    }
    else if (buttonIndex == 1) {
        [self sendSMS];
    }
}

- (void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拨打电话"
                                  otherButtonTitles:@"发送短信", nil];
    DLog(@"===================");
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (void)sendSMS {
    DLog(@"SEND SMS OK");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"sms://" stringByAppendingString:self.mobilePhone]]];
}

- (void)callPhone {
    NSString *number;
    NSInteger row = [self.tableView indexPathForSelectedRow].row;
    switch (row) {
        case 0:
            number = self.deputyMobilePhone;
            break;
        case 1:
            number = self.officePhone;
            break;
        case 2:
            number = self.homePhone;
            break;
        case 3:
            number = self.mobileShort;
            break;
        default:
            break;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:number]]];
}

- (void)callMainPhone
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.mobilePhone]]];
}

- (void)backMessageListVC
{
    DLog(@"contact detail VC: backMessageListVC");
    self.tabBarController.selectedIndex = 0;
}

@end
