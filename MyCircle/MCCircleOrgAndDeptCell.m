//
//  MCCircleOrgAndDeptCell.m
//  MyCircle
//
//  Created by Samuel on 11/5/13.
//
//

#import "MCCircleOrgAndDeptCell.h"

@implementation MCCircleOrgAndDeptCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lableText = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 320, 20)];
        self.lableText.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lableText];
        
        
        self.imageViewTree = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
//        self.imageViewTree.image = [UIImage imageNamed:@"TreeRootImage"];
        [self.contentView addSubview:self.imageViewTree];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

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