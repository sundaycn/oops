//
//  MCContactsDetailViewController.h
//  MyCircle
//
//  Created by Samuel on 10/20/13.
//
//

#import <UIKit/UIKit.h>

@interface MCContactsDetailViewController : UITableViewController
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong, nonatomic) NSString *officePhone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *homePhone;
@property (strong, nonatomic) NSString *mobileShort;
@property (strong, nonatomic) NSString *fax;

@property (strong, nonatomic) NSString *bookId;

@end
