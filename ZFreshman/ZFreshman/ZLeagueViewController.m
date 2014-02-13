//
//  ZLeagueViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-13.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZLeagueViewController.h"
#import "UIColor+RExtension.h"

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


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.leagues[indexPath.section][@"leagues"][indexPath.row][@"name"];
    NSString *imageName = self.leagues[indexPath.section][@"leagues"][indexPath.row][@"logo"];
    if (imageName.length > 0)
        cell.imageView.image = [UIImage imageNamed:imageName];
    else
        cell.imageView.image = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];

}

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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
