//
//  ZMajorViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-24.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZMajorViewController.h"
#import "UIColor+RExtension.h"

@interface ZMajorViewController ()
@property (nonatomic, strong) NSArray *majors;
@end

@implementation ZMajorViewController

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

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TraningPlan"
                                                                                  ofType:@"json"]];
    self.majors = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:NULL];

    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor iOS7DefaultBlueTint];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.majors.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.majors[section][@"majors"]).count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
    }
    label.backgroundColor = [UIColor colorForIndex:section];
    label.text = self.majors[section][@"category"];
    return label;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    static NSMutableArray *indexTitles = nil;
    if (!indexTitles) {
        indexTitles = [[NSMutableArray alloc] initWithCapacity:self.majors.count];
        for (int i=0; i < self.majors.count; ++i) {
            [indexTitles addObject:[self.majors[i][@"category"] substringToIndex:1]];
        }
    }
    return indexTitles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];

    // Configure the cell...
    NSDictionary *item = self.majors[indexPath.section][@"majors"][indexPath.row];
    cell.textLabel.text = item[@"name"];
    /*
    cell.detailTextLabel.text = [NSString stringWithFormat:@"指导老师：%@", item[@"instructor"]];
    NSString *imageName = item[@"logo"];
    if (imageName.length > 0)
        cell.imageView.image = [UIImage imageNamed:imageName];
    else
        cell.imageView.image = [UIImage imageNamed:@"league.png"];
     */
    return cell;
}

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *controller = (UIViewController *)segue.destinationViewController;
    controller.title = self.majors[indexPath.section][@"majors"][indexPath.row][@"name"];
    UIWebView *web = (UIWebView *)controller.view;
    web.scalesPageToFit = YES;
    web.multipleTouchEnabled = YES;
    NSURL *url = [NSURL URLWithString:[self.majors[indexPath.section][@"majors"][indexPath.row][@"url"] stringByReplacingOccurrencesOfString:@"bksy"
                                                                                                                                  withString:@"ugrs"]];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
