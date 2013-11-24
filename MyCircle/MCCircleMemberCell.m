//
//  MCCircleMemberCell.m
//  MyCircle
//
//  Created by Samuel on 11/5/13.
//
//

#import "MCCircleMemberCell.h"

@implementation MCCircleMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lableName = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 100, 15)];
        self.lableName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lableName];
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(105, 8, 200, 12)];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        
        self.lablePhone = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, 100, 10)];
        self.lablePhone.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lablePhone];
        
        self.imageViewTree = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
        self.imageViewTree.image = [UIImage imageNamed:@"TreeLeafImage"];
        [self.contentView addSubview:self.imageViewTree];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.contentView.frame = CGRectMake(
                                        indentPoints,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - indentPoints,
                                        self.contentView.frame.size.height
                                        );
}

@end
