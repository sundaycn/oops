//
//  MCPortalDataHandler.h
//  MyCircle
//
//  Created by Samuel on 11/25/13.
//
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>

@interface MCPortalDataHandler : NSObject

+ (NSArray *)getPortalList:(NSString *)pageSize pageNo:(NSString *)pageNo;

@end
