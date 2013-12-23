//
//  MCChatSessionViewController.m
//  MyCircle
//
//  Created by Samuel on 12/11/13.
//
//

#import "MCChatSessionViewController.h"
#import "MCXmppHelper+Message.h"
#import "MCChatHistoryDAO.h"
#import "MCChatHistory.h"

@interface MCChatSessionViewController ()

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
    //添加点击手势识别器
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    //只需要点击非文字输入区域就会响应
    [self.view addGestureRecognizer: tapGestureRecognizer];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(backMessageList);
    
    self.navigationItem.title = self.sessionTittle;
    
    self.bubbleTableView.bubbleDataSource = self;
    self.bubbleTableView.backgroundColor = [UIColor whiteColor];
    self.bubbleData = [[NSMutableArray alloc] init];
    //加载未读的消息
    [self loadRecord];
    
    //监听键盘
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    // Register notification when the keyboard will be show
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];

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
}

- (void)loadRecord
{
    //1.加载未读消息
    //2.修改未读记录为已读
    //3.重设计数器
    NSString *myJid = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] bare];
    NSArray *arrRecentMessage = [[MCChatHistoryDAO sharedManager] findRecentMessageByJid:self.jid myJid:myJid];
    for (MCChatHistory *obj in arrRecentMessage)
    {
        NSBubbleData *data;
        if ([obj.from isEqualToString:self.jid]) {
            data = [NSBubbleData dataWithText:obj.message date:obj.time type:BubbleTypeSomeoneElse];
        }
        else
        {
            data = [NSBubbleData dataWithText:obj.message date:obj.time type:BubbleTypeMine];
        }
        [self.bubbleData addObject:data];
    }
    [[MCChatHistoryDAO sharedManager] updateByJid:self.jid];
    [self resetUnreadBadge];
    [self.bubbleTableView reloadData];
    [self scrollTableToFoot:YES];
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

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.bubbleTableView numberOfSections];
    if (s < 1) return;
    NSInteger r = [self.bubbleTableView numberOfRowsInSection:s-1];
    if (r < 1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.bubbleTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

-(void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //键盘的大小
    CGSize keyboardRect = [aValue CGRectValue].size;
    
    //设置bubbleTableView的高度=当前的高度-键盘的高度
    CGFloat ht = self.bubbleTableView.frame.size.height-keyboardRect.height;
    
    self.bubbleTableView.frame = CGRectMake(0, self.bubbleTableView.frame.origin.y, self.bubbleTableView.frame.size.width, ht);
    
    //toolbar的位置=当前的y坐标-键盘的高度
    CGFloat tbpoist = self.toolbar.frame.origin.y - keyboardRect.height;
    self.toolbar.frame = CGRectMake(0,tbpoist, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
    [self scrollTableToFoot:YES];
}

-(void)keyboardWillHide:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //键盘的大小
    CGSize keyboardRect = [aValue CGRectValue].size;
    
    //设置chatlisttableview的高度=当前的高度+键盘的高度
    CGFloat ht=self.bubbleTableView.frame.size.height+keyboardRect.height;
    
    self.bubbleTableView.frame=CGRectMake(0, self.bubbleTableView.frame.origin.y, self.bubbleTableView.frame.size.width, ht);
    
    //toolbar的位置=当前的y坐标-键盘的高度
    CGFloat tbpoist = self.toolbar.frame.origin.y + keyboardRect.height;
    self.toolbar.frame = CGRectMake(0,tbpoist, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
}

-(void)refreshmsg:(MCMessage *)msg
{
    if([msg.from isEqualToString:self.jid])
    {
        NSBubbleData *data = [NSBubbleData dataWithText:msg.message date:msg.date type:BubbleTypeSomeoneElse];
        [self.bubbleData addObject:data];
        [self.bubbleTableView reloadData];
        [self scrollTableToFoot:YES];
        [[MCChatHistoryDAO sharedManager] updateByJid:self.jid];
    }
}


#pragma mark - Bubble table view data source

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [self.bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [self.bubbleData objectAtIndex:row];
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
    [self.textInputMessage resignFirstResponder];
}

- (IBAction)buttonSendMessage:(UIBarButtonItem *)sender
{
    MCMessage *message = [[MCMessage alloc] init];
    message.from = [[[[MCXmppHelper sharedInstance] xmppStream] myJID] bare];
    message.to = self.jid;
    message.message = self.textInputMessage.text;
    message.date = [NSDate date];
    [[MCXmppHelper sharedInstance] sendMessage:message];
    NSBubbleData *msg = [NSBubbleData dataWithText:self.textInputMessage.text date:[NSDate dateWithTimeIntervalSinceNow:-0] type:BubbleTypeMine];
    [self.bubbleData addObject:msg];
    [self.bubbleTableView reloadData];
    [self scrollTableToFoot:YES];
    [self.textInputMessage setText:nil];
}

- (IBAction)textFieldShoudReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
}
@end
