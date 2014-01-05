//
//  MCMessageCell.m
//  MyCircle
//
//  Created by Samuel on 12/10/13.
//
//

#import "MCMessageCell.h"

@implementation MCMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        /*
        _userHead =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        _userNickname=[[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        _messageConent=[[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        _timeLable=[[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        _cellBkg=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageListCellBkg"]]autorelease];
        _bageView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_badge"]]autorelease];
        _bageNumber=[[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        [_bageNumber setText:@"1"];
        
        
        [_userHead.layer setCornerRadius:8.0f];
        [_userHead.layer setMasksToBounds:YES];
        
        [_userNickname setFont:[UIFont boldSystemFontOfSize:15]];
        [_userNickname setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setTextColor:[UIColor lightGrayColor]];
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        
        [_timeLable setTextColor:[UIColor lightGrayColor]];
        [_timeLable setFont:[UIFont systemFontOfSize:15]];
        [_timeLable setBackgroundColor:[UIColor clearColor]];
        
        [_bageNumber setBackgroundColor:[UIColor clearColor]];
        [_bageNumber setTextAlignment:NSTextAlignmentCenter];
        [_bageNumber setTextColor:[UIColor whiteColor]];
        [_bageNumber setFont:[UIFont boldSystemFontOfSize:12]];
        
        // [self.contentView addSubview:_cellBkg];
        [self setBackgroundView:_cellBkg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_userNickname];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_timeLable];
        [self.contentView addSubview:_bageView];
        [_bageView addSubview:_bageNumber];
        //[self setAccessoryView:_timeLable];
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
         */
        self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 250, 15)];
        self.labelName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelName];
        
        self.labelTime = [[UILabel alloc] initWithFrame:CGRectMake(255, 8, 50, 12)];
        self.labelTime.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTime];
        
        self.labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, 250, 20)];
        self.labelMessage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelMessage];
        
        self.imageViewAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
        self.imageViewAvatar.image = [UIImage imageNamed:@"TreeLeafImage"];
        [self.contentView addSubview:self.imageViewAvatar];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    /*
    [_userHead setFrame:CGRectMake(INSETS, (CELL_HEIGHT-HEAD_SIZE)/2,HEAD_SIZE , HEAD_SIZE)];
    [_userNickname setFrame:CGRectMake(2*INSETS+HEAD_SIZE, (CELL_HEIGHT-HEAD_SIZE)/2, (CELL_WIDTH-HEAD_SIZE-INSETS*3), (CELL_HEIGHT-3*INSETS)/2)];
    [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE, (CELL_HEIGHT-HEAD_SIZE)/2+_userNickname.frame.size.height+INSETS, (CELL_WIDTH-HEAD_SIZE-INSETS*3), (CELL_HEIGHT-3*INSETS)/2)];
    [_timeLable setFrame:CGRectMake(CELL_WIDTH-80, (CELL_HEIGHT-HEAD_SIZE)/2, 80, (CELL_HEIGHT-3*INSETS)/2)];
    [_bageNumber setFrame:CGRectMake(0,0, 25, 25)];
    [_bageView setFrame:CGRectMake(INSETS+35, INSETS-10, 25, 25)];
    _cellBkg.frame=self.contentView.frame;
    */
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
/*
-(void)setUnionObject:(WCMessageUserUnionObject*)aUnionObj
{
    [_userNickname setText:aUnionObj.user.userNickname];
    [_messageConent setText:aUnionObj.message.messageContent];
    
    NSDateFormatter *formatter=[[[NSDateFormatter alloc]init]autorelease];
    [formatter setAMSymbol:@"上午"];
    [formatter setPMSymbol:@"下午"];
    [formatter setDateFormat:@"a HH:mm"];
    
    [_timeLable setText:[formatter stringFromDate:aUnionObj.message.messageDate]];
    [self setHeadImage:aUnionObj.user.userHead];
}
-(void)setHeadImage:(NSString*)imageURL
{
    //[_userHead setImage:headImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [_userHead setImage:[UIImage imageNamed:@"3.jpeg"]];
        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_userHead setImage:img];
        });
    });
    
}
*/
@end