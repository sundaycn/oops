//
//  MCDept.h
//  MyCircle
//
//  Created by Samuel on 10/18/13.
//
//

#import <Foundation/Foundation.h>

@interface MCDept : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * sort;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * syncFlag;
@property (nonatomic, strong) NSString * upDepartmentId;
@property (nonatomic, strong) NSString * belongOrgId;

@end
