//
//  MCMyInfoViewController.h
//  MyCircle
//
//  Created by Samuel on 1/19/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMyInfoModifyDelegate.h"
#import <PEPhotoCropEditor/PECropViewController.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MCMyInfoViewController : UITableViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, PECropViewControllerDelegate, MCMyInfoModifyDelegate> {
    MBProgressHUD *HUD;
}


@end
