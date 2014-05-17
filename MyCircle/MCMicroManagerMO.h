//
//  MCMicroManager.h
//  MyCircle
//
//  Created by Samuel on 5/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCMicroManagerMO : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) int16_t defaultShow;
@property (nonatomic, assign) int16_t loginIfNeed;
@property (nonatomic, assign) int16_t isTodo;
@property (nonatomic, retain) NSString * belongPhone;
@property (nonatomic, assign) int32_t todoAmount;
@property (nonatomic, assign) int16_t sort;
@property (nonatomic, retain) NSString * belongAccountId;
@property (nonatomic, retain) NSString * belongAccountName;
@property (nonatomic, retain) NSString * belongUserId;
@property (nonatomic, retain) NSString * belongUserCode;
@property (nonatomic, retain) NSString * belongUserName;

@end
