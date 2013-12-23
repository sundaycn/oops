//
//  XmppHelper+Roster.h
//  iShareSomething
//
//  Created by Samuel on 12/11/13.
//  Copyright (c) 2013年 Samuel. All rights reserved.
//

#import "XmppHelper.h"

@interface XmppHelper (Roster)

@property (nonatomic,strong) NSMutableArray *Rosters;


-(void)SubstripteUser:(Boolean)issubscribe user:(NSString *)user;
-(void)addFriend:(NSString *)user;
@end
