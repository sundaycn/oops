//
//  MCXmppHelper+Login.m
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import "MCXmppHelper+Login.h"
#import "MCCrypto.h"

@implementation MCXmppHelper (Login)

@dynamic Loginsuccess;
@dynamic Loginfail;
static const char* ObjectTagKey1 = "loginsuccess";
static const char* ObjectTagKey2 = "loginfail";

-(CallBackVoid)Loginsuccess{
    return objc_getAssociatedObject(self,ObjectTagKey1);
}
-(void)setLoginsuccess:(CallBackVoid)Loginsuccess{
    objc_setAssociatedObject(self,ObjectTagKey1,Loginsuccess,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CallBackError)Loginfail{
    return objc_getAssociatedObject(self,ObjectTagKey2);
}
-(void)setLoginfail:(CallBackError)Loginfail{
    objc_setAssociatedObject(self,ObjectTagKey2,Loginfail,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)login:(NSUserDefaults *)userinfo success:(CallBackVoid)success fail:(CallBackError)fail{
    self.Loginsuccess = success;
    self.Loginfail = fail;
    NSString *isconnect = [self connect:[[userinfo stringForKey:@"user"] stringByAppendingString:XMPP_DOMAIN] host:self.host success:^{
        //连接成功，就进行登陆
        DLog(@"ready to login");
        DLog(@"xmpp login username:%@", [userinfo stringForKey:@"user"]);
        DLog(@"xmpp login password:%@", [MCCrypto DESDecrypt:[userinfo stringForKey:@"password"] WithKey:DESENCRYPTED_KEY]);
        NSError *error = nil;
        [[self xmppStream] authenticateWithPassword:[MCCrypto DESDecrypt:[userinfo stringForKey:@"password"] WithKey:DESENCRYPTED_KEY] error:&error];
//        if(error != nil)
//        {
//            [self disconnect];
//            self.Loginfail(error);
//        }
    }];
    if([isconnect isEqualToString:@"Y"]){
        DLog(@"xmpp conn successfully");
        return nil;
    }else{
        DLog(@"xmpp conn failed");
        //连接失败启动周期性重连定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60
                                                      target:self
                                                    selector:@selector(loginPeriodically:)
                                                    userInfo:userinfo
                                                     repeats:YES];
        return isconnect;
    }
}

//验证失败后调用
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    //关闭定时器
    [self.timer invalidate];
    self.timer = nil;
    DLog(@"not authenticated");
    NSError *err = [[NSError alloc] initWithDomain:@"MyCircle" code:-100 userInfo:@{@"detail": @"not-authorized"}];
    self.Loginfail(err);
    [self disconnect];
}

//验证成功后调用
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //关闭定时器
    [self.timer invalidate];
    self.timer = nil;
    //上线
    [self goOnline];
    //回调函数
    self.Loginsuccess();
}

- (void)loginPeriodically:(NSUserDefaults *)userinfo
{
    NSString *isconnect = [self connect:[[userinfo stringForKey:@"user"] stringByAppendingString:XMPP_DOMAIN] host:self.host success:^{
        //连接成功，就进行登陆
        DLog(@"ready to login");
        DLog(@"xmpp login username:%@", [userinfo stringForKey:@"user"]);
        DLog(@"xmpp login password:%@", [MCCrypto DESDecrypt:[userinfo stringForKey:@"password"] WithKey:DESENCRYPTED_KEY]);
        NSError *error = nil;
        [[self xmppStream] authenticateWithPassword:[MCCrypto DESDecrypt:[userinfo stringForKey:@"password"] WithKey:DESENCRYPTED_KEY] error:&error];
    }];
    if([isconnect isEqualToString:@"Y"]){
        DLog(@"xmpp conn successfully periodically");
    }else{
        DLog(@"xmpp conn failed periodically");
    }
}

@end
