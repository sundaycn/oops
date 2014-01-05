//
//  MCChatSessionViewController.h
//  MyCircle
//
//  Created by Samuel on 12/11/13.
//
//

#import <UIKit/UIKit.h>
#import <UIBubbleTableView/UIBubbleTableView.h>
#import <UIBubbleTableView/UIBubbleTableViewDataSource.h>
#import <UIBubbleTableView/NSBubbleData.h>
#import "MCMsgRevDelegate.h"
#import "MCPullToRefreshManagerDelegate.h"

@class MCPullToRefreshManager;

@interface MCChatSessionViewController : UIViewController <UIBubbleTableViewDataSource, MCMsgRevDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UITextView *textInputBox;
@property (strong, nonatomic) NSMutableArray *bubbleData;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *sessionTittle;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)buttonSendMessage:(UIBarButtonItem *)sender;
//- (IBAction)textFieldShoudReturn:(UITextField *)sender;

@end