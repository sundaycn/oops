//
//  MCCircleViewController.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MCGlobal.h"
#import "MCCircleViewController.h"
#import "RATreeView.h"
#import "MCDataObject.h"
#import "MCCircleDataHandler.h"
#import "MCContactsDetailViewController.h"

@interface MCCircleViewController : UIViewController <MBProgressHUDDelegate> {
    //事件进度提示窗
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSString *bookId;
- (void)prepareShowCard:(NSNotification *)notification;

@end
