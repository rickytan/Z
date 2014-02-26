//
//  ZQuestionViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-27.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZQuestionViewController.h"
#import "SVProgressHUD.h"
#import "ZWebViewController.h"

@interface ZQuestionViewController ()
@property (nonatomic, strong) NSArray *questions;
@end

@implementation ZQuestionViewController

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

    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)cacheFilePath
{
    static NSString *cachePath = nil;
    if (!cachePath) {
        cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cached.plist"];
    }
    return cachePath;
}

- (NSString *)htmlPath
{
    static NSString *htmlPath = nil;
    if (!htmlPath) {
        htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HTML"];
    }
    return htmlPath;
}

- (NSArray *)loadCache
{
    return [NSArray arrayWithContentsOfFile:[self cacheFilePath]];
}

- (void)buildData
{
    [SVProgressHUD showWithStatus:@"数据处理中..."
                         maskType:SVProgressHUDMaskTypeClear];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *htmlPath = [self htmlPath];
        NSArray *items = [fm contentsOfDirectoryAtPath:htmlPath
                                                 error:NULL];
        NSMutableArray *questionItems = [NSMutableArray arrayWithCapacity:items.count];

        for (NSString *file in items) {
            NSString *path = [htmlPath stringByAppendingPathComponent:file];
            NSDictionary *attr = [fm attributesOfItemAtPath:path
                                                      error:NULL];
            if ([attr[NSFileType] isEqualToString:NSFileTypeRegular] && [file.pathExtension.lowercaseString isEqualToString:@"html"]) {
                [questionItems addObject:@{@"Title": [file stringByDeletingPathExtension],
                                           @"Url": file}];
            }
        }
        self.questions = [NSArray arrayWithArray:questionItems];
#ifndef DEBUG
        [self.questions writeToFile:[self cacheFilePath]
                         atomically:YES];
#endif

        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        });
    });
}

- (void)initData
{
    self.questions = [self loadCache];
    if (!self.questions.count) {
        [self buildData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.questions[indexPath.row][@"Title"];
    
    return cell;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ZWebViewController *web = (ZWebViewController *)segue.destinationViewController;
    web.url = [NSURL fileURLWithPath:[[self htmlPath] stringByAppendingPathComponent:self.questions[indexPath.row][@"Url"]]];
}


@end
