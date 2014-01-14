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
        
        self.labelTime = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 120, 10)];
        self.labelTime.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.labelTime];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, 280, 200)];
//        backgroundView.layer.cornerRadius = 0.5;
        backgroundView.layer.borderWidth = 1.0f;
        backgroundView.layer.borderColor = [[UIColor grayColor] CGColor];
        backgroundView.backgroundColor = UIColorFromRGB(0xfcfcfd);
        
        UIView *sepratorView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 280, 1)];
        sepratorView.backgroundColor = [UIColor grayColor];
        [backgroundView addSubview:sepratorView];
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 240, 55)];
        self.labelTitle.numberOfLines = 0;
        self.labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        self.labelTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.labelTitle.font = [UIFont systemFontOfSize:16];
        [backgroundView addSubview:self.labelTitle];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 240, 100)];
        self.textView.backgroundColor = UIColorFromRGB(0xfcfcfd);
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont systemFontOfSize:13];
        self.textView.editable = NO;
        [backgroundView addSubview:self.textView];
        
        /*self.buttonReadText = [[UIButton alloc] initWithFrame:CGRectMake(20, 170, 60, 20)];
        self.buttonReadText.backgroundColor = [UIColor clearColor];
        [self.buttonReadText setTitle:@"阅读正文" forState:UIControlStateNormal];
        self.buttonReadText.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.buttonReadText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backgroundView addSubview:self.buttonReadText];*/
        self.labelReadText = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 60, 20)];
        self.labelReadText.font = [UIFont systemFontOfSize:13];
        self.labelReadText.text = @"阅读正文";
        [backgroundView addSubview:self.labelReadText];
        
        [self.contentView addSubview:backgroundView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
