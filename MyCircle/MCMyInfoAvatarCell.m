//
//  MCMyInfoAvatarCell.m
//  MyCircle
//
//  Created by Samuel on 4/9/14.
//
//

#import "MCMyInfoAvatarCell.h"

@implementation MCMyInfoAvatarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 250, 20)];
        self.labelName.backgroundColor = [UIColor clearColor];
        self.labelName.textColor = UIColorFromRGB(0x2f2e2e);
        self.labelName.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.labelName];
        
        self.imageViewAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(235, 5, 50, 50)];
        self.imageViewAvatar.image = [UIImage imageNamed:@"DefaultAvatar"];
        //圆角设置
        self.imageViewAvatar.layer.cornerRadius = self.imageViewAvatar.frame.size.width / 2;
        self.imageViewAvatar.layer.masksToBounds = YES;
        //边框宽度及颜色设置
        //        [self.imageViewLogo.layer setBorderWidth:0.5];
        //        [self.imageViewLogo.layer setBorderColor:[UIColor grayColor].CGColor];
        //自动适应,保持图片宽高比
        self.imageViewAvatar.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageViewAvatar];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
