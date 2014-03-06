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

@interface ZQuestionViewController () <UISearchDisplayDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSArray *hot;
@property (nonatomic, strong) NSArray *filteredQuestions;
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

    self.hot = @[@{@"Title": @"浙江大学概况", @"Url": @"浙江大学概况.html"},
                 @{@"Title": @"新生须知", @"Url": @"新生须知.html"},
                 @{@"Title": @"常用电话", @"Url": @"常用电话.html"},
                 @{@"Title": @"常用网络资源", @"Url": @"常用网络资源.html"},
                 @{@"Title": @"游在杭州", @"Url": @"游在杭州.html"}
                 ];
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

- (void)filterWithText:(NSString *)text
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Title contains[cd] %@ ", text];
    self.filteredQuestions = [self.questions filteredArrayUsingPredicate:predicate];
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    [self filterWithText:searchText];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
        return 2;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
        return section == 1 ? self.questions.count : self.hot.count;
    else
        return self.filteredQuestions.count;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return section == 0 ? @"热门问题" : @"所有问题";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        // Configure the cell...
        cell.textLabel.text = indexPath.section == 1 ? self.questions[indexPath.row][@"Title"] : self.hot[indexPath.row][@"Title"];

        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"SearchCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.textLabel.text = self.filteredQuestions[indexPath.row][@"Title"];

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        ZWebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:@"ZWebView"];
        web.url = [NSURL fileURLWithPath:[[self htmlPath] stringByAppendingPathComponent:self.filteredQuestions[indexPath.row][@"Url"]]];
        [self.navigationController pushViewController:web
                                             animated:YES];
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ZWebViewController *web = (ZWebViewController *)segue.destinationViewController;
    web.url = [NSURL fileURLWithPath:[[self htmlPath] stringByAppendingPathComponent:(indexPath.section == 1 ? self.questions : self.hot)[indexPath.row][@"Url"]]];
}


@end
