//
//  MCMicroManagerAccount.h
//  MyCircle
//
//  Created by Samuel on 5/15/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCMicroManagerAccountMO : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userCode;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * acctId;
@property (nonatomic, retain) NSString * acctName;
@property (nonatomic, retain) NSString * belongOrgId;
@property (nonatomic, retain) NSString * orgName;

@end
