//
//  MCChatHistory.h
//  MyCircle
//
//  Created by Samuel on 12/16/13.
//
//

#import <Foundation/Foundation.h>

@interface MCChatHistory : NSObject

@property (nonatomic, strong) NSString * from;
@property (nonatomic, strong) NSString * to;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSString * isread;
@property (nonatomic, strong) NSString * type;

@end
