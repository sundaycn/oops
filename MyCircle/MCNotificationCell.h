//
//  MCNotificationCell.h
//  MyCircle
//
//  Created by Samuel on 1/8/14.
//
//

#import <UIKit/UIKit.h>

@interface MCNotificationCell : UITableViewCell

@property (strong, nonatomic) UILabel *labelTime;
@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UITextView *textView;
//@property (strong, nonatomic) UIButton *buttonReadText;
@property (strong, nonatomic) UILabel *labelReadText;

@end
