//
//  MCMicroManagerVC.h
//  MyCircle
//
//  Created by Samuel on 5/21/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMicroManagerDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MCMicroManagerLoginVC : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) id<MCMicroManagerDelegate> delegate;
@end
