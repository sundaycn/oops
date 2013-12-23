//
//  MCXmppHelper+Login.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import "MCXmppHelper.h"

@interface MCXmppHelper (Login)

@property (strong,nonatomic) CallBackVoid Loginsuccess;
@property (strong,nonatomic) CallBackError Loginfail;

- (NSString *)login:(NSUserDefaults *)userinfo success:(CallBackVoid)success fail:(CallBackError)fail;

@end
