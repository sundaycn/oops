//
//  MCLoginHandler.h
//  MyCircle
//
//  Created by Samuel on 11/6/13.
//
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "MCCrypto.h"
#import "MCBookBL.h"
#import "MCDeptBL.h"
#import "MCOrgBL.h"

@interface MCLoginHandler : NSObject

+ (NSInteger)isLoginedSuccessfully:(NSString *)account password:(NSString *)pwd;

@end
