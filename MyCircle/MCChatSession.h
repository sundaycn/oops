//
//  MCChatSession.h
//  MyCircle
//
//  Created by Samuel on 12/16/13.
//
//

#import <Foundation/Foundation.h>

@interface MCChatSession : NSObject

@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSString * lastmsg;
@property (nonatomic, strong) NSDate * time;

@end
