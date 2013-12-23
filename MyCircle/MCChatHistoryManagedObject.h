//
//  MCChatHistory.h
//  MyCircle
//
//  Created by Samuel on 12/12/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCChatHistoryManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * isread;

@end
