//
//  MCPortalCell.m
//  MyCircle
//
//  Created by Samuel on 12/3/13.
//
//

#import "MCPortalCell.h"

@implementation MCPortalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        self.imageViewLogo.image = nil; //placeholder.png
        //圆角设置
        self.imageViewLogo.layer.cornerRadius = self.imageViewLogo.frame.size.width / 2;
        self.imageViewLogo.layer.masksToBounds = YES;
        //边框宽度及颜色设置
//        [self.imageViewLogo.layer setBorderWidth:0.5];
//        [self.imageViewLogo.layer setBorderColor:[UIColor grayColor].CGColor];
        //自动适应,保持图片宽高比
        self.imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
        //添加内阴影
//        self.imageViewLogo.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.imageViewLogo.layer.shadowOffset = CGSizeMake(2, 2);
//        self.imageViewLogo.layer.shadowRadius = 50.0;
//        self.imageViewLogo.layer.shadowOpacity = 0.7;

        [self.contentView addSubview:self.imageViewLogo];

        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 220, 15)];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        self.labelTitle.textColor = UIColorFromRGB(0x2f2e2e);
//        self.labelTitle.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
        self.labelTitle.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.labelTitle];

        self.imageViewAddr = [[UIImageView alloc] initWithFrame:CGRectMake(70, 37, 12, 12)];
        self.imageViewAddr.image = [UIImage imageNamed:@"PortalListAddrGrayIcon"];
        [self.contentView addSubview:self.imageViewAddr];
        
        self.labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(88, 35, 200, 15)];
        self.labelDetail.backgroundColor = [UIColor clearColor];
        self.labelDetail.textColor = UIColorFromRGB(0x4847474);
//        self.labelDetail.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
        self.labelDetail.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.labelDetail];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end