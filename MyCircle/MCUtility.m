//
//  MCUtility.m
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import "MCUtility.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>

@implementation MCUtility

+ (NSString *)checkAndUpdateVersion
{
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:@"TcmContactClientVersion/tcmcontactclientversion!checkInBySyncAjax.action"]];
    ASIFormDataRequest *versionRequest = [ASIFormDataRequest requestWithURL:url];
    [versionRequest addPostValue:@"002" forKey:@"clientType"];
    [versionRequest addPostValue:[self versionBuild] forKey:@"versionCode"];
    [versionRequest setTimeOutSeconds:10];
    [versionRequest startSynchronous];
    
    NSError *error = [versionRequest error];
    if (!error) {
        NSData *response  = [versionRequest responseData];
        //判断服务器返回结果
        NSDictionary *dictVersionResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        NSString *strLoginResult = [NSString stringWithFormat:@"%@",[[dictVersionResponse objectForKey:@"root"] objectForKey:@"hasClientNewest"]];
        BOOL hasNewVersion = [strLoginResult isEqualToString:@"1"];
        if (hasNewVersion) {
            return [NSString stringWithFormat:@"%@", [[dictVersionResponse objectForKey:@"root"] objectForKey:@"clientDownloadUrl"]];
        }
    }

    return nil;
}
+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}
+ (NSString *)build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}
+ (NSString *)versionBuild
{
    NSString *version = [self appVersion];
    NSString *build = [self build];
    
    NSString *versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}

//获取当前时间
+(NSString *)getCurrentTime{
    
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:nowUTC];
}

//将字符串时间转换为Date类型。 格式:MMM dd, yyyy, h:mm:ss a
+(NSDate *)getCurrentTimeFromString:(NSString *)datetime{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"MMM dd, yyyy, h:mm:ss a"];
    NSDate* inputDate = [inputFormatter dateFromString:datetime];
    return inputDate;
}

//传来的参数，若时间为今天，返回HH:MM
//若时间在7天之内，返回星期几
//若时间大于7天，则返回MM-dd 月-日
+(NSString *)getmessageTime:(NSDate *)date{
    if([self minusNowDate:date]==0){
        return [self getCurrentTimeFromString2:date];
    }
    else if([self minusNowDate:date]>0 && [self minusNowDate:date]<6 ){
        return [self getWeakDay:date];
    }else {
        return [self getCurrentTimeFromString3:date];
    }
    
}

//MM-dd
+(NSString *)getCurrentTimeFromString3:(NSDate *)datetime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:datetime];
    return currentDateStr;
}

//HH:MM
+(NSString *)getCurrentTimeFromString2:(NSDate *)datetime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:datetime];
    return currentDateStr;
}

//返回传来的时间是星期几
+(NSString *)getWeakDay:(NSDate *)datetime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:datetime];
    switch ([comps weekday]) {
        case 1:
            return @"星期天";break;
        case 2:
            return @"星期一";break;
        case 3:
            return @"星期二";break;
        case 4:
            return @"星期三";break;
        case 5:
            return @"星期四";break;
        case 6:
            return @"星期五";break;
        case 7:
            return @"星期六";break;
        default:
            return @"未知";break;
    }
}

//传来的日期和当前时间相隔几天
+(int)minusNowDate:(NSDate *)date{
    NSDate *now=[NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:now  options:0];
    int days = [comps day];
    return days;
}

//格式化指定时间，输出格式为yyyy年MM月dd日 HH:mm:ss
+ (NSString *)getFormatedTime:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy年MM月dd日' 'HH:mm:ss";
    return [fmt stringFromDate:date];
}

//气泡中添加数字，提醒有几条消息
+(UIImage *)imageFromText:(int)count image:(UIImage *)image{
    UIImage *myImage = image;
    NSString *myWatermarkText = [NSString stringWithFormat:@"%d",count];
    UIImage *watermarkedImage = nil;
    
    UIGraphicsBeginImageContext(myImage.size);
    [myImage drawAtPoint: CGPointZero];
    UIColor *redColor=[UIColor whiteColor];
    [redColor set];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
    if(count<10) {
        [myWatermarkText drawAtPoint: CGPointMake(22, 10) withFont: font];
    }else if(count<100){
        [myWatermarkText drawAtPoint: CGPointMake(18, 10) withFont: font];
    }else if(count<999){
        [myWatermarkText drawAtPoint: CGPointMake(10, 10) withFont: font];
    }else{
        [@"..." drawAtPoint: CGPointMake(18, 10) withFont: font];
    }
    watermarkedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkedImage;
}

@end
