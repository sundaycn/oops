//
//  MCMyInfoViewController.m
//  MyCircle
//
//  Created by Samuel on 1/19/14.
//
//

#import "MCMyInfoViewController.h"
#import "MCMyInfoNameViewController.h"
#import "MCConfig.h"
#import "MCMyInfoDAO.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MCMyInfoAvatarCell.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "MCMyInfoOtherPhoneViewController.h"
#import "MCMyInfoEmailViewController.h"

@interface MCMyInfoViewController ()
@property (nonatomic, strong) NSString *strAccount;
@property (strong, nonatomic) NSArray *arrItem;
@property (strong, nonatomic) NSMutableArray *arrDetail;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MCMyInfo *myInfo;
@property (nonatomic, strong) NSArray *arrGender;
@property (nonatomic, strong) UIActionSheet *actionSheetForAvatar;
@property (nonatomic, strong) UIActionSheet *actionSheetForGender;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *birthdayPicker;
@property (nonatomic, strong) UIToolbar *doneToolbar;
@end

@implementation MCMyInfoViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"个人资料";
    self.tableView.backgroundColor = UIColorFromRGB(0xd5d5d5);
    self.tableView.separatorColor = UIColorFromRGB(0xd5d5d5);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    self.tableView.opaque = NO;

    //获取用户姓名
    self.strAccount = [[MCConfig sharedInstance] getAccount];
    self.myInfo = [[MCMyInfoDAO sharedManager] findByAccount:self.strAccount];
    //配置数据源
    self.arrItem = [[NSArray alloc] initWithObjects:@"头像", @"名字", @"性别", @"生日", @"地区", @"手机号码", @"其他电话", @"电子邮箱", nil];
    self.arrDetail = [[NSMutableArray alloc] initWithObjects:@"Avatar", self.myInfo.userName, self.myInfo.gender, self.myInfo.birthdayString, self.myInfo.provinceId, self.myInfo.mobile, self.myInfo.phone, self.myInfo.email, nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.arrItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"MyInfoAvatarCell";
        MCMyInfoAvatarCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            cell1 = [[MCMyInfoAvatarCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell1.labelName.text = [self.arrItem objectAtIndex:indexPath.row];
        cell1.imageViewAvatar.image = [UIImage imageWithData:self.myInfo.avatarImage];
        
        return cell1;
    }
    else {
        static NSString *CellIdentifier = @"MyInfoOtherCell";
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell2.detailTextLabel.numberOfLines = 0;
//            cell2.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
//            [cell2.detailTextLabel sizeToFit];
        }
        
        cell2.textLabel.text = [self.arrItem objectAtIndex:indexPath.row];
        cell2.detailTextLabel.text = [self.arrDetail objectAtIndex:indexPath.row];

        return cell2;
    }

    //点击头像查看大图
//    if (indexPath.row == 0) {
//        [labelValue setUserInteractionEnabled:YES];
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet)];
//        [tapGestureRecognizer setNumberOfTapsRequired:1];
//        [labelValue addGestureRecognizer:tapGesture
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    
    return 44;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = UIColorFromRGB(0xd8d8d8);
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    switch (indexPath.row) {
        case 0:
            //拍摄头像或从相册中选择头像
            [self showActionSheetForAvatar];
            break;
        case 1:
            [self performSegueWithIdentifier:@"showName" sender:self];
            break;
        case 2:
            [self showActionSheetForGender];
            break;
        case 3:
            [self showDatePickerForBirthday];
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            [self performSegueWithIdentifier:@"showOtherPhone" sender:self];
            break;
        case 7:
            [self performSegueWithIdentifier:@"showEmail" sender:self];
            break;
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showName"]) {
        MCMyInfoNameViewController *nameViewController = [segue destinationViewController];
        nameViewController.myInfoModifyDelegate = self;
        UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
        nameViewController.strName = selectedCell.detailTextLabel.text;
    }
    else if ([[segue identifier] isEqualToString:@"showOtherPhone"]) {
        MCMyInfoOtherPhoneViewController *otherPhoneViewController = [segue destinationViewController];
        otherPhoneViewController.myInfoModifyDelegate = self;
        UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
        otherPhoneViewController.strOtherPhone = selectedCell.detailTextLabel.text;
    }
    else if ([[segue identifier] isEqualToString:@"showEmail"]) {
        MCMyInfoEmailViewController *emailViewController = [segue destinationViewController];
        emailViewController.myInfoModifyDelegate = self;
        UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
        emailViewController.strEmail = selectedCell.detailTextLabel.text;
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.actionSheetForAvatar) {
        if (buttonIndex == 0) {
            [self takePhoto];
        }
        else if (buttonIndex == 1) {
            //        [self sendSMS];
        }
    }
    else if (actionSheet == self.actionSheetForGender)
    {
        [self updateGender:buttonIndex];
    }
    
    //刷新tableView显示最新数据
    [self.tableView reloadData];
}

- (void)showActionSheetForAvatar
{
    self.actionSheetForAvatar = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    self.actionSheetForAvatar.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheetForAvatar showInView:self.view];
}

- (void)takePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *media = [UIImagePickerController
                          availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        
        if ([media containsObject:(NSString*)kUTTypeImage] == YES) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
            
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设备不支持"
                                                            message:@"该设备相机不支持拍摄静态照片"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法拍照"
                                                        message:@"该设备没有摄像头"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showActionSheetForGender
{
    self.actionSheetForGender = [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"男", @"女", nil];
    self.actionSheetForGender.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheetForGender showInView:self.view];
}

