//
//  MCXmppHelper+Message.m
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import "MCXmppHelper+Message.h"
#import <AudioToolbox/AudioToolbox.h>
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
    if(content != nil) {
        //1.封装收到的消息
        MCMessage *msg = [[MCMessage alloc] init];
        msg.message = content;
        msg.from = from;
        msg.to = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] bare];
        msg.isread = @"NO";
        if(sendtime != nil) {
            msg.date = [MCUtility getCurrentTimeFromString:sendtime];
        }else {
            msg.date = [NSDate date];
        }
        //2.将消息保存到会话表，保存最后一条收到的记录。
        //通知公告消息账号为XMPP_ADMIN_JID
        NSString *key;
        if ([msg.from isEqualToString:XMPP_ADMIN_JID]) {
            //消息头为WOQUANQUAN_CB462135_MSG则属于通知公告短信
            if ([[msg.message substringToIndex:[MSG_HEAD_NOTIFICATION length]] isEqualToString:MSG_HEAD_NOTIFICATION]) {
                DLog(@"通知公告消息");
                NSRange rangeMsgType = [msg.message rangeOfString:@"\"msgType\":\""];
                NSRange rangeToPhone = [msg.message rangeOfString:@"\",\"toPhone\""];
                NSString *strMsgType = [msg.message substringWithRange:NSMakeRange(rangeMsgType.location+rangeMsgType.length, rangeToPhone.location-rangeMsgType.location-rangeMsgType.length)];
                key = [msg.from stringByAppendingString:strMsgType];
            }
            else {
                DLog(@"未定义消息头");
                return;
            }
        }
        else {
            DLog(@"普通聊天消息");
            key = msg.from;
        }
        [self saveLastMessage:key msg:msg];
        [self saveLastMessageToDB:key content:msg.message time:msg.date];
        //3.将消息保存到历史记录表，标记为未读
        [self saveHistoryMessageToDB:msg];
        //4.消息计数器加1
        [self.msgcount resetMsgCount];
        if(self.msgrev != nil){
            [self.msgrev refreshmsg:msg];
        }
        //5.播放提示音(震动模式下为震动提示)
        AudioServicesPlaySystemSound(LOCAL_NOTIFICATION_SOUND_ID);
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

//删除最后一条聊天记录
- (void)removeLastMessage:(NSString *)key
{
    [self.Messages removeObjectForKey:key];
}
//删除所有聊天记录
- (void)removeAllMessages
{
    [self.Messages removeAllObjects];
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

//删除最后一条聊天记录
- (void)removeLastMessageFromDB:(NSString *)key
{
    MCChatSession *chatSession = [[MCChatSession alloc] init];
    chatSession.key = key;
    [[MCChatSessionDAO sharedManager] remove:chatSession];
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
    
    if ([msg.from isEqualToString:XMPP_ADMIN_JID]) {
        //消息头为WOQUANQUAN_CB462135_MSG则属于通知公告短信
        if ([[msg.message substringToIndex:[MSG_HEAD_NOTIFICATION length]] isEqualToString:MSG_HEAD_NOTIFICATION]) {
            NSRange rangeMsgType = [msg.message rangeOfString:@"\"msgType\":\""];
            NSRange rangeToPhone = [msg.message rangeOfString:@"\",\"toPhone\""];
            NSString *strMsgType = [msg.message substringWithRange:NSMakeRange(rangeMsgType.location+rangeMsgType.length, rangeToPhone.location-rangeMsgType.location-rangeMsgType.length)];
            chatHistory.type = strMsgType;
        }
        else {
            DLog(@"未定义消息头");
        }
    }
    else {
        chatHistory.type = MSG_TYPE_NORMAL_CHAT;
    }
    [[MCChatHistoryDAO sharedManager] insert:chatHistory];
}

@end
