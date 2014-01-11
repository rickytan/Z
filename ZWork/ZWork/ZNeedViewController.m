//
//  ZNeedViewController.m
//  ZWork
//
//  Created by ricky on 13-12-24.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZNeedViewController.h"
#import "ZEditingViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "NSDate+RExtension.h"
#import "ZPaymentSettingViewController.h"
#import "SVProgressHUD.h"

@interface ZImageAttachmentCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@end

@implementation ZImageAttachmentCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    self.imageView.frame = self.contentView.bounds;
}

@end

@interface ZTextCell : UITableViewCell
@end

@implementation ZTextCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect;
    rect = self.textLabel.frame;
    rect.origin.y = 10;
    self.textLabel.frame = rect;
    rect = self.detailTextLabel.frame;
    rect.origin.y = (CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(rect)) / 2;
    self.detailTextLabel.frame = rect;
    rect = self.accessoryView.frame;
    rect.origin.x = CGRectGetWidth(self.frame) - 14 - CGRectGetWidth(rect);
    self.accessoryView.frame = rect;
}
@end

@interface ZNeedViewController ()
<ZEditingViewControllerDelegate,
UITextFieldDelegate,
UITextViewDelegate,
ZPaymentSettingDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
@property (nonatomic, readonly) UITextField * subjectField;
@property (nonatomic, readonly) UITextField * numberOfPeopleField;
@property (nonatomic, readonly) UITextView * descriptionView;
@property (nonatomic, strong) AVObject * myNeed;
@property (nonatomic, strong) NSMutableArray * attachedImages;
@property (nonatomic, assign) NSInteger maxAttachedImage;
@property (nonatomic, assign) BOOL hideAddImageCell;
- (IBAction)onDismiss:(id)sender;
- (IBAction)onDone:(id)sender;
@end

@implementation ZNeedViewController
@synthesize subjectField = _subjectField;
@synthesize numberOfPeopleField = _numberOfPeopleField;
@synthesize descriptionView = _descriptionView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Payment"]) {
        ((ZPaymentSettingViewController *)segue.destinationViewController).delegate = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.maxAttachedImage = 3;
    self.attachedImages = [NSMutableArray array];

    self.myNeed = [AVObject objectWithClassName:@"Need"];
    [self.myNeed setObject:@""
                    forKey:@"title"];
    [self.myNeed setObject:@""
                    forKey:@"details"];
    [self.myNeed setObject:@"同学一场，怎么好意思要钱呢…"
                    forKey:@"payment"];
    [self.myNeed setObject:[NSNumber numberWithInteger:1]
                    forKey:@"numOfPeople"];
    [self.myNeed setObject:[NSDate dateWithTimeIntervalSinceNow:7 * 24 * 3600]
                    forKey:@"expire"];
    self.tableView.editing = YES;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (UITextField *)newTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 210, 36)];
    textField.borderStyle = UITextBorderStyleLine;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:18];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

- (UITextField *)subjectField
{
    if (!_subjectField) {
        _subjectField = [self newTextField];
        _subjectField.placeholder = @"标题不得超过50字！";
    }
    return _subjectField;
}

- (UITextField *)numberOfPeopleField
{
    if (!_numberOfPeopleField) {
        _numberOfPeopleField = [self newTextField];
        _numberOfPeopleField.frame = CGRectMake(0, 0, 64, 36);
        _numberOfPeopleField.tag = 10;
        _numberOfPeopleField.textAlignment = NSTextAlignmentRight;
        _numberOfPeopleField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numberOfPeopleField;
}

- (UITextView *)descriptionView
{
    if (!_descriptionView) {
        _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 210, 100)];
        _descriptionView.font = [UIFont systemFontOfSize:12];
        _descriptionView.backgroundColor = [UIColor clearColor];
        _descriptionView.delegate = self;
        _descriptionView.dataDetectorTypes = UIDataDetectorTypeAll;
        _descriptionView.layer.borderColor = [UIColor blackColor].CGColor;
        _descriptionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _descriptionView.layer.borderWidth = 1;
    }
    return _descriptionView;
}

#pragma mark - Actions

- (IBAction)onDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{

                             }];
}

