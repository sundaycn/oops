//
//  MCMyInfoModifyDelegate.h
//  MyCircle
//
//  Created by Samuel on 4/22/14.
//
//

#import <Foundation/Foundation.h>

@protocol MCMyInfoModifyDelegate <NSObject>

@required
- (void)updateValueOfCell:(NSString *)newValue index:(NSUInteger)index;

@end
