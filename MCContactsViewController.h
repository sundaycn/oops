//
//  MCContactsViewController.h
//  MyCircle
//
//  Created by Samuel on 10/20/13.
//
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "MCContactsDetailViewController.h"

@interface MCContactsViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *listContacts;

- (void)filterContentForSearchText:(NSString*)searchText;

@end
