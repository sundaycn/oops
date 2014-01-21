//
//  MCNotificationCell.m
//  MyCircle
//
//  Created by Samuel on 1/8/14.
//
//

#import "MCNotificationCell.h"

@implementation MCNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
        self.labelTime = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 120, 10)];
        self.labelTime.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.labelTime];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, 280, 200)];
        backgroundImageView.image = [UIImage imageNamed:@"NewsBackgroundImage"];
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 240, 20)];
        self.labelTitle.numberOfLines = 0;
        self.labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        self.labelTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.labelTitle.font = [UIFont systemFontOfSize:16];
        [backgroundImageView addSubview:self.labelTitle];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, 240, 100)];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont systemFontOfSize:13];
        self.textView.editable = NO;
        [backgroundImageView addSubview:self.textView];
        
        /*self.buttonReadText = [[UIButton alloc] initWithFrame:CGRectMake(20, 170, 60, 20)];
        self.buttonReadText.backgroundColor = [UIColor clearColor];
        [self.buttonReadText setTitle:@"阅读正文" forState:UIControlStateNormal];
        self.buttonReadText.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.buttonReadText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backgroundView addSubview:self.buttonReadText];*/
        self.labelReadText = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 60, 20)];
        self.labelReadText.font = [UIFont systemFontOfSize:13];
        self.labelReadText.text = @"阅读正文";
        [backgroundImageView addSubview:self.labelReadText];
        
        [self.contentView addSubview:backgroundImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
