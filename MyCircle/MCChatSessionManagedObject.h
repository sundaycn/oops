//
//  MCChatSession.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCChatSessionManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * lastmsg;
@property (nonatomic, retain) NSDate * time;

@end
