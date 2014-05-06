//
//  MCAvatarDelegate.h
//  MyCircle
//
//  Created by Samuel on 5/5/14.
//
//

#import <Foundation/Foundation.h>

@protocol MCAvatarDelegate <NSObject>

@required
- (void)updateAvatar:(NSData *)dataAvatar;

@end
