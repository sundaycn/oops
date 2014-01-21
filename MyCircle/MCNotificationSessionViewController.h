//
//  MCNotificationSessionViewController.h
//  MyCircle
//
//  Created by Samuel on 1/8/14.
//
//

#import <UIKit/UIKit.h>
#import "MCMsgRevDelegate.h"

@class ASINetworkQueue;

@interface MCNotificationSessionViewController : UITableViewController<MCMsgRevDelegate>
{
    NSString *myJid;
    NSDate *timeOfFirstMessage;
    BOOL refreshControlVisable;
}

@property (strong, nonatomic) NSString *msgType;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong) ASINetworkQueue *networkQueue;

@end