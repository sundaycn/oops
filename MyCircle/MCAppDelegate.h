//
//  MCAppDelegate.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import <UIKit/UIKit.h>

@class MCXmppHelper;

@interface MCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MCXmppHelper *xmppHepler;

@end