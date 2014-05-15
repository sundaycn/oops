//
//  MCMicroManagerConfig.h
//  MyCircle
//
//  Created by Samuel on 5/14/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCMicroManagerConfigMO : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) int16_t defaultShow;
@property (nonatomic, retain) NSString * iconImage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pagePath;
@property (nonatomic, assign) int16_t sort;
@property (nonatomic, assign) int16_t type;
@property (nonatomic, retain) NSString * upCode;

@end
