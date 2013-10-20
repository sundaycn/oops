//
//  MCBookManagedObject.h
//  MyCircle
//
//  Created by Samuel on 10/16/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCBookManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSString * officePhone;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * syncFlag;
@property (nonatomic, retain) NSString * belongDepartmentId;
@property (nonatomic, retain) NSString * belongOrgId;

@end
