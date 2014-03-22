//
//  ZParttimesViewController.m
//  ZWork
//
//  Created by ricky on 14-3-21.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZParttimesViewController.h"
#import "SVProgressHUD.h"
#import "MWFeedParser.h"
#import "ZParttimeDetailViewController.h"

@interface ZParttimesViewController () <MWFeedParserDelegate>
@property (nonatomic, strong) MWFeedParser *parser;
@property (nonatomic, strong) NSMutableArray *feedItems;
@end

@implementation ZParttimesViewController

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

    [self reloadFeeds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadFeeds
{
    [SVProgressHUD showWithStatus:@"加载中..."
                         maskType:SVProgressHUDMaskTypeClear];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.zjuol.com/zdqcw/index.php?c=Index&a=rss"]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   NSMutableData *feedData = [data mutableCopy];
                                   NSRange range = [feedData rangeOfData:[@"</item>" dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options:NSDataSearchBackwards
                                                                   range:NSMakeRange(0, feedData.length)];
                                   if (range.location != NSNotFound) {
                                       NSUInteger start = range.location + range.length;
                                       [feedData replaceBytesInRange:NSMakeRange(start, feedData.length - start)
                                                           withBytes:NULL
                                                              length:0];
                                       [feedData appendData:[@"\n</channel>\n</rss>" dataUsingEncoding:NSUTF8StringEncoding]];
                                   }
                                   
                                   self.parser = [[MWFeedParser alloc] init];
                                   self.parser.delegate = self;
                                   [self.parser parseData:feedData];
                               }
                               else {
                                   [SVProgressHUD showErrorWithStatus:@"载入失败！"];
                               }
                           }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    static NSDateFormatter * formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyy-MM-dd HH:mm";
    }
    MWFeedItem *item = self.feedItems[indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    if ([item.title rangeOfString:@"已截止"].location != NSNotFound) {
        titleLabel.textColor = [UIColor redColor];
    }
    else {
        titleLabel.textColor = [UIColor blackColor];
    }
    titleLabel.text = item.title;
    ((UILabel*)[cell viewWithTag:11]).text = item.summary;
    ((UILabel*)[cell viewWithTag:12]).text = [formatter stringFromDate:item.date];
    return cell;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ParttimeDetail"]) {
        MWFeedItem *item = self.feedItems[[self.tableView indexPathForSelectedRow].row];
        ZParttimeDetailViewController *detail = (ZParttimeDetailViewController*)segue.destinationViewController;
        detail.url = [NSURL URLWithString:[item.link stringByReplacingOccurrencesOfString:@"localhost"
                                                                               withString:@"www.zjuol.com"]];
    }
}


#pragma mark - MWFeedParser Delegate

- (void)feedParserDidStart:(MWFeedParser *)parser
{
    if (!_feedItems) {
        _feedItems = [[NSMutableArray alloc] init];
    }
    [self.feedItems removeAllObjects];
}

- (void)feedParser:(MWFeedParser *)parser
  didParseFeedInfo:(MWFeedInfo *)info
{
    
}

- (void)feedParser:(MWFeedParser *)parser
  didParseFeedItem:(MWFeedItem *)item
{
    [self.feedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

- (void)feedParser:(MWFeedParser *)parser
  didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [SVProgressHUD showErrorWithStatus:@"解析失败！"];
}

@end
