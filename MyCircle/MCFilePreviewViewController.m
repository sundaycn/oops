//
//  MCFilePreviewViewController.m
//  MyCircle
//
//  Created by Samuel on 8/14/14.
//
//

#import "MCFilePreviewViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <QuickLook/QuickLook.h>

@interface MCFilePreviewViewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *localFileURL;
@end

@implementation MCFilePreviewViewController

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
    // Do any additional setup after loading the view.
    //文件下载进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 150, self.view.bounds.size.width-60, 2)];
    self.progressView.progress = 0.0f;
    [self.view addSubview:self.progressView];
    
    [self downloadFile:self.strFileName path:self.strFilePath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)downloadFile:(NSString *)strFileName path:(NSString *)strFilePath
{
    self.progressView.progress = 0.0f;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strFilePath]];
    AFURLConnectionOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSURL *downloadsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentationDirectory  inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    self.localFileURL = [downloadsDirectoryURL URLByAppendingPathComponent:strFileName];
    
    operation.outputStream = [NSOutputStream outputStreamWithURL:self.localFileURL append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            self.progressView.progress = (float)totalBytesRead / totalBytesExpectedToRead;
        //        });
        
        self.progressView.progress = (float)totalBytesRead / totalBytesExpectedToRead;
    }];
    
    [operation setCompletionBlock:^{
        [self.progressView removeFromSuperview];
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;
        
        [self addChildViewController:previewController];
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        previewController.view.frame = CGRectMake(0, 0, w, h);
        [self.view addSubview:previewController.view];
        [previewController didMoveToParentViewController:self];
    }];
    [operation start];
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    //    NSInteger numToPreview = 0;
    
    //    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    //    if (selectedIndexPath.section == 0)
    //        numToPreview = NUM_DOCS;
    //    else
    //        numToPreview = self.documentURLs.count;
    
    //    return numToPreview;
    return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    /*NSURL *fileURL = nil;
     
     NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
     if (selectedIndexPath.section == 0)
     {
     fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:documents[idx] ofType:nil]];
     }
     else
     {
     fileURL = [self.documentURLs objectAtIndex:idx];
     }
     
     return fileURL;*/
    
    return self.localFileURL;
}

@end