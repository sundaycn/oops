//
//  XmppHelper+Register.h
//  iShareSomething
//
//  Created by Samuel on 12/11/13.
//  Copyright (c) 2013年 Samuel. All rights reserved.
//

#import "XmppHelper.h"

@interface XmppHelper (Register)

@property (strong,nonatomic) CallBackVoid Regsuccess;
@property (strong,nonatomic) CallBackError Regfail;

-(NSString *)Register:(NSDefaultUserInfo *)userinfo success:(CallBackVoid)Success fail:(CallBackError)Fail;

@end
