//
//  MCWebBrowserViewController.h
//  MyCircle
//
//  Created by Samuel on 5/11/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMicroManagerDelegate.h"

@interface MCWebBrowserViewController : UIViewController <MCMicroManagerDelegate>
@property (nonatomic, assign) BOOL loadFromURL;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *strHtmlPath;
@end
