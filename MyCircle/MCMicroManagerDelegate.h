//
//  MCMicroManagerDelegate.h
//  MyCircle
//
//  Created by Samuel on 5/16/14.
//
//

#import <Foundation/Foundation.h>

@class MCMicroManagerAccount;

@protocol MCMicroManagerDelegate <NSObject>
@optional
- (void)didFinishGetMicroManagerAccount:(MCMicroManagerAccount *)mmAccount;
- (void)didFinishGetMicroManagerWidget;
- (void)didfinishLogin;
@end
