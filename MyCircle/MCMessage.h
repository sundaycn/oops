//
//  MCMessage.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import <Foundation/Foundation.h>

@interface MCMessage : NSObject

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *isread;

@end