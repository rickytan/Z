//
//  ZSetupInfoViewController.m
//  ZWork
//
//  Created by ricky on 14-3-23.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZSetupInfoViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"

@interface ZSetupInfoViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, assign) IBOutlet UIButton * enterButton;
@property (nonatomic, assign) IBOutlet UITextField * username;
@property (nonatomic, assign) IBOutlet UIButton * headButton;
- (IBAction)onEnter:(id)sender;
- (IBAction)onHeader:(id)sender;
@end

@implementation ZSetupInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEnter:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

- (IBAction)onHeader:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"从相册选取", @"从相机拍摄", nil];
    [action showInView:self.view];
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
                                           [self onEnter:nil];
                                       }
                                       else {
                                           [SVProgressHUD showErrorWithStatus:@"出错了..."];
                                       }
                                   }];
                               }];
}

@end
