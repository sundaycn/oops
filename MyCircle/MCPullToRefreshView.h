//
//  MCPullToRefreshView.h
//  MyCircle
//
//  Created by Samuel on 1/2/14.
//
//

#import <Foundation/Foundation.h>

/**
 * Enumerates control's state
 */
typedef enum {
    
    MCPullToRefreshViewStateIdle = 0, //<! The control is invisible right after being created or after a reloading was completed
    MCPullToRefreshViewStatePull, //<! The control is becoming visible and shows "pull to refresh" message
    MCPullToRefreshViewStateRelease, //<! The control is whole visible and shows "release to load" message
    MCPullToRefreshViewStateLoading //<! The control is loading and shows activity indicator
    
} MCPullToRefreshViewState;

/**
 * Pull to refresh view. Its state, visuals and behavior is managed by an instance of `MNMPullToRefreshManager`.
 */
@interface MCPullToRefreshView : UIView

/**
 * Returns YES if the view is in Loading state.
 */
@property (nonatomic, readonly) BOOL isLoading;

/**
 * Last update date.
 */
@property (nonatomic, readwrite, strong) NSDate *lastUpdateDate;

/**
 * Fixed height of the view. This value is used to check the triggering of the refreshing.
 */
@property (nonatomic, readonly) CGFloat fixedHeight;

/**
 * Changes the state of the control depending in state and offset values.
 *
 * Values of *MNMPullToRefreshViewState*:
 *
 * - `MNMPullToRefreshViewStateIdle` The control is invisible right after being created or after a reloading was completed.
 * - `MNMPullToRefreshViewStatePull` The control is becoming visible and shows "pull to refresh" message.
 * - `MNMPullToRefreshViewStateRelease` The control is whole visible and shows "release to load" message.
 * - `MNMPullToRefreshViewStateLoading` The control is loading and shows activity indicator.
 *
 * @param state The state to set.
 * @param offset The offset of the table scroll.
 */
- (void)changeStateOfControl:(MCPullToRefreshViewState)state withOffset:(CGFloat)offset;

@end
