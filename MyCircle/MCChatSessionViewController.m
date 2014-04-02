//
//  MCChatSessionViewController.m
//  MyCircle
//
//  Created by Samuel on 12/11/13.
//
//

#import "MCChatSessionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MCXmppHelper+Message.h"
#import "MCChatHistoryDAO.h"
#import "MCChatHistory.h"
#import "MCBookBL.h"
#import <JSMessagesViewController/JSMessage.h>

#define TEXTVIEW_INIT_HEIGHT 30

@interface MCChatSessionViewController ()
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) NSMutableArray *subtitles;
@property (strong, nonatomic) NSDictionary *avatars;
@property (strong, nonatomic) NSMutableArray *bubbleMessageType;
@property (strong, nonatomic) NSString *myName;
@end

@implementation MCChatSessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    /*
    UIImage *image = [UIImage imageNamed:@"back-btn.png"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];*/

//    UIBarButtonItem *customBackBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = customBackBarButtonItem;
//    [self.navigationItem.backBarButtonItem setTarget:self];
//    [self.navigationItem.backBarButtonItem setAction:@selector(backButtonDidClick)];
    //不显示底部bar
//    self.hidesBottomBarWhenPushed = YES;
    //设置导航文字
//    self.navigationItem.title = self.sessionTittle;
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    self.title = self.buddyName;
//    self.messageInputView.textView.placeHolder = @"请输入消息";
    [self setBackgroundColor:[UIColor whiteColor]];
    
    NSString *user = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] user];
    MCBook *book = [[[MCBookBL alloc] init] findbyMobilePhone:user];
    self.sender = book.name;
    self.myName = book.name;
    
    self.messages = [[NSMutableArray alloc] init];
//    self.timestamps = [[NSMutableArray alloc] init];
//    self.subtitles = [[NSMutableArray alloc] init];
    DLog(@"myName:%@",self.myName);
    DLog(@"buddyName:%@", self.buddyName);
    self.avatars = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [JSAvatarImageFactory avatarImageNamed:@"ContactsDefaultAvatar" croppedToCircle:YES], self.sender,
                    [JSAvatarImageFactory avatarImageNamed:@"ContactsDefaultAvatar" croppedToCircle:YES], self.buddyName,
                    nil];
    self.bubbleMessageType = [[NSMutableArray alloc] init];
    
//    self.sender = @"Username of sender";
    
    //添加点击手势识别器
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    //只需要点击非文字输入区域就会响应
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    
    //导航
//    self.navigationItem.leftBarButtonItem.target = self;
//    self.navigationItem.leftBarButtonItem.action = @selector(backMessageList);
//    self.navigationItem.title = self.sessionTittle;

    //加载消息记录
    myJid = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] bare];
    timeOfFirstMessage = nil;
    [self loadRecord];
    
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉查看历史记录"];
//    self.refreshControl.tag = 99;
    [self.refreshControl addTarget:self
                            action:@selector(refreshBubbleTableView)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.tableView.alwaysBounceVertical = YES;
//    [self.refreshControl beginRefreshing];
//    [self.refreshControl endRefreshing];
    
    //监听键盘
    /*NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    // Register notification when the keyboard will be show
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];*/
    /*[defaultCenter addObserver:self
                      selector:@selector(textIsChanging:)
                          name:UITextViewTextDidChangeNotification
                        object:nil];*/
}

