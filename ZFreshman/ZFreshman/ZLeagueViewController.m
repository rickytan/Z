//
//  ZLeagueViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-13.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZLeagueViewController.h"
#import "UIColor+RExtension.h"
#import "ZLeagueIntroViewController.h"

@interface ZLeagueViewController ()
@property (nonatomic, strong) NSArray *leagues;
@end

@implementation ZLeagueViewController

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

    self.leagues = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"League"
                                                                                    ofType:@"plist"]];

    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor iOS7DefaultBlueTint];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    
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
    return self.leagues.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.leagues[section][@"leagues"]).count;
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
    label.text = self.leagues[section][@"category"];
    return label;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    static NSArray *indexTitles = nil;
    if (!indexTitles) {
        indexTitles = @[@"实", @"体", @"文", @"兴", @"学"];
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
    NSDictionary *item = self.leagues[indexPath.section][@"leagues"][indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"指导老师：%@", item[@"instructor"]];
    NSString *imageName = item[@"logo"];
    if (imageName.length > 0)
        cell.imageView.image = [UIImage imageNamed:imageName];
    else
        cell.imageView.image = [UIImage imageNamed:@"league.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Detail"
                              sender:self];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Detail"]) {
        ZLeagueIntroViewController *intro = (ZLeagueIntroViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *item = self.leagues[indexPath.section][@"leagues"][indexPath.row];
        intro.text = item[@"description"];
    }
}

@end
