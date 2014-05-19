//
//  MCWebBrowserViewController.h
//  MyCircle
//
//  Created by Samuel on 5/11/14.
//
//

#import <UIKit/UIKit.h>

@interface MCWebBrowserViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (nonatomic, strong) NSString *strHtmlPath;
@end
