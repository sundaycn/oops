//
//  MCXmppHelper+Message.m
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import "MCXmppHelper+Message.h"
#import "MCUtility.h"
#import "MCMessage.h"
#import "MCChatHistoryDAO.h"
#import "MCChatHistory.h"
#import "MCChatSessionDAO.h"
#import "MCChatSession.h"

@implementation MCXmppHelper (Message)

@dynamic Messages;
static const char* ObjectTagKey1 = "Messages";

- (NSMutableArray *)Messages{
    return objc_getAssociatedObject(self,ObjectTagKey1);
}

- (void)setMessages:(NSMutableArray *)Messages{
    objc_setAssociatedObject(self,ObjectTagKey1,Messages,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//收到消息后调用
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSString *content = message.body;
    NSString *sendtime = [[message elementForName:@"time"] stringValue];
    NSString *from = message.from.bareJID.bare;
    if(content != nil){
        //1.封装收到的消息
        MCMessage *msg = [[MCMessage alloc] init];
        msg.message = content;
        msg.from = from;
        msg.to = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] bare];
        msg.isread = @"NO";
        if(sendtime != nil){
            msg.date = [MCUtility getCurrentTimeFromString:sendtime];
        }else{
            msg.date = [NSDate date];
        }
        //2.将消息保存到会话表，保存最后一条收到的记录。
        [self saveLastMessage:msg.from msg:msg];
        [self saveLastMessageToDB:msg.from content:msg.message time:msg.date];
        //3.将消息保存到历史记录表，标记为未读
        [self saveHistoryMessageToDB:msg];
        //4.消息计数器加1
        [self.msgcount resetMsgCount];
        if(self.msgrev != nil){
            [self.msgrev refreshmsg:msg];
        }
    }
}

//发送消息
- (void)sendMessage:(MCMessage *)message
{
    if (message.message.length > 0) {
        /*
        XMPPMessage *xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:message.to]];
//        [xmppMessage addChild:[DDXMLNode elementWithName:@"body" stringValue:message.message]];
        [xmppMessage addBody:message.message];
        [self.xmppStream sendElement:xmppMessage];
        
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",_chatPerson.userId] domain:@"hcios.com" resource:@"ios"]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:message]];*/
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message.message];
        NSXMLElement *time = [NSXMLElement elementWithName:@"time"];
        [time setStringValue:[MCUtility getCurrentTime]];
        //生成XML消息文档
        NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [msg addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [msg addAttributeWithName:@"to" stringValue:message.to];
        //由谁发送
        [msg addAttributeWithName:@"from" stringValue:message.from];
        [msg addAttributeWithName:@"isread" stringValue:@"YES"];
        //组合
        [msg addChild:body];
        [msg addChild:time];
        XMPPMessage *xmppMessage = [XMPPMessage messageFromElement:msg];
        //发送消息
        [[self xmppStream] sendElement:xmppMessage];
        [self saveLastMessage:message.to msg:message];
        [self saveLastMessageToDB:message.to content:message.message time:message.date];
        [self saveHistoryMessageToDB:message];
    }
}

//保存最后一条聊天记录
- (void)saveLastMessage:(NSString *)key msg:(MCMessage *)msg
{
    if(!self.Messages){
        self.Messages = [[NSMutableDictionary alloc] init];
    }
    [self.Messages setObject:msg forKey:key];
}

//保存最后一条聊天记录到数据库
- (void)saveLastMessageToDB:(NSString *)key content:(NSString *)content time:(NSDate *)time
{
    MCChatSession *chatSession = [[MCChatSession alloc] init];
    chatSession.key = key;
    chatSession.lastmsg = content;
    chatSession.time = time;
    [[MCChatSessionDAO sharedManager] remove:chatSession];
    [[MCChatSessionDAO sharedManager] insert:chatSession];
}

//保存所有消息到数据库
- (void)saveHistoryMessageToDB:(MCMessage *)msg
{
    MCChatHistory *chatHistory = [[MCChatHistory alloc] init];
    chatHistory.from = msg.from;
    chatHistory.to = msg.to;
    chatHistory.message = msg.message;
    chatHistory.time = msg.date;
    chatHistory.isread = msg.isread;
    [[MCChatHistoryDAO sharedManager] insert:chatHistory];
}

@end
