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
        self.imageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        self.imageViewLogo.image = nil; //placeholder.png
        [self.contentView addSubview:self.imageViewLogo];
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 25)];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        self.labelTitle.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
        [self.contentView addSubview:self.labelTitle];
        
        self.labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 15)];
        self.labelDetail.backgroundColor = [UIColor clearColor];
        self.labelDetail.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
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
