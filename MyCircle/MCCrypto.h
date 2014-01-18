//
//  MCCrypto.h
//  MyCircle
//
//  Created by Samuel on 10/11/13.
//
//

#import <Foundation/Foundation.h>

@interface MCCrypto : NSObject

//加密
+ (NSString *)DESEncrypt:(NSString *)data WithKey:(NSString *)key;
//解密
+ (NSString *)DESDecrypt:(NSString *)data WithKey:(NSString *)key;

@end