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

@interface MCChatSessionViewController : UIViewController <UIBubbleTableViewDataSource, MCMsgRevDelegate, MCPullToRefreshManagerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UITextView *textInputBox;
@property (strong, nonatomic) NSMutableArray *bubbleData;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *sessionTittle;
@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property (nonatomic, readwrite, strong) MCPullToRefreshManager *pullToRefreshManager;

- (IBAction)buttonSendMessage:(UIBarButtonItem *)sender;
//- (IBAction)textFieldShoudReturn:(UITextField *)sender;

@end
