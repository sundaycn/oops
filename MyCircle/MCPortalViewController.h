//
//  MCPortalViewController.h
//  MyCircle
//
//  Created by Samuel on 11/25/13.
//
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MCPortalDataHandler.h"
#import "MCPortalCell.h"
#import "MCContensViewController.h"

#define BASE_URL @"http://59.52.226.85:8888/EasyContactFY/"
#define IMAGE_SWITCH @"&needDownload=false&autoContentType=true"

@interface MCPortalViewController : UITableViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrPortal;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *belongOrgId;

@end
