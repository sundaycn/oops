//
//  MCUtility.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import <Foundation/Foundation.h>

@interface MCUtility : NSObject

+ (NSString *)getCurrentTime;

+ (NSDate *)getCurrentTimeFromString:(NSString *)datetime;

+ (NSString *)getCurrentTimeFromString2:(NSDate *)datetime;

+ (NSString *)getWeakDay:(NSDate *)datetime;

+ (int)minusNowDate:(NSDate *)date;

+ (NSString *)getmessageTime:(NSDate *)date;

+ (NSString *)getFormatedTime:(NSDate *)date;

+ (UIImage *)imageFromText:(int)count image:(UIImage *)image;

@end
