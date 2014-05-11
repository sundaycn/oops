//
//  MCMainViewController.h
//  MyCircle
//
//  Created by Samuel on 12/23/13.
//
//

#import <UIKit/UIKit.h>
#import "MCMessageCountDelegate.h"

@interface MCMainViewController : UITabBarController <MCMessageCountDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) BOOL isFirstLogined;

@end
