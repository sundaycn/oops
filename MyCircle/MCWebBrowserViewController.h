//
//  MCWebBrowserViewController.h
//  MyCircle
//
//  Created by Samuel on 5/11/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMicroManagerDelegate.h"

@interface MCWebBrowserViewController : UIViewController <UIGestureRecognizerDelegate, MCMicroManagerDelegate>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *url;
@end
