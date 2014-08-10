//
//  MCMyFileTableViewController.m
//  MyCircle
//
//  Created by Samuel on 8/6/14.
//
//

#import "MCMyFileTableViewController.h"
#import <QuickLook/QuickLook.h>
#import "MCDirectoryWatcher.h"

#define kRowHeight 58.0f

@interface MCMyFileTableViewController () <QLPreviewControllerDataSource, QLPreviewControllerDelegate, MCDirectoryWatcherDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) MCDirectoryWatcher *docWatcher;
@property (nonatomic, strong) NSMutableArray *documentURLs;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@property (strong, nonatomic) NSArray *arrFiles;
@end

@implementation MCMyFileTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的文件";
    
    // start monitoring the document directory…
    self.docWatcher = [MCDirectoryWatcher watchFolderWithPath:[self applicationDocumentsDirectory] delegate:self];
    
    self.documentURLs = [NSMutableArray array];
    
    // scan for existing documents
    [self directoryDidChange:self.docWatcher];
    
    //load data source
//    self.arrFiles = [self getListOfFils];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.documentURLs = nil;
    self.docWatcher = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return [self.arrFiles count];
    return self.documentURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyFileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//    cell.textLabel.text = [[self.arrFiles[indexPath.row] objectForKey:@"file"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *fileURL = [self.documentURLs objectAtIndex:indexPath.row];
	[self setupDocumentControllerWithURL:fileURL];
	
    // layout the cell
    cell.textLabel.text = [[[fileURL path] lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
    NSString *fileURLString = [self.docInteractionController.URL path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize
                                                           countStyle:NSByteCountFormatterCountStyleFile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", fileSizeStr, self.docInteractionController.UTI];
    
    // attach to our view any gesture recognizers that the UIDocumentInteractionController provides
    //cell.imageView.userInteractionEnabled = YES;
    //cell.contentView.gestureRecognizers = self.docInteractionController.gestureRecognizers;
    //
    // or
    // add a custom gesture recognizer in lieu of using the canned ones
    //
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell.imageView addGestureRecognizer:longPressGesture];
    cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self performSegueWithIdentifier:@"showPreview" sender:self];
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    // start previewing the document at the current section index
    previewController.currentPreviewItemIndex = indexPath.row;
    [[self navigationController] pushViewController:previewController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showPreview"]) {
        MCFilePreviewViewController *filePreviewVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        filePreviewVC.path = [self.arrFiles[indexPath.row] objectForKey:@"path"];
    }
}*/

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
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
    return self.documentURLs.count;
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
    
    return [self.documentURLs objectAtIndex:idx];
}

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    //checks if docInteractionController has been initialized with the URL
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

// if we installed a custom UIGestureRecognizer (i.e. long-hold), then this would be called
//
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForRowAtPoint:[longPressGesture locationInView:self.tableView]];
        /*
		NSURL *fileURL;
		if (cellIndexPath.section == 0)
        {
            // for section 0, we preview the docs built into our app
            fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:documents[cellIndexPath.row] ofType:nil]];
		}
        else
        {
            // for secton 1, we preview the docs found in the Documents folder
            fileURL = [self.documentURLs objectAtIndex:cellIndexPath.row];
		}
        self.docInteractionController.URL = fileURL;*/
        
        self.docInteractionController.URL = [self.documentURLs objectAtIndex:cellIndexPath.row];
		
		[self.docInteractionController presentOptionsMenuFromRect:longPressGesture.view.frame
                                                           inView:longPressGesture.view
                                                         animated:YES];
    }
}

#pragma mark - File system support

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)directoryDidChange:(MCDirectoryWatcher *)folderWatcher
{
	[self.documentURLs removeAllObjects];    // clear out the old docs and start over
	
	NSString *documentsDirectoryPath = [self applicationDocumentsDirectory];
	
	NSArray *documentsDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath
                                                                                              error:NULL];
    
	for (NSString* curFileName in [documentsDirectoryContents objectEnumerator])
	{
		NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:curFileName];
		NSURL *fileURL = [NSURL fileURLWithPath:filePath];
		
		BOOL isDirectory;
        [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
		
        // proceed to add the document URL to our list (ignore the "Inbox" folder)
        if (!(isDirectory && [curFileName isEqualToString:@"Inbox"]))
        {
            [self.documentURLs addObject:fileURL];
        }
	}
	
	[self.tableView reloadData];
}
/*
- (NSArray *)getListOfFils
{
    NSURL *downloadsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDownloadsDirectory  inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSArray *arrPath =  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:downloadsDirectoryURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSMutableArray *arrFile = [NSMutableArray array];
    
    for (NSURL *path in arrPath) {
        NSMutableDictionary *dictPath = [[NSMutableDictionary alloc] init];
        [dictPath setObject:path forKey:@"path"];
        [dictPath setObject:[[path absoluteString] lastPathComponent] forKey:@"file"];
        [arrFile addObject:dictPath];
    }
    
    return arrFile;
}*/

@end
