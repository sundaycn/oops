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
@required
- (void)didFinishGetMicroManagerAccount:(MCMicroManagerAccount *)mmAccount;
- (void)didFinishGetMicroManagerWidget;
@end
