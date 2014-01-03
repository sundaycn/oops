//
//  MCPullToRefreshManangerDelegate.h
//  MyCircle
//
//  Created by Samuel on 1/3/14.
//
//

#import <Foundation/Foundation.h>

@class MCPullToRefreshManager;
/**
 * Delegate protocol to implement by `MNMPullToRefreshManager` observers to keep track of changes in pull-to-refresh view
 * and its state.
 */
@protocol MCPullToRefreshManagerDelegate <NSObject>
/**
 * This is the same delegate method of `UIScrollViewDelegate` but required in `MNMPullToRefreshManagerClient` protocol
 * to warn about its implementation.
 *
 * In the implementation of this method you have to call `[MNMPullToRefreshManager tableViewScrolled]`
 * to indicate that the table is being scrolled.
 *
 * @param scrollView The scroll-view object in which the scrolling occurred.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 * This is the same delegate method of `UIScrollViewDelegate` but required in `MNMPullToRefreshClient` protocol
 * to warn about its implementation.
 *
 * In the implementation of this method you have to call `[MNMPullToRefreshManager tableViewReleased]`
 * to indicate that the table scroll stops and the dragging has ended.
 *
 * @param scrollView The scroll-view object that finished scrolling the content view.
 * @param decelerate YES if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/**
 * Tells client that refreshing has been triggered.
 *
 * After reload is completed don't miss call `[MNMPullToRefreshManager tableViewReloadFinishedAnimated:]` to indicate that the
 * view has to get back to the Idle initial state.
 *
 * @param manager The pull to refresh manager.
 */
- (void)pullToRefreshTriggered:(MCPullToRefreshManager *)manager;

@end
