//
//  MCContensViewController.h
//  MyCircle
//
//  Created by Samuel on 12/1/13.
//
//

#import <UIKit/UIKit.h>
#import <Cordova/CDVViewController.h>

@interface MCContensViewController : UIViewController

@property (strong, nonatomic) CDVViewController *viewController;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *belongOrgId;

@end
