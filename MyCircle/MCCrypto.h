//
//  MCCrypto.h
//  MyCircle
//
//  Created by Samuel on 10/11/13.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface MCCrypto : NSObject

//字符串转16进制
+ (NSString *)hexStringFromString:(NSString *)string;

//16进制字符串转换为NSData
+ (NSData*)dataFromHexString:(NSString*)hexString;

//NSData转换成16进制字符串
+ (NSString *)hexStringFromData:(NSData *)data;

//加密
+ (NSString *)DESEncrypt:(NSString *)data WithKey:(NSString *)key;
//解密
+ (NSString *)DESDecrypt:(NSString *)data WithKey:(NSString *)key;

@end