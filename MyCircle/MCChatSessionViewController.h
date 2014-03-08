//
//  MCChatSessionViewController.h
//  MyCircle
//
//  Created by Samuel on 12/11/13.
//
//

#import <UIKit/UIKit.h>
#import <JSMessagesViewController/JSMessagesViewController.h>
#import "MCMsgRevDelegate.h"

@interface MCChatSessionViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource, MCMsgRevDelegate, UINavigationControllerDelegate>
{
    NSString *myJid;
    NSDate *timeOfFirstMessage;
    BOOL refreshControlVisable;
}

@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *buddyName;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *msgType;

@end
