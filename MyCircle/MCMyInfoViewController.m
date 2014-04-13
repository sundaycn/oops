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

@interface MCMyInfoViewController ()
@property (strong, nonatomic) NSArray *arrItem;
@property (strong, nonatomic) NSArray *arrDetail;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MCMyInfo *myInfo;
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
    
    //配置数据
    //获取用户姓名
    NSString *strAccount = [[MCConfig sharedInstance] getAccount];
    self.myInfo = [[MCMyInfoDAO sharedManager] findByAccount:strAccount];
    self.arrItem = [[NSArray alloc] initWithObjects:@"头像", @"名字", @"性别", @"生日", @"地区", @"手机号码", @"其他电话", @"电子邮箱", nil];
    self.arrDetail = [[NSArray alloc] initWithObjects:@"Avatar", self.myInfo.userName, self.myInfo.gender, self.myInfo.birthdayString, self.myInfo.provinceId, self.myInfo.mobile, self.myInfo.phone, self.myInfo.email, nil];
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
            [self showActionSheet];
            break;
        case 1:
            [self performSegueWithIdentifier:@"showName" sender:self];
            break;
        case 2:
//            [self performSegueWithIdentifier:@"showAbout" sender:self];
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
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
        UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
        nameViewController.strName = selectedCell.detailTextLabel.text;
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    }
    else if (buttonIndex == 1) {
//        [self sendSMS];
    }
}

- (void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
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

@end
