//
//  XmppHelper+Message.h
//  iShareSomething
//
//  Created by Samuel on 12/11/13.
//  Copyright (c) 2013年 Samuel. All rights reserved.
//

#import "XmppHelper.h"
@class Message;
@interface XmppHelper (Message)

//保存最后一条消息
@property (nonatomic,strong) NSMutableDictionary *Messages;


- (void)sendMessage:(Message *)message;


@end
