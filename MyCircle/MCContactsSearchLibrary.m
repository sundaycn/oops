//
//  MCContactsSearchLibrary.m
//  MyCircle
//
//  Created by Samuel on 11/13/13.
//
//

#import "MCContactsSearchLibrary.h"

@implementation MCContactsSearchLibrary

+ (void)initContactsSearchLibrary
{
    MCBookBL *bookBL = [[MCBookBL alloc] init];
    NSArray *bookList = [[bookBL findAll] copy];
    
    for (MCBook *book in bookList) {
        //初始化联系人搜索库
        NSMutableArray *phoneList = [[NSMutableArray alloc] init];
        if (book.mobilePhone == nil) {
            [phoneList addObject:@""];
        }
        else {
            [phoneList addObject:book.mobilePhone];
        }
        [[SearchCoreManager share] AddContact:book.searchId name:book.name phone:phoneList];
    }
    
    DLog(@"complete contacts search library initialization");
}

@end