- (void)updateGender:(NSInteger)index
{
    //没修改不提交
    NSString *selectedGender = index == 0 ? @"男" : @"女";
    if ([self.arrDetail[2] isEqualToString:selectedGender]) {
        return;
    }
    
    //密码
    NSString *strPassword = [[MCConfig sharedInstance] getCipherPassword];
    NSString *strInfo = [[@"{\"gender\":\"" stringByAppendingString:[selectedGender isEqualToString:@"男"] ? @"M" : @"F"] stringByAppendingString:@"\"}"];
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!changeUserAttachInfoAjax.action"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:self.strAccount forKey:@"tel"];
    [request addPostValue:strPassword forKey:@"password"];
    [request addPostValue:strInfo forKey:@"info"];
    //同步请求
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[[dictResponse objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isOK = [strResult isEqualToString:@"1"];
        if (isOK) {
            DLog(@"个人资料－性别修改成功");
            //保存到本地
            MCMyInfo *myInfo = [[MCMyInfoDAO sharedManager] findByAccount:self.strAccount];
            myInfo.gender = selectedGender;
            [[MCMyInfoDAO sharedManager] insert:myInfo];
            //更新tableview的数据源
            self.arrDetail[2] = selectedGender;
            [self.tableView reloadData];
        }
        else {
            DLog(@"个人资料－性别修改失败");
        }
    }
}

//编辑生日
- (void)showDatePickerForBirthday
{
    self.doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 244, 320, 44)];
    self.doneToolbar.opaque = YES;
    self.doneToolbar.translucent = NO;
    self.doneToolbar.backgroundColor = [UIColor whiteColor];
    self.doneToolbar.tintColor = self.navigationController.navigationBar.barTintColor;
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelForSelectedBirthday)];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneForSelectedBirthday)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    fixedSpaceButtonItem.width = 200;
    self.doneToolbar.items = [NSArray arrayWithObjects:cancelButtonItem, spaceButtonItem, doneButtonItem, nil];

    self.birthdayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 288, 320, 216)];
    self.birthdayPicker.backgroundColor = [UIColor whiteColor];
    self.birthdayPicker.datePickerMode = UIDatePickerModeDate;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.birthdayPicker.minimumDate = [self.dateFormatter dateFromString:@"1900-01-01"];
    self.birthdayPicker.maximumDate = [NSDate date];
    self.birthdayPicker.date = self.birthdayPicker.maximumDate;
//    [birthdayPicker addTarget:self action:@selector(doneForSelectedBirthday:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.birthdayPicker];
    [self.view addSubview:self.doneToolbar];
}

//取消生日编辑
- (void)cancelForSelectedBirthday
{
    [self.birthdayPicker removeFromSuperview];
    [self.doneToolbar removeFromSuperview];
}

//保存生日编辑
- (void)doneForSelectedBirthday
{
    [self updateBirthday];
    [self.birthdayPicker removeFromSuperview];
    [self.doneToolbar removeFromSuperview];
}

//更新服务端和客户端生日数据
- (void)updateBirthday
{
    //没修改不提交
    NSString *selectedBirthday = [self.dateFormatter stringFromDate:self.birthdayPicker.date];
    if ([self.arrDetail[3] isEqualToString:selectedBirthday]) {
        return;
    }
    
    //密码
    NSString *strPassword = [[MCConfig sharedInstance] getCipherPassword];
    DLog(@"password:%@", strPassword);
    NSString *strInfo = [[@"{\"birthday\":\"" stringByAppendingString:selectedBirthday] stringByAppendingString:@"\"}"];
    NSString *strURL = [[NSString alloc] initWithString:[BASE_URL stringByAppendingString:@"Contact/contact!changeUserAttachInfoAjax.action"]];
    DLog(@"info:%@", strInfo);
    DLog(@"birthday string:%@", strURL);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addPostValue:self.strAccount forKey:@"tel"];
    [request addPostValue:strPassword forKey:@"password"];
    [request addPostValue:strInfo forKey:@"info"];
    //同步请求
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response  = [request responseData];
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        //判断服务器返回结果
        NSString *strResult = [NSString stringWithFormat:@"%@",[[dictResponse objectForKey:@"root"] objectForKey:@"result"]];
        BOOL isOK = [strResult isEqualToString:@"1"];
        if (isOK) {
            DLog(@"个人资料－生日修改成功");
            //保存到本地
            MCMyInfo *myInfo = [[MCMyInfoDAO sharedManager] findByAccount:self.strAccount];
            myInfo.birthdayString = selectedBirthday;
            [[MCMyInfoDAO sharedManager] insert:myInfo];
            //更新tableview的数据源
            self.arrDetail[3] = selectedBirthday;
            [self.tableView reloadData];
        }
        else {
            DLog(@"个人资料－生日修改失败");
        }
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    DLog(@"Media Info: %@", info);
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        //Save Photo to library only if it wasnt already saved i.e. its just been taken
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(photoTaken, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    //NSLog(@"Image:%@", image);
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"错误!"
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openGenderPicker
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 352, 320, 216)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    self.arrGender = [[NSArray alloc] initWithObjects:@"男", @"女", nil];
    //显示选中框
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
}

#pragma mark - UIPickerView Data Source
//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrGender count];
}

#pragma mark - UIPickerView Delegate
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrGender objectAtIndex:row];
}

//当用户选择某个row时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //
}

//当其在绘制row内容,需要row的高度时
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

#pragma mark MyInfoModify Delegate
//更新tableViewCell中detailValue的值
- (void)updateValueOfCell:(NSString *)newValue index:(NSUInteger)index
{
    self.arrDetail[index] = newValue;
    [self.tableView reloadData];
}


@end
