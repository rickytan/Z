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

@interface ZImageAttachmentCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@end

@implementation ZImageAttachmentCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}
@end

@interface ZNeedViewController ()
<ZEditingViewControllerDelegate,
UITextFieldDelegate,
UITextViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
@property (nonatomic, readonly) UITextField * subjectField;
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
@synthesize descriptionView = _descriptionView;

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
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 36)];
    textField.borderStyle = UITextBorderStyleLine;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:18];
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

- (UITextView *)descriptionView
{
    if (!_descriptionView) {
        _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 220, 100)];
        _descriptionView.font = [UIFont systemFontOfSize:12];
        _descriptionView.delegate = self;
        _descriptionView.dataDetectorTypes = UIDataDetectorTypeAll;
        _descriptionView.layer.borderColor = [UIColor blackColor].CGColor;
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

}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return textField.text.length - range.length + string.length <= 50;
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
    UITableViewCell *cell = nil;

    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"
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
                default:
                    cell.textLabel.text = nil;
                    cell.imageView.image = [self.attachedImages objectAtIndex:indexPath.row - 2];
                    break;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == self.attachedImages.count) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"AddImageCell"
                                                       forIndexPath:indexPath];
                cell.textLabel.text = @"添加图片";
                return cell;
            }
            cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"
                                                   forIndexPath:indexPath];
            cell.imageView.image = [self.attachedImages objectAtIndex:indexPath.row];
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"
                                                   forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"报酬：";
                    cell.detailTextLabel.text = [self.myNeed objectForKey:@"payment"];
                    break;
                case 1:
                {
                    cell.textLabel.text = @"需要人数：";
                    NSNumber *number = (NSNumber *)[self.myNeed objectForKey:@"numOfPeople"];
                    cell.detailTextLabel.text = number.stringValue;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"
                                                   forIndexPath:indexPath];
            cell.textLabel.text = @"时间：";
            NSDate *expire = (NSDate *)[self.myNeed objectForKey:@"expire"];
            cell.detailTextLabel.text = [expire stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
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
            
        }
            break;
        case 3:
        {
            ZEditingViewController *edit = [[ZEditingViewController alloc] init];
            edit.type = EditingTypeDateTime;
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
        picker.allowsEditing = NO;
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

}

- (void)editingViewControllerDidCancelEditing:(ZEditingViewController *)controller
{

}

#pragma mark - UIImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
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
