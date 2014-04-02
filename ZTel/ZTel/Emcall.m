//
//  Emcall.m
//  iZJU
//
//  Created by 爱机 on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Emcall.h"
#import "AppHelper.h"

@interface Emcall ()
@property (nonatomic, retain) NSArray *phoneNumbers;
@end

@implementation Emcall

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"phone-selected.png"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"phone.png"]];
        if (IS_IOS_7)
            self.tabBarItem.selectedImage = [UIImage imageNamed:@"phone-selected.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.phoneNumbers = @[@{@"name": @"紫金港保卫处",
                            @"number": @"0571-88206110"},
                          @{@"name": @"紫金港校医院",
                            @"number": @"0571-88981120"},
                          @{@"name": @"玉泉保卫处",
                            @"number": @"0571-87951110"},
                          @{@"name": @"玉泉校医院",
                            @"number": @"0571-87953120"}]
    ;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[_phoneNumbers objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.detailTextLabel.text = [[_phoneNumbers objectAtIndex:indexPath.row] valueForKey:@"number"];
    //    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return self.phoneNumbers.count;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    NSString *number = [[self.phoneNumbers objectAtIndex:indexPath.row] valueForKey:@"number"];
    [[AppHelper sharedHelper] showCallerSheetWithTitle:@"拨打电话"
                                                number:number];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [AppHelper makeACallTo:actionSheet.title];
    }
}

#pragma mark - Actions



@end
