//
//  MCMessageCell.h
//  MyCircle
//
//  Created by Samuel on 12/10/13.
//
//

#import <UIKit/UIKit.h>

@interface MCMessageCell : UITableViewCell{
    UIImageView *_userHead;
    UIImageView *_bageView;
    UILabel *_bageNumber;
    UILabel *_userNickname;
    UILabel *_messageConent;
    UILabel *_timeLable;
    UIImageView *_cellBkg;
}

//- (void)setUnionObject:(WCMessageUserUnionObject*)aUnionObj;
//- (void)setHeadImage:(NSString*)imageURL;

@property (strong, nonatomic) UILabel *labelName;
@property (strong, nonatomic) UILabel *labelMessage;
@property (strong, nonatomic) UILabel *labelTime;
@property (strong, nonatomic) UIImageView *imageViewAvatar;

@end
