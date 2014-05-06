//
//  MCMicroManagerCell.m
//  MyCircle
//
//  Created by Samuel on 4/27/14.
//
//

#import "MCMicroManagerCell.h"

@implementation MCMicroManagerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
        [self.contentView addSubview:self.imageView];
        
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(1, 60, 52, 16)];
        self.labelName.textColor = UIColorFromRGB(0x5F646E);
        self.labelName.font = [UIFont systemFontOfSize:13];
//        self.labelName.text = @"个人事务";
//        [self.labelName sizeToFit];
//        DLog(@"label name frame origin x:%f", self.labelName.frame.origin.x);
//        DLog(@"label name frame origin y:%f", self.labelName.frame.origin.y);
//        DLog(@"label name frame size width:%f", self.labelName.frame.size.width);
//        DLog(@"label name frame size height:%f", self.labelName.frame.size.height);
        [self.contentView addSubview:self.labelName];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
