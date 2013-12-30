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

@interface MCPortalViewController : UITableViewController <UIScrollViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *searchResults;
}

@property (strong, nonatomic) NSMutableArray *arrPortal;

@end
