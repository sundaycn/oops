//
//  MCMyInfoHandler.h
//  MyCircle
//
//  Created by Samuel on 4/4/14.
//
//

#import <Foundation/Foundation.h>

@interface MCMyInfoHandler : NSObject
+ (MCMyInfoHandler *)sharedInstance;

- (void)getMyInfo:(NSString *)strAccount password:(NSString *)cipherPwd;
/*
//提取地区－省名称
+ (NSString *)getProvinceNameById:(NSString *)pid;
//提取地区－市名称
+ (NSString *)getCityNameById:(NSString *)cid pid:(NSString *)pid;*/
@end
