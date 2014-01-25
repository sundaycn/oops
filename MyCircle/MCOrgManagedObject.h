//
//  MCOrgManagedObject.h
//  MyCircle
//
//  Created by Samuel on 10/16/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCOrgManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, strong) NSString * version;

@end
