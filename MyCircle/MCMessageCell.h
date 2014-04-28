//
//  MCMessageCell.h
//  MyCircle
//
//  Created by Samuel on 12/10/13.
//
//

#import <UIKit/UIKit.h>

@interface MCMessageCell : UITableViewCell

@property (strong, nonatomic) UILabel *labelName;
@property (strong, nonatomic) UILabel *labelMessage;
@property (strong, nonatomic) UIImageView *imageViewIcon;
@property (strong, nonatomic) UILabel *labelTime;
@property (strong, nonatomic) UIImageView *imageViewAvatar;

@end
