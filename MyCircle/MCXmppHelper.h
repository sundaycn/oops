//
//  MCXmppHelper.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

#import "MCMessageCountDelegate.h"
#import "MCMsgRevDelegate.h"

@class XMPPStream;
@class XMPPAutoPing;
@class XMPPReconnect;
//@class XMPPvCardTemp;
//@class XMPPvCardCoreDataStorage;
//@class XMPPvCardTempModule;
//@class XMPPvCardAvatarModule;
//@class XMPPRosterMemoryStorage;
//@class XMPPRoster;
//@class XMPPvCardTempModuleStorage;

@interface MCXmppHelper : NSObject

typedef void (^CallBackVoid) (void);
typedef void (^CallBackString) (NSString *str);
typedef void (^CallBackError) (NSError *err);

@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic,strong) XMPPReconnect *xmppReconnect;
//@property (nonatomic,strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
//@property (nonatomic,strong) XMPPvCardTempModule *xmppvCardTempModule;
//@property (nonatomic,strong) XMPPvCardTempModuleStorage *xmppvCardTempModuleStorage;
//@property (nonatomic,strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
//@property (nonatomic,strong) XMPPvCardTemp *xmppvCardTemp;
//@property (strong,nonatomic) XMPPvCardTemp *myVcardTemp;
//@property (strong,nonatomic) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;
//@property (strong,nonatomic) XMPPRoster *xmppRoster;
@property (strong,nonatomic) NSString *host;
@property (strong,nonatomic) NSString *domain;
@property (strong,nonatomic) NSTimer *timer;

@property (strong,nonatomic) CallBackVoid DidDisConnectCallBack;
@property (nonatomic,strong) id<MCMessageCountDelegate> msgcount;
@property (nonatomic,strong) id<MCMsgRevDelegate> msgrev;
+ (MCXmppHelper *)sharedInstance;

- (NSString *)connect:(NSString *)account host:(NSString *)host success:(CallBackVoid)DidConnect;

- (void)disconnect;

- (void)goOnline;

- (void)goOffline;

@end