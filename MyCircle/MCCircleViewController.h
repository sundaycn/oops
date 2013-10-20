//
//  MCCircleViewController.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import <UIKit/UIKit.h>
#import "MCCircleViewController.h"
#import "RATreeView.h"
#import "MCDataObject.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MCCircleViewController : UITableViewController

@end
