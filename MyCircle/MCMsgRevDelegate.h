//
//  MCMsgRevDelegate.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import <Foundation/Foundation.h>
#import "MCMessage.h"

@protocol MCMsgRevDelegate <NSObject>

- (void)refreshmsg:(MCMessage *)msg;

@end
