//
//  MCPullToRefreshManager.m
//  MyCircle
//
//  Created by Samuel on 1/2/14.
//
//

#import "MCPullToRefreshManager.h"

CGFloat const kAnimationDuration = 0.2f;

@interface MCPullToRefreshManager()

@end

@implementation MCPullToRefreshManager

//@synthesize pullToRefreshView = _pullToRefreshView;
//@synthesize table = _table;
//@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Instance initialization

/*
 * Initializes the manager object with the information to link view and table
 */
- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UIBubbleTableView *)table delegate:(id<MCPullToRefreshManagerDelegate>)delegate {
    
    if (self = [super init])
    {
        self.chatPullToRefreshDelegate = delegate;
        self.table = table;
        self.pullToRefreshView = [[MCPullToRefreshView alloc] initWithFrame:CGRectMake(0.0f, -height, CGRectGetWidth([self.table frame]), height)];
        [self.table addSubview:self.pullToRefreshView];
    }
    
    return self;
}

#pragma mark -
#pragma mark Table view scroll management

/*
 * Checks state of control depending on tableView scroll offset
 */
- (void)tableViewScrolled {
    
    if (![self.pullToRefreshView isHidden] && ![self.pullToRefreshView isLoading]) {
        
        CGFloat offset = [self.table contentOffset].y;
        
        if (offset >= 0.0f) {
            
            [self.pullToRefreshView changeStateOfControl:MCPullToRefreshViewStateIdle withOffset:offset];
            
        } else if (offset <= 0.0f && offset >= -[self.pullToRefreshView fixedHeight]) {
            DLog(@"向下拉");
            [self.pullToRefreshView changeStateOfControl:MCPullToRefreshViewStatePull withOffset:offset];
            
        } else {
            DLog(@"释放");
            [self.pullToRefreshView changeStateOfControl:MCPullToRefreshViewStateRelease withOffset:offset];
        }
    }
}

/*
 * Checks releasing of the tableView
 */
- (void)tableViewReleased {
    
    if (![self.pullToRefreshView isHidden] && ![self.pullToRefreshView isLoading]) {
        
        CGFloat offset = [self.table contentOffset].y;
        
        if (offset <= 0.0f && offset < -[self.pullToRefreshView fixedHeight]) {
            
            [self.pullToRefreshView changeStateOfControl:MCPullToRefreshViewStateLoading withOffset:offset];
            
            UIEdgeInsets insets = UIEdgeInsetsMake([self.pullToRefreshView fixedHeight], 0.0f, 0.0f, 0.0f);
            
            [UIView animateWithDuration:kAnimationDuration animations:^{
                
                [self.table setContentInset:insets];
            }];
            
            DLog(@"pullToRefreshTriggered");
            [self.chatPullToRefreshDelegate pullToRefreshTriggered:self];
        }
    }
}

/*
 * The reload of the table is completed
 */
- (void)tableViewReloadFinishedAnimated:(BOOL)animated {
    
    [UIView animateWithDuration:(animated ? kAnimationDuration : 0.0f) animations:^{
        
        [self.table setContentInset:UIEdgeInsetsZero];
        
    } completion:^(BOOL finished) {
        
        [self.pullToRefreshView setLastUpdateDate:[NSDate date]];
        [self.pullToRefreshView changeStateOfControl:MCPullToRefreshViewStateIdle withOffset:CGFLOAT_MAX];
    }];
}

#pragma mark -
#pragma mark Properties

/*
 * Sets the pull-to-refresh view visible or not. Visible by default
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible {
    
    [self.pullToRefreshView setHidden:!visible];
}

@end