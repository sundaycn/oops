//
//  MCUtility.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import <Foundation/Foundation.h>

@interface MCUtility : NSObject

+ (NSString *)checkAndUpdateVersion;

+ (NSString *)getCurrentTime;

+ (NSDate *)getDateFromString:(NSString *)datetime;

+ (NSString *)getCurrentTimeFromString2:(NSDate *)datetime;

+ (NSString *)getWeakDay:(NSDate *)datetime;

+ (int)minusNowDate:(NSDate *)date;

+ (NSString *)getMessageTime:(NSDate *)date;

+ (NSString *)getFormatedTime:(NSDate *)date;

+ (NSString *)versionBuild;

//+ (UIImage *)imageFromText:(int)count image:(UIImage *)image;

//获取top vc
+ (UIViewController*)getTopViewController;

@end
