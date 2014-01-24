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
    NSArray *bookList = [bookBL findAll];
    
    for (MCBook *contact in bookList) {
        //初始化联系人搜索库
        NSMutableArray *phoneList = [[NSMutableArray alloc] init];
        if (contact.mobilePhone == nil && contact.deputyMobilePhone == nil) {
            [phoneList addObject:@""];
        }
        else if (contact.mobilePhone != nil && contact.deputyMobilePhone == nil) {
            [phoneList addObject:contact.mobilePhone];
        }
        else if (contact.mobilePhone == nil && contact.deputyMobilePhone != nil) {
            [phoneList addObject:contact.deputyMobilePhone];
        }
        else {
            [phoneList addObject:contact.mobilePhone];
            [phoneList addObject:contact.deputyMobilePhone];
        }

        [[SearchCoreManager share] AddContact:contact.searchId name:contact.name phone:phoneList];
    }
    
    DLog(@"初始化联系人搜索库成功");
}

@end