- (void)viewWillDisappear:(BOOL)animated
{
    //更新未读消息数
    [self resetUnreadBadge];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadRecord
{
    //1.加载消息记录
    //2.修改未读记录为已读
    //3.重设计数器
    NSArray *arrRecentMessage = [[MCChatHistoryDAO sharedManager] findRecentMessageByType:MSG_TYPE_NORMAL_CHAT jid:self.jid myJid:myJid];
    if (arrRecentMessage.count < 10) {
        refreshControlVisable = NO;
    }
    else {
        refreshControlVisable = YES;
    }
    MCChatHistory *obj;

    NSEnumerator *enumer = [arrRecentMessage reverseObjectEnumerator];
    while (obj = [enumer nextObject]) {
        if ([obj.from isEqualToString:self.jid]) {
            [self.messages addObject:[[JSMessage alloc] initWithText:obj.message sender:self.buddyName date:obj.time]];
            [self.bubbleMessageType addObject:@"incoming"];
        }
        else {
            [self.messages addObject:[[JSMessage alloc] initWithText:obj.message sender:self.sender date:obj.time]];
            [self.bubbleMessageType addObject:@"outgoing"];
//            [self.subtitles addObject:self.myName];
        }
    }
    //保存已展示的第一条记录的时间，便于获取更多历史记录
    if (!timeOfFirstMessage) {
        timeOfFirstMessage = [[arrRecentMessage lastObject] time];
    }

    [[MCChatHistoryDAO sharedManager] updateByJid:self.jid];
    [self resetUnreadBadge];
//    [self.bubbleTableView reloadData];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)resetUnreadBadge
{
    NSInteger cnt = [[MCChatHistoryDAO sharedManager] fetchUnReadMsgCount];
    if(cnt <= 0){
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = nil;
    }else{
        UIViewController *tabBarVC = [self.tabBarController.viewControllers objectAtIndex:0];
        tabBarVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", cnt];
    }
}

//- (void)scrollTableToFoot:(BOOL)animated
//{
//    NSInteger s = [self.bubbleTableView numberOfSections];
//    if (s < 1) return;
//    NSInteger r = [self.bubbleTableView numberOfRowsInSection:s-1];
//    if (r < 1) return;
//    
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
//    
//    [self.bubbleTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
//}
/*
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    //键盘的大小
    CGSize keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    DLog(@"view origin y:%f", self.view.frame.origin.y);
    DLog(@"view size height:%f", self.view.frame.size.height);
    DLog(@"toolbar size height:%f", self.toolbar.frame.size.height);
    //键盘动画耗时
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        //设置bubbleTableView的高度
        CGFloat bubuleTableViewHeight = self.view.frame.size.height - self.toolbar.frame.size.height - keyboardRect.height;
        DLog(@"bubbleview size height:%f", bubuleTableViewHeight);
        self.bubbleTableView.frame = CGRectMake(0, self.bubbleTableView.frame.origin.y, self.bubbleTableView.frame.size.width, bubuleTableViewHeight);

        //设置toolbar的位置
        CGFloat toolbarY = self.view.frame.size.height - self.toolbar.frame.size.height - keyboardRect.height;
        DLog(@"toolbar origin y:%f", toolbarY);
        self.toolbar.frame = CGRectMake(0, toolbarY, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
    }];
    [self scrollTableToFoot:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    //键盘的大小
    CGSize keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //键盘动画耗时
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        //设置bubbleTableView的高度
        CGFloat bubuleTableViewHeight = self.bubbleTableView.frame.size.height + keyboardRect.height;
        self.bubbleTableView.frame = CGRectMake(0, self.bubbleTableView.frame.origin.y, self.bubbleTableView.frame.size.width, bubuleTableViewHeight);
    
        //设置toolbar的位置
        CGFloat toolbarY = self.toolbar.frame.origin.y + keyboardRect.height;
        self.toolbar.frame = CGRectMake(0, toolbarY, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
        
        //设置UITextView的位置
//        CGFloat textViewY = self.textInputBox.frame.origin.y + keyboardRect.height;
//        self.textInputBox.frame = CGRectMake(self.textInputBox.frame.origin.x, textViewY, self.textInputBox.frame.size.width, self.textInputBox.frame.size.height);

    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    DLog(@"=====textViewDidChange=======");
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:textView.text];
    [textView setAttributedText:string];
    CGFloat textViewHeightBeforeChanged = textView.frame.size.height;
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    DLog(@"-----size height:%f", size.height);
    if (size.height <= 90)
    {
        
        CGFloat changedHeight = size.height - textViewHeightBeforeChanged;
        [textView scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
        DLog(@"-----changedHeight:%f", changedHeight);
        //            DLog(@"-----textView.frame.height:%f", textView.frame.size.height);
        
        // textView
        CGRect inputBoxFrame = textView.frame;
        inputBoxFrame.size.height = size.height;
        textView.frame = inputBoxFrame;
        DLog(@"after changed textView origin y:%f", textView.frame.origin.y);
        DLog(@"after changed textView size height:%f", textView.frame.size.height);
        
        // toolbar
        CGRect toolbarFrame = self.toolbar.frame;
        toolbarFrame.origin.y = self.toolbar.frame.origin.y - changedHeight;
        toolbarFrame.size.height = self.toolbar.frame.size.height + changedHeight;
        self.toolbar.frame = toolbarFrame;
        DLog(@"after changed toolbar origin y:%f", self.toolbar.frame.origin.y);
        DLog(@"after changed toolbar size height:%f", self.toolbar.frame.size.height);
        
        // bubbleTableView
        CGRect bubbleTableFrame = self.bubbleTableView.frame;
        bubbleTableFrame.size.height = self.bubbleTableView.frame.size.height - changedHeight;
        self.bubbleTableView.frame = bubbleTableFrame;
        DLog(@"after changed bubbleTableView size height:%f", self.bubbleTableView.frame.size.height);
    }
    else
    {
        DLog(@"*******content height is more than 90");
        if (!textView.scrollEnabled) {
            textView.scrollEnabled = YES;
        }
        [textView scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    }
}*/

- (void)refreshmsg:(MCMessage *)msg
{
    if([msg.from isEqualToString:self.jid])
    {
        [self.messages addObject:msg.message];
        [self.timestamps addObject:msg.date];
        [self.bubbleMessageType addObject:@"incoming"];
        [self.subtitles addObject:self.buddyName];
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        [[MCChatHistoryDAO sharedManager] updateByJid:self.jid];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate: REQUIRED
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    MCMessage *message = [[MCMessage alloc] init];
    message.from = myJid;
    message.to = self.jid;
    message.message = text;
    message.date = [NSDate date];
    [[MCXmppHelper sharedInstance] sendMessage:message];

    [JSMessageSoundEffect playMessageSentSound];
    
    [self.bubbleMessageType addObject:@"outgoing"];
//    [self.messages addObject:text];
//    [self.timestamps addObject:message.date];
//    [self.subtitles addObject:self.myName];
    
    [self.messages addObject:[[JSMessage alloc] initWithText:text sender:self.sender date:message.date]];

    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.bubbleMessageType objectAtIndex:indexPath.row] isEqualToString:@"incoming"]) {
        return JSBubbleMessageTypeIncoming;
    }

    return JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type == JSBubbleMessageTypeIncoming) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_bubbleBlueColor]];
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages view delegate: OPTIONAL