- (IBAction)onDone:(id)sender
{
    [self.view endEditing:YES];

    NSInteger count = 0;
    for (UIImage *image in self.attachedImages) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
        AVFile *file = [AVFile fileWithName:@"image.jpg"
                                       data:imageData];
        [file saveInBackground];
        [self.myNeed setObject:file
                        forKey:[NSString stringWithFormat:@"image%d", count++]];
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.myNeed saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功！"];
            [self dismissViewControllerAnimated:YES
                                     completion:NULL];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"发布失败！"];
        }
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return textField.text.length - range.length + string.length <= 50;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10)
        [self.myNeed setObject:[NSNumber numberWithInt:textField.text.intValue]
                        forKey:@"numOfPeople"];
    else
        [self.myNeed setObject:textField.text
                        forKey:@"title"];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.myNeed setObject:textView.text
                    forKey:@"details"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return (int []){2, self.attachedImages.count + !self.hideAddImageCell, 2, 1}[section];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 120;
    }
    else if (indexPath.section == 1) {
        if ( indexPath.row == self.attachedImages.count &&
            self.attachedImages.count < self.maxAttachedImage)
            return 44;
        return 80;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"
                                                                    forIndexPath:indexPath];
            cell.detailTextLabel.text = nil;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"标题：";
                    cell.accessoryView = self.subjectField;
                    self.subjectField.text = [self.myNeed objectForKey:@"title"];
                    break;
                case 1:
                    cell.textLabel.text = @"说明：";
                    cell.accessoryView = self.descriptionView;
                    self.descriptionView.text = [self.myNeed objectForKey:@"details"];
                    break;
            }
            return cell;
        }
            break;
        case 1:
        {
            if (indexPath.row == self.attachedImages.count) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddImageCell"
                                                                        forIndexPath:indexPath];
                cell.textLabel.text = @"添加图片";
                return cell;
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"
                                                                    forIndexPath:indexPath];
            cell.imageView.image = [self.attachedImages objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"
                                                                            forIndexPath:indexPath];
                    cell.textLabel.text = @"报酬：";
                    cell.detailTextLabel.text = [self.myNeed objectForKey:@"payment"];
                    cell.accessoryView = nil;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"
                                                                            forIndexPath:indexPath];
                    cell.textLabel.text = @"需要人数：";
                    cell.detailTextLabel.text = nil;
                    cell.accessoryView = self.numberOfPeopleField;
                    NSNumber *number = (NSNumber *)[self.myNeed objectForKey:@"numOfPeople"];
                    self.numberOfPeopleField.text = number.stringValue;
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"
                                                                    forIndexPath:indexPath];
            cell.textLabel.text = @"时间：";
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSDate *expire = (NSDate *)[self.myNeed objectForKey:@"expire"];
            cell.detailTextLabel.text = [expire stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            return cell;
        }
            break;
        default:
            break;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            if (indexPath.row == self.attachedImages.count)
                [self tableView:tableView
             commitEditingStyle:UITableViewCellEditingStyleInsert
              forRowAtIndexPath:indexPath];
        }
            break;
        case 2:
        {
            if (indexPath.row == 0)
                [self performSegueWithIdentifier:@"Payment"
                                          sender:self];
        }
            break;
        case 3:
        {
            ZEditingViewController *edit = [[ZEditingViewController alloc] init];
            edit.type = EditingTypeDateTime;
            edit.delegate = self;
            edit.string = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
            [self.navigationController pushViewController:edit
                                                 animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;

        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker
                           animated:YES
                         completion:NULL];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.attachedImages removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationBottom];
        if (self.hideAddImageCell) {
            self.hideAddImageCell = NO;
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.attachedImages.count
                                                                        inSection:1]]
                                  withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == self.attachedImages.count) ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

#pragma mark - ZEditView Delegate

- (void)editingViewController:(ZEditingViewController *)controller
        didEndEditingWithText:(NSString *)text
{
    [self.myNeed setObject:[NSDate dateFromString:text
                                       withFormat:@"yyyy-MM-dd HH:mm:ss"]
                    forKey:@"expire"];
    [self.tableView reloadData];
}

#pragma mark ZPayment Delegate

- (void)paymentSettingController:(ZPaymentSettingViewController *)controller didEndEditingWithText:(NSString *)text
{
    [self.myNeed setObject:text
                    forKey:@"payment"];
    [self.tableView reloadData];
}

#pragma mark - UIImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSInteger count = self.attachedImages.count;
    [self.attachedImages addObject:image];

    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:count
                                                                    inSection:1]]
                              withRowAnimation:UITableViewRowAnimationTop];
        if (self.attachedImages.count == self.maxAttachedImage) {
            self.hideAddImageCell = YES;
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.maxAttachedImage
                                                                        inSection:1]]
                                  withRowAnimation:UITableViewRowAnimationBottom];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
}

@end
