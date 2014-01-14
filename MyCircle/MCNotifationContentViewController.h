//
//  MCNotifationContentViewController.h
//  MyCircle
//
//  Created by Samuel on 1/13/14.
//
//

#import <UIKit/UIKit.h>

@interface MCNotifationContentViewController : UIViewController

@property (strong,nonatomic) NSString *msgUrl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
