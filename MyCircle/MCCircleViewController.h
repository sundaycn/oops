//
//  MCCircleViewController.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import <UIKit/UIKit.h>
#import "MCGlobal.h"
#import "MCCircleViewController.h"
#import "RATreeView.h"
#import "MCDataObject.h"
#import "MCCircleDataHandler.h"
#import "MCContactsDetailViewController.h"

@interface MCCircleViewController : UIViewController

@property (strong, nonatomic) NSString *bookId;
- (void)prepareShowCard:(NSNotification *)notification;

@end
