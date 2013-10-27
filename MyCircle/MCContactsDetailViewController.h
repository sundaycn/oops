//
//  MCContactsDetailViewController.h
//  MyCircle
//
//  Created by Samuel on 10/20/13.
//
//

#import <UIKit/UIKit.h>
#import "MCGlobal.h"
#import "MCBook.h"
#import "MCBookBL.h"
#import "MCCrypto.h"

@interface MCContactsDetailViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhone;
@property (weak, nonatomic) IBOutlet UILabel *officePhone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *homePhone;
@property (weak, nonatomic) IBOutlet UILabel *mobileShort;
@property (weak, nonatomic) IBOutlet UILabel *fax;


@property (strong, nonatomic) NSString *bookId;
- (IBAction)sendSMS:(UIButton *)sender;
- (IBAction)callSomeone:(UIButton *)sender;

@end
