//
//  MCCircleDataHandler.h
//  MyCircle
//
//  Created by Samuel on 10/21/13.
//
//

#import <Foundation/Foundation.h>
#import "MCOrgBL.h"
#import "MCDeptBL.h"
#import "MCBookBL.h"
#import "MCDataObject.h"
#import "MCCrypto.h"

@interface MCCircleDataHandler : NSObject

+ (NSMutableArray *)getDataOfCircle;

+ (NSMutableArray *)getNodesOfOrg:(NSString *)orgId upDepartmentId:(NSString *)upDeptId;

//更新联系人数据
+ (void)updateContactsData:(NSString *)strAccount;

@end
