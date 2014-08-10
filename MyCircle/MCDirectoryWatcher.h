//
//  MCDirectoryWatcher.h
//  MyCircle
//
//  Created by Samuel on 8/9/14.
//
//

#import <Foundation/Foundation.h>

@class MCDirectoryWatcher;

@protocol MCDirectoryWatcherDelegate <NSObject>
@required
- (void)directoryDidChange:(MCDirectoryWatcher *)folderWatcher;
@end

@interface MCDirectoryWatcher : NSObject
{
	id <MCDirectoryWatcherDelegate> __weak delegate;
    
	int dirFD;
    int kq;
    
	CFFileDescriptorRef dirKQRef;
}
@property (nonatomic, weak) id <MCDirectoryWatcherDelegate> delegate;

+ (MCDirectoryWatcher *)watchFolderWithPath:(NSString *)watchPath delegate:(id<MCDirectoryWatcherDelegate>)watchDelegate;
- (void)invalidate;
@end
