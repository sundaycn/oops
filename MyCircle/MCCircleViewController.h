//
//  MCCircleViewController.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MCCircleViewController.h"
#import "RATreeView.h"
#import "MCDataObject.h"
#import "MCLoginHandler.h"
#import "MCCircleDataHandler.h"
#import "MCCircleOrgAndDeptCell.h"
#import "MCCircleMemberCell.h"
#import "MCContactsDetailViewController.h"
#import "MCViewController.h"
#import "MCBook.h"
#import "MCBookBL.h"
#import "MCCrypto.h"
#import "MCContactsSearchLibrary.h"
#import "SearchCoreManager.h"

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
