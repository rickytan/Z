//
//  Telephone.m
//  iZJU
//
//  Created by ricky on 12-12-14.
//
//

#import "Telephone.h"
#import "ZipArchive.h"
#import "YellowPageViewController.h"


@implementation PhoneItem
@end

@interface Telephone ()
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *spinnerView;
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, strong) NSArray *phoneNumbers;
- (void)initSQLiteDBInBackground;
- (void)initSQLite;
- (void)initDidFinished;
@end


@implementation Telephone

+ (NSString*)telephoneDBPath
{
    static NSString *path = nil;
    if (!path)
        path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"zjutel.db"];
    return path;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSQLiteDBInBackground];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Methods

- (void)initSQLiteDBInBackground
{
    if (self.database)
        return;
    
    [self.spinnerView startAnimating];
    
    [self performSelectorInBackground:@selector(initSQLite)
                           withObject:nil];
}

- (void)initSQLite
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [Telephone telephoneDBPath];
    if (![fm fileExistsAtPath:path]) {
        NSString *dbResource = [[NSBundle mainBundle] pathForResource:@"zjutel-db"
                                                               ofType:@"zip"];
        ZipArchive *zip = [[ZipArchive alloc] init];
        if (![zip UnzipOpenFile:dbResource Password:@"IloveiZJU!123"]) {
            NSLog(@"数据文件打开错误！");
        }
        if (![zip UnzipFileTo:[path stringByDeletingLastPathComponent]
                    overWrite:YES]) {
            NSLog(@"数据文件解压错误！");
        }
        [zip UnzipCloseFile];
    }
    
    self.database = [FMDatabase databaseWithPath:path];
    if (![self.database open]) {
        [self.database close];
        self.database = nil;
    }
    
    [self performSelectorOnMainThread:@selector(initDidFinished)
                           withObject:nil
                        waitUntilDone:NO];
}

- (void)initDidFinished
{
    [self.spinnerView stopAnimating];
    
    FMResultSet *result = [_database executeQuery:@"SELECT id,pid,title,has_child,is_leaf FROM Node WHERE pid = 0"];
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:10];
    while ([result next]) {
        PhoneItem *item = [[PhoneItem alloc] init];
        item.ID = [result intForColumn:@"id"];
        item.pID = [result intForColumn:@"pid"];
        item.title = [result stringForColumn:@"title"];
        item.hasChild = [result boolForColumn:@"has_child"];
        item.leaf = [result boolForColumn:@"is_leaf"];
        
        if (item.isLeaf) {
            NSMutableArray *nums = [NSMutableArray arrayWithCapacity:10];
            FMResultSet *numresult = [_database executeQueryWithFormat:@"SELECT number FROM Number WHERE nid = %d",item.ID];
            while ([numresult next]) {
                [nums addObject:[numresult stringForColumn:@"number"]];
            }
            item.numbers = [NSArray arrayWithArray:nums];
        }
        [data addObject:item];
    }
    self.phoneNumbers = [NSArray arrayWithArray:data];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.phoneNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    PhoneItem *item = [self.phoneNumbers objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    PhoneItem *item = [self.phoneNumbers objectAtIndex:indexPath.row];
    
    YellowPageViewController *detailViewController = [[YellowPageViewController alloc] init];
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.parentID = item.ID;
    detailViewController.title = item.title;
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    
}

@end
