//
//  MCMyInfoNameViewController.h
//  MyCircle
//
//  Created by Samuel on 4/8/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMyInfoModifyDelegate.h"

@interface MCMyInfoNameViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *strName;
@property (nonatomic, strong) id<MCMyInfoModifyDelegate> myInfoModifyDelegate;
@end
