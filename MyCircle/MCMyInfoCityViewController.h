//
//  MCMyInfoCityViewController.h
//  MyCircle
//
//  Created by Samuel on 5/2/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMyInfoModifyDelegate.h"

@interface MCMyInfoCityViewController : UITableViewController
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *pName;
@property (nonatomic, strong) id<MCMyInfoModifyDelegate> myInfoModifyDelegate;
@end
