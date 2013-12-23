//
//  XmppHelper+Login.h
//  iShareSomething
//
//  Created by Samuel on 12/11/13.
//  Copyright (c) 2013年 Samuel. All rights reserved.
//

#import "XmppHelper.h"

@interface XmppHelper (Login)

@property (strong,nonatomic) CallBackVoid Loginsuccess;
@property (strong,nonatomic) CallBackError Loginfail;

-(NSString *)Login:(NSDefaultUserInfo *)userinfo success:(CallBackVoid)success fail:(CallBackError)fail;


@end
