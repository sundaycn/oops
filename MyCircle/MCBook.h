//
//  MCBook.h
//  MyCircle
//
//  Created by Samuel on 10/16/13.
//
//

#import <Foundation/Foundation.h>

@interface MCBook : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * mobilePhone;
@property (nonatomic, strong) NSString * officePhone;
@property (nonatomic, strong) NSString * position;
@property (nonatomic, strong) NSNumber * sort;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * syncFlag;
@property (nonatomic, strong) NSString * belongDepartmentId;
@property (nonatomic, strong) NSString * belongOrgId;

@end
