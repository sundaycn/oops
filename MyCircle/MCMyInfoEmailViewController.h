//
//  MCMyInfoEmailViewController.h
//  MyCircle
//
//  Created by Samuel on 4/23/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMyInfoModifyDelegate.h"

@interface MCMyInfoEmailViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *strEmail;
@property (nonatomic, strong) id<MCMyInfoModifyDelegate> myInfoModifyDelegate;

@end
