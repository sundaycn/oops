//
//  MCPullToRefreshManager.h
//  MyCircle
//
//  Created by Samuel on 1/2/14.
//
//

#import <Foundation/Foundation.h>
#import "MCPullToRefreshManagerDelegate.h"
#import "MCPullToRefreshView.h"
#import <UIBubbleTableView/UIBubbleTableView.h>

/**
 * Manager that plays Mediator role and manages relationship between a pull-to-refresh view and its associated table.
 */
@interface MCPullToRefreshManager : NSObject

/*
 * The pull-to-refresh view to add to the top of the table.
 */
@property (nonatomic, strong) MCPullToRefreshView *pullToRefreshView;

/*
 * Table view in which pull to refresh view will be added.
 */
@property (nonatomic, strong) UIBubbleTableView *table;

/*
 * Client object that observes changes in the pull-to-refresh.
 */
@property (nonatomic, strong) id<MCPullToRefreshManagerDelegate> chatPullToRefreshDelegate;

/**
 * Initializes the manager object with the information to link view and table.
 *
 * @param height The height that the pull-to-refresh view will have. This will be the `fixedHeight` used to trigger the refreshing.
 * @param table Table view to link pull-to-refresh view to.
 * @param client The client that will observe chnages in the view.
 */
- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UIBubbleTableView *)table delegate:(id<MCPullToRefreshManagerDelegate>)delegate;

/**
 * Sets the pull-to-refresh view visible or not. Visible by default.
 *
 * @param visible YES to make it visible.
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible;

/**
 * Checks the state of the pull to refresh view depending on the table's offset
 */
- (void)tableViewScrolled;

/**
 * Checks releasing of the table to trigger refreshing.
 */
- (void)tableViewReleased;

/**
 * Indicates that the reload of the table is completed.
 *
 * @param animated YES to animate the transition from Loading state to Idle state.
 */
- (void)tableViewReloadFinishedAnimated:(BOOL)animated;

@end
