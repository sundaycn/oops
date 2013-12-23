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
#import "MCXmppHelper.h"

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

    //2b87d6
    //0x2b6bac
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
        self.tableView.backgroundColor = UIColorFromRGB(0x2b87d6);
    }
    else {
        self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //初始化
    MCBookBL *bookBL = [[MCBookBL alloc] init];
    MCBook *book = [bookBL findById:self.bookId];
    self.name = book.name;
    self.mobilePhone = book.mobilePhone;
    self.officePhone = book.officePhone;
    self.homePhone = book.homePhone;
    self.mobileShort = book.mobileShort;
    self.fax = book.faxNumber;
    self.email = book.email;
    self.position = book.position;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 2)
    {
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
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
        cell.backgroundColor = UIColorFromRGB(0x2b87d6);
        }
        else {
            cell.backgroundColor = UIColorFromRGB(0xf7f7f7);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        UIImageView *imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(35, 30, 18, 22)];
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
            imageAvatar.image = [UIImage imageNamed:@"ContactsAvatar"];
        }
        else {
            imageAvatar.image = [UIImage imageNamed:@"ContactsAvatariOS6"];
        }
        [cell.contentView addSubview:imageAvatar];
        UILabel *labelName;
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
            labelName = [[UILabel alloc] initWithFrame:CGRectMake(63, 12, 0, 55)];
        }
        else {
            labelName = [[UILabel alloc] initWithFrame:CGRectMake(63, 19, 0, 55)];
        }
        labelName.backgroundColor = [UIColor clearColor];
        labelName.text = self.name;
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
            labelName.textColor = UIColorFromRGB(0xf7f7f7);
        }
        else {
            labelName.textColor = UIColorFromRGB(0x595959);
        }
        labelName.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:24];
        CGSize sizeName = [labelName.text sizeWithFont:labelName.font];
        CGRect newFrame = labelName.frame;
        newFrame.size.width = sizeName.width;
        labelName.frame = newFrame;
        [cell.contentView addSubview:labelName];
    }
    else if (indexPath.section == 2)
    {
        UIButton *buttonSendMsg = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 220, 30)];
        buttonSendMsg.backgroundColor = [UIColor whiteColor];
        [buttonSendMsg setTitle:@"发送消息" forState:UIControlStateNormal];
        [buttonSendMsg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonSendMsg addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buttonSendMsg];
    }
    else {
        if (indexPath.row != 0) {
            UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-30, 1)];
            if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
                separatorLineView.backgroundColor = UIColorFromRGB(0xf7f7f7);
            }
            else {
                separatorLineView.backgroundColor = UIColorFromRGB(0xd3d3d3);
                UIView *separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 1, tableView.frame.size.width-30, 1)];
                separatorLineView1.backgroundColor = UIColorFromRGB(0xffffff);
                [cell.contentView addSubview:separatorLineView1];
            }
            [cell.contentView addSubview:separatorLineView];
        }
        
        NSString *name;
        NSString *value;
        UIButton *buttonSMS;
        UIButton *buttonCALL;
        switch (indexPath.row) {
            case 0:
                name = @"手机：";
                value = self.mobilePhone;
                buttonSMS = [[UIButton alloc] initWithFrame:CGRectMake(212, 5, 30, 30)];
                if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
                    [buttonSMS setBackgroundImage:[UIImage imageNamed:@"SMS"] forState:UIControlStateNormal];
                }
                else {
                    [buttonSMS setBackgroundImage:[UIImage imageNamed:@"SMSiOS6"] forState:UIControlStateNormal];
                }
                [buttonSMS addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buttonSMS];
                
                buttonCALL = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 30, 30)];
                if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
                    [buttonCALL setBackgroundImage:[UIImage imageNamed:@"CALL"] forState:UIControlStateNormal];
                }
                else {
                    [buttonCALL setBackgroundImage:[UIImage imageNamed:@"CALLiOS6"] forState:UIControlStateNormal];
                }
                [buttonCALL addTarget:self action:@selector(callSomeone) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buttonCALL];
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
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
            labelName.textColor = UIColorFromRGB(0xf7f7f7);
        }
        else {
            labelName.textColor = UIColorFromRGB(0x619bda);
        }
        labelName.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:17];
        CGSize sizeName = [labelName.text sizeWithFont:labelName.font];
        CGRect newFrame = labelName.frame;
        newFrame.size.width = sizeName.width;
        labelName.frame = newFrame;
        [cell.contentView addSubview:labelName];

        UILabel *labelValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 0, 21)];
        labelValue.backgroundColor = [UIColor clearColor];
        labelValue.text = value;
        if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >=7) {
            labelValue.textColor = UIColorFromRGB(0xf7f7f7);
        }
        else {
            labelValue.textColor = UIColorFromRGB(0x666666);
        }
        labelValue.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        CGSize sizeValue = [labelValue.text sizeWithFont:labelValue.font];
        CGRect newValueFrame = labelValue.frame;
        newValueFrame.size.width = sizeValue.width;
        labelValue.frame = newValueFrame;
        labelValue.frame = CGRectMake(CGRectGetMaxX(labelName.frame)+5, labelValue.frame.origin.y, labelValue.frame.size.width, labelValue.frame.size.height);
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
        return  70;
    }
    else if (indexPath.section == 2)
    {
        return 50;
    }
    else {
        return 40;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 3;
//    }
//    
//    return 50;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    //隐藏没有内容的单元格的分割线
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 3)];
////    view.backgroundColor = [UIColor clearColor];
//    view.backgroundColor = UIColorFromRGB(0x2b87d6);
//    return view;
//}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"new" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonDidClick)];
    if ([[segue identifier] isEqualToString:@"sendMessage"])
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"消息"
                                                 style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(backMessageListVC)];
        MCChatSessionViewController *chatSessionVC = segue.destinationViewController;
        chatSessionVC.jid = [self.mobilePhone stringByAppendingString:@"@127.0.0.1"];
        MCXmppHelper *xmppHelper = [MCXmppHelper sharedInstance];
        xmppHelper.msgrev = chatSessionVC;
    }
}

//- (IBAction)backButtonDidClick
//{
//    DLog(@"Did Click!");
//}

- (void)sendSMS {
    DLog(@"SEND SMS OK");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"sms://" stringByAppendingString:self.mobilePhone]]];
}

- (void)callSomeone {
    DLog(@"CALL SOMEONE OK");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.mobilePhone]]];
}

- (void)sendMessage
{
    [self performSegueWithIdentifier:@"sendMessage" sender:self];
}

- (void)backMessageListVC
{
    DLog(@"contact detail VC: backMessageListVC");
    self.tabBarController.selectedIndex = 0;
}

@end
