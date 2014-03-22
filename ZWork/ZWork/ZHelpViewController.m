//
//  ZHelpViewController.m
//  ZWork
//
//  Created by ricky on 14-1-10.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZHelpViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "NSDate+RExtension.h"
#import "SVProgressHUD.h"

@interface ZHelpCell : UITableViewCell
@property (nonatomic, assign) IBOutlet UILabel     * titleLabel;
@property (nonatomic, assign) IBOutlet UILabel     * detailLabel;
@property (nonatomic, assign) IBOutlet UIImageView * attachedImageView;
@property (nonatomic, assign) IBOutlet UILabel     * paymentLabel;
@property (nonatomic, assign) IBOutlet UILabel     * numberOfPeople;
@property (nonatomic, assign) IBOutlet UILabel     * dateLabel;
@end

@implementation ZHelpCell
@end

@interface ZHelpViewController ()
@property (nonatomic, strong) NSMutableArray *needsItems;
@property (nonatomic, assign) BOOL hasMore;
- (IBAction)onReload:(id)sender;
@end

@implementation ZHelpViewController

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
    
    [self reloadItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReload:(id)sender
{
    [self reloadItems];
}

- (void)reloadItems
{
    if (!_needsItems) {
        _needsItems = [NSMutableArray array];
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"Need"];
    query.skip = 0;
    query.limit = 20;
    //[query whereKey:@"expire"
    //    greaterThan:[NSDate date]];
    [query orderByDescending:@"updatedAt"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.hasMore = (objects.count == 20);
            [self.needsItems removeAllObjects];
            [self.tableView reloadData];
            
            NSInteger count = self.needsItems.count;
            [self.needsItems addObjectsFromArray:objects];
            NSMutableArray *indexPathes = [NSMutableArray arrayWithCapacity:objects.count];
            for (int i=0; i < objects.count; i++) {
                [indexPathes addObject:[NSIndexPath indexPathForRow:count + i
                                                          inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathes
                                  withRowAnimation:UITableViewRowAnimationLeft];
            [self.refreshControl endRefreshing];
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"加载失败！"];
        }
    }];
}

- (void)appendItems
{
    AVQuery *query = [AVQuery queryWithClassName:@"Need"];
    query.skip = self.needsItems.count;
    query.limit = 20;
    //[query whereKey:@"expire"
    //    greaterThan:[NSDate date]];
    [query orderByDescending:@"updatedAt"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.hasMore = (objects.count == 20);
            [self.needsItems removeAllObjects];
            [self.tableView reloadData];
            
            NSInteger count = self.needsItems.count;
            [self.needsItems addObjectsFromArray:objects];
            NSMutableArray *indexPathes = [NSMutableArray arrayWithCapacity:objects.count];
            for (int i=0; i < objects.count; i++) {
                [indexPathes addObject:[NSIndexPath indexPathForRow:count + i
                                                          inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathes
                                  withRowAnimation:UITableViewRowAnimationLeft];
            [self.refreshControl endRefreshing];
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"加载失败！"];
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
    return self.needsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NeedCell";
    ZHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell.backgroundView)
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-bg.png"]];
    AVObject *object = self.needsItems[indexPath.row];
    cell.titleLabel.text = object[@"title"];
    cell.detailLabel.text = object[@"details"];
    cell.paymentLabel.text = object[@"payment"];
    cell.numberOfPeople.text = [NSString stringWithFormat:@"需要%d人", [object[@"numOfPeople"] intValue]];
    NSDate *expire = (NSDate *)object[@"expire"];
    NSDate *today = [NSDate date];
    if (expire.yearComponent == today.yearComponent &&
        expire.monthComponent == today.monthComponent &&
        expire.dayComponent == today.dayComponent) {
        cell.dateLabel.text = [expire stringWithFormat:@"今天 HH:mm 过期"];
    }
    else {
        cell.dateLabel.text = [expire stringWithFormat:@"MM-dd HH:mm 过期"];
    }
    
    AVFile *image = object[@"image0"];
    if (!image && [image isKindOfClass:[NSNull class]]) image = object[@"image1"];
    if (!image && [image isKindOfClass:[NSNull class]]) image = object[@"image2"];
    if ([image isKindOfClass:[AVFile class]]) {
        [image getThumbnail:YES
                      width:120
                     height:120
                  withBlock:^(UIImage *image, NSError *error) {
                      cell.attachedImageView.image = image;
                  }];
    }
    else
        cell.attachedImageView.image = [UIImage imageNamed:@"icon-120.png"];
    
    return cell;
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
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
