//
//  MCCircleViewController.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MCCircleViewController : UIViewController <MBProgressHUDDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    //事件进度提示窗
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSString *bookId;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) NSMutableArray *searchByName;
@property (strong, nonatomic) NSMutableArray *searchByPhone;

- (void)prepareShowCard:(NSNotification *)notification;

@end
