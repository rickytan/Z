//
//  ZPaymentSettingViewController.m
//  ZWork
//
//  Created by ricky on 14-1-10.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZPaymentSettingViewController.h"

@interface ZPaymentSettingViewController () <UITextFieldDelegate>
@property (nonatomic, assign) IBOutlet UITextField *textField;
- (IBAction)onDone:(id)sender;
@end

@implementation ZPaymentSettingViewController

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

- (void)endWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(paymentSettingController:didEndEditingWithText:)])
        [self.delegate paymentSettingController:self
                          didEndEditingWithText:text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    [self endWithText:[NSString stringWithFormat:@"软妹币 %@ 元/人", self.textField.text]];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self endWithText:cell.textLabel.text];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endWithText:textField.text];
    return YES;
}

@end
