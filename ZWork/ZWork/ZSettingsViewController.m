//
//  ZSettingsViewController.m
//  ZWork
//
//  Created by ricky on 14-3-22.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZSettingsViewController.h"
#import "RTSiderViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "SVProgressHUD.h"

@interface ZSettingsCell : UITableViewCell
@end

@implementation ZSettingsCell

- (void)awakeFromNib
{
    self.backgroundView = [[UIView alloc] init];
    self.selectedBackgroundView = [[UIView alloc] init];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] set];
    
    if (self.isHighlighted) {
        CGContextFillRect(context, rect);
    }
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextDrawPath(context, kCGPathStroke);
}

@end

@interface ZSettingsViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, assign) IBOutlet UIButton * headButton;
@property (nonatomic, assign) IBOutlet UILabel * nameLabel;
- (IBAction)onLogout:(id)sender;
- (IBAction)onHeader:(id)sender;
@end

@implementation ZSettingsViewController

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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([AVUser currentUser].isAuthenticated) {
        AVFile *avatarFile = [[AVUser currentUser] objectForKey:@"avatar"];
        [avatarFile getThumbnail:YES
                           width:160
                          height:160
                       withBlock:^(UIImage *image, NSError *error) {
                           if (!error)
                               [self.headButton setImage:image
                                                forState:UIControlStateNormal];
                       }];
        self.nameLabel.text = [AVUser currentUser].username;
    }
    else {
        [self.headButton setImage:[UIImage imageNamed:@"header.png"]
                         forState:UIControlStateNormal];
        self.nameLabel.text = @"未登录";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender
{
    [AVUser logOut];
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.siderViewController slideToMiddleAnimated:YES];
}

- (IBAction)onHeader:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"从相册选取", @"从相机拍摄", nil];
    [action showInView:self.view.window];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerControllerSourceType type = (buttonIndex == 1) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable:type]) {
            [[[UIAlertView alloc] initWithTitle:@"错误"
                                        message:@"不支持此方式！"
                                       delegate:nil
                              cancelButtonTitle:@"好"
                              otherButtonTitles:nil] show];
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = type;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker
                           animated:YES
                         completion:NULL];
    }
}

#pragma mark - UIImage Picker

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.headButton setImage:image
                     forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                                   AVFile *file = [AVFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation(image, 0.7)];
                                   [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                       if (succeeded) {
                                           [[AVUser currentUser] setObject:file
                                                                    forKey:@"avatar"];
                                           [[AVUser currentUser] saveInBackground];
                                           [SVProgressHUD showSuccessWithStatus:@"已保存！"];
                                       }
                                       else {
                                           [SVProgressHUD showErrorWithStatus:@"出错了..."];
                                       }
                                   }];
                               }];
}

#pragma mark - Table view data source

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
