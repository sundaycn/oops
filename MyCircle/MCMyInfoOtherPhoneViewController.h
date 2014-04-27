//
//  MCMyInfoOtherPhoneViewController.h
//  MyCircle
//
//  Created by Samuel on 4/23/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMyInfoModifyDelegate.h"

@interface MCMyInfoOtherPhoneViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *strOtherPhone;
@property (nonatomic, strong) id<MCMyInfoModifyDelegate> myInfoModifyDelegate;

@end
