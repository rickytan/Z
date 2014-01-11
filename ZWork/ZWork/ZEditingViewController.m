//
//  ZJUEditingViewController.m
//  iZJU
//
//  Created by ricky on 13-6-26.
//  Copyright (c) 2013年 iZJU Studio. All rights reserved.
//

#import "ZEditingViewController.h"
#import "UIDateField.h"

@interface ZEditingViewController () <UITextViewDelegate>
@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;
@end

@implementation ZEditingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self
                                                                            action:@selector(onCancel:)];
    self.navigationItem.rightBarButtonItem = cancel;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isCancelled) {
        if ([self.delegate respondsToSelector:@selector(editingViewControllerDidCancelEditing:)])
            [self.delegate editingViewControllerDidCancelEditing:self];
    }
    else {
        if (self.target && self.action && [self.target respondsToSelector:self.action])
            [self.target performSelector:self.action];
        
        if ([self.delegate respondsToSelector:@selector(editingViewController:didEndEditingWithText:)])
            [self.delegate editingViewController:self
                           didEndEditingWithText:self.string];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)onCancel:(id)sender
{
    self.cancelled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTextFieldChanged:(UITextField*)textField
{
    self.string = textField.text;
}

#pragma mark - Table Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return (self.type == EditingTypeOptions) ? self.options.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.type == EditingTypeTextView) ? 120.0 : 44.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor grayColor];
    }
    switch (self.type) {
        case EditingTypeOptions:
        {
            NSString *text = self.options[indexPath.row];
            cell.textLabel.text = text;
            cell.accessoryType = [text isEqualToString:self.string] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
            break;
        case EditingTypeTextField:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell.contentView viewWithTag:17]) {
                UITextField *textField = [[UITextField alloc] initWithFrame:UIEdgeInsetsInsetRect(cell.contentView.bounds, UIEdgeInsetsMake(8, 8, 8, 8))];
                textField.tag = 17;
                textField.text = self.string;
                textField.rightViewMode = UITextFieldViewModeWhileEditing;
                textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                textField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                textField.textColor = [UIColor grayColor];
                textField.backgroundColor = [UIColor clearColor];
                [textField addTarget:self
                              action:@selector(onTextFieldChanged:)
                    forControlEvents:UIControlEventEditingChanged];
                [textField becomeFirstResponder];
                [cell.contentView addSubview:textField];
            }
        }
            break;
        case EditingTypePhone:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell.contentView viewWithTag:17]) {
                UITextField *textField = [[UITextField alloc] initWithFrame:UIEdgeInsetsInsetRect(cell.contentView.bounds, UIEdgeInsetsMake(8, 8, 8, 8))];
                textField.tag = 17;
                textField.text = self.string;
                textField.rightViewMode = UITextFieldViewModeWhileEditing;
                textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                textField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                textField.textColor = [UIColor grayColor];
                textField.keyboardType = UIKeyboardTypePhonePad;
                textField.backgroundColor = [UIColor clearColor];
                [textField addTarget:self
                              action:@selector(onTextFieldChanged:)
                    forControlEvents:UIControlEventEditingChanged];
                [textField becomeFirstResponder];
                [cell.contentView addSubview:textField];
            }
        }
            break;
        case EditingTypeDate:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell.contentView viewWithTag:17]) {
                UIDateField *dateField = [[UIDateField alloc] initWithFrame:UIEdgeInsetsInsetRect(cell.contentView.bounds, UIEdgeInsetsMake(8, 8, 8, 8))];
                dateField.tag = 17;
                dateField.text = self.string;
                dateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                dateField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                dateField.backgroundColor = [UIColor clearColor];
                [dateField addTarget:self
                              action:@selector(onTextFieldChanged:)
                    forControlEvents:UIControlEventEditingChanged];
                [dateField becomeFirstResponder];
                [cell.contentView addSubview:dateField];
            }
        }
            break;
        case EditingTypeDateTime:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell.contentView viewWithTag:17]) {
                UIDateField *dateField = [[UIDateField alloc] initWithFrame:UIEdgeInsetsInsetRect(cell.contentView.bounds, UIEdgeInsetsMake(8, 8, 8, 8))];
                dateField.tag = 17;
                dateField.text = self.string;
                dateField.canSelectTime = YES;
                dateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                dateField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                dateField.backgroundColor = [UIColor clearColor];
                [dateField addTarget:self
                              action:@selector(onTextFieldChanged:)
                    forControlEvents:UIControlEventEditingChanged];
                [dateField becomeFirstResponder];
                [cell.contentView addSubview:dateField];
            }
        }
            break;
        case EditingTypeTextView:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell.contentView viewWithTag:17]) {
                UITextView *textView = [[UITextView alloc] initWithFrame:UIEdgeInsetsInsetRect(cell.contentView.bounds, UIEdgeInsetsMake(8, 8, 8, 8))];
                textView.delegate = self;
                textView.tag = 17;
                textView.text = self.string;
                textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                textView.textColor = [UIColor grayColor];
                textView.backgroundColor = [UIColor clearColor];
                [textView becomeFirstResponder];
                [cell.contentView addSubview:textView];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.type) {
        case EditingTypeOptions:
            self.string = self.options[indexPath.row];
            [tableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.string = textView.text;
}

@end
