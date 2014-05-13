//
//  MCMyInfoManagedObject.h
//  MyCircle
//
//  Created by Samuel on 5/13/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCMyInfoManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSData * avatarImage;
@property (nonatomic, retain) NSNumber * birthday;
@property (nonatomic, retain) NSString * birthdayString;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * countyId;
@property (nonatomic, retain) NSString * countyName;
@property (nonatomic, retain) NSNumber * createDate;
@property (nonatomic, retain) NSString * createDateString;
@property (nonatomic, retain) NSString * createId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * homepage;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * microBlog;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSNumber * modifyDate;
@property (nonatomic, retain) NSString * modifyDateString;
@property (nonatomic, retain) NSString * modifyId;
@property (nonatomic, retain) NSString * openfireAcct;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * postNo;
@property (nonatomic, retain) NSString * provinceId;
@property (nonatomic, retain) NSString * provinceName;
@property (nonatomic, retain) NSString * qqNo;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * trade;
@property (nonatomic, retain) NSString * userConcerns;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * weChatNo;

@end
