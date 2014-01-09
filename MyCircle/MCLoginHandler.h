//
//  MCLoginHandler.h
//  MyCircle
//
//  Created by Samuel on 11/6/13.
//
//

#import <Foundation/Foundation.h>

@interface MCLoginHandler : NSObject

+ (NSInteger)isLoginedSuccessfully:(NSString *)account password:(NSString *)pwd;

@end