//
//  *** Implement to customize cell further
//
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
        if([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    if(cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if(cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
    
#if TARGET_IPHONE_SIMULATOR
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
#else
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
#endif
}

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
//  - (UIButton *)sendButtonForInputView
//

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

// *** Implemnt to enable/disable pan/tap todismiss keyboard
//
- (BOOL)allowsPanToDismissKeyboard
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED
- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

//- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.messages objectAtIndex:indexPath.row];
//}
//
//- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.timestamps objectAtIndex:indexPath.row];
//}

//- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *subtitle = [self.subtitles objectAtIndex:indexPath.row];
//    UIImage *image = [self.avatars objectForKey:subtitle];
//    return [[UIImageView alloc] initWithImage:image];
//}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
    
    UIImage *image = [self.avatars objectForKey:sender];
    return [[UIImageView alloc] initWithImage:image];
}

//- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.subtitles objectAtIndex:indexPath.row];
//}

- (void)refreshBubbleTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在加载..."];
        //加载更多数据
        NSArray *arrEarlyMessage = [[MCChatHistoryDAO sharedManager] findSomeMessageByType:self.msgType time:timeOfFirstMessage jid:self.jid myJid:myJid];
        if (arrEarlyMessage.count < 10) {
            refreshControlVisable = NO;
        }
        for (MCChatHistory *obj in arrEarlyMessage)
        {
            [self.messages insertObject:obj.message atIndex:0];
            [self.timestamps insertObject:obj.time atIndex:0];
            if ([obj.from isEqualToString:self.jid]) {
                [self.bubbleMessageType insertObject:@"incoming" atIndex:0];
                [self.subtitles insertObject:self.buddyName atIndex:0];
            }
            else {
                [self.bubbleMessageType insertObject:@"outgoing" atIndex:0];
                [self.subtitles insertObject:self.myName atIndex:0];
            }
        }
        //保存已展示的第一条记录的时间
        timeOfFirstMessage = [[arrEarlyMessage lastObject] time];
        //回调方法
        [self performSelector:@selector(callBackMethod:) withObject:nil];
    }
}

- (void)callBackMethod:(id)obj
{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉查看历史记录"];
    if (!refreshControlVisable) {
        //没有更多记录则移除refreshControl
        self.refreshControl = nil;
        [self.refreshControl removeFromSuperview];
    }
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"new" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonDidClick)];
}
*/

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    DLog(@"ooooookkkkkkk");
    return YES;
}

- (void)backMessageList
{
    DLog(@"Did Click!");
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)backgroundTap:(UITapGestureRecognizer *)sender
{
    //关闭所有UITextField控件的键盘
//    [self.textView resignFirstResponder];
}
/*
- (IBAction)buttonSendMessage:(UIBarButtonItem *)sender
{
    MCMessage *message = [[MCMessage alloc] init];
    message.from = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] bare];
    message.to = self.jid;
    message.message = self.textInputBox.text;
    message.date = [NSDate date];
    DLog(@"======send date:%@", message.date);
    [[MCXmppHelper sharedInstance] sendMessage:message];
    NSBubbleData *msg = [NSBubbleData dataWithText:self.textInputBox.text date:[NSDate dateWithTimeIntervalSinceNow:-0] type:BubbleTypeMine];
    [self.bubbleData addObject:msg];
    [self.bubbleTableView reloadData];
    [self scrollTableToFoot:YES];
    [self.textInputBox setText:nil];
}

- (IBAction)textFieldShoudReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
}*/

//暂时没用到
- (NSDate *)getLocalDate:(NSDate *)gmtDate
{
    //获取本地时间，默认是GMT时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:gmtDate];
    return [gmtDate dateByAddingTimeInterval:interval];
}
@end
