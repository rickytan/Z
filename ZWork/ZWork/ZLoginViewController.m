//
//  ZLoginViewController.m
//  ZWork
//
//  Created by ricky on 14-3-22.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZLoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "NSString+Email.h"

@interface ZLoginViewController () <UIAlertViewDelegate>
@property (nonatomic, assign) IBOutlet UIImageView * logo;
@property (nonatomic, assign) IBOutlet UITextField * username;
@property (nonatomic, assign) IBOutlet UITextField * password;
@property (nonatomic, assign) UIViewController     * loginController;
- (IBAction)onDismiss:(id)sender;
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onWeibo:(id)sender;
- (IBAction)onQQ:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onForget:(id)sender;
@end

@implementation ZLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onHideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)onForget:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入您的注册邮箱"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"好", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)onLogin:(id)sender
{
    if (self.username.text.length == 0) {
        [self.username becomeFirstResponder];
        return;
    }
    
    if (self.password.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"至少六位吧"];
        [self.password becomeFirstResponder];
        return;
    }
    
    NSString *regExp = @"[a-zA-Z0-9._%+-]+@([A-Za-z0-9-]+\\.)+[a-zA-Z]{2,4}";
    NSPredicate *match = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regExp];
    if (![match evaluateWithObject:self.username.text]) {
        [SVProgressHUD showErrorWithStatus:@"邮箱不合法！"];
        [self.username becomeFirstResponder];
        return;
    }
    
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [AVUser logInWithUsernameInBackground:self.username.text
                                 password:self.password.text
                                    block:^(AVUser *user, NSError *error) {
                                        if (!error) {
                                            [self dismissViewControllerAnimated:YES completion:NULL];
                                            [SVProgressHUD showSuccessWithStatus:@"登录成功！"];
                                        }
                                        else {
                                            [SVProgressHUD showErrorWithStatus:@"登录失败！"];
                                        }
                                    }];
}

- (IBAction)onWeibo:(id)sender
{
    [self signInWithType:AVOSCloudSNSSinaWeibo];
}

- (IBAction)onQQ:(id)sender
{
    [self signInWithType:AVOSCloudSNSQQ];
}

- (void)signInWithType:(AVOSCloudSNSType)type
{
    [self.view makeToastActivity];
    
    typeof(self) weakSelf = self;
    self.loginController = [AVOSCloudSNS loginManualyWithCallback:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        [AVUser loginWithAuthData:object
                            block:^(AVUser *user, NSError *error) {
                                if (!error) {
                                    user.username = object[@"username"];
                                    AVFile *file = [AVFile fileWithURL:object[@"avatar"]];
                                    [user setObject:file
                                             forKey:@"avatar"];
                                    [user saveInBackground];
                                }
                                [weakSelf.view hideToastActivity];
                                if (weakSelf.loginController)
                                    [weakSelf.loginController dismissViewControllerAnimated:YES
                                                                                 completion:^{
                                                                                     [weakSelf dismissViewControllerAnimated:YES
                                                                                                                  completion:NULL];
                                                                                 }];
                                else
                                    [weakSelf dismissViewControllerAnimated:YES
                                                                 completion:NULL];
                            }];
    }
                                                       toPlatform:type];
    if (self.loginController) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.loginController];
        [self presentViewController:nav
                           animated:YES
                         completion:NULL];
    }
}

#pragma mark - UIAlert

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [AVUser requestPasswordResetForEmailInBackground:[alertView textFieldAtIndex:0].text
                                                   block:^(BOOL succeeded, NSError *error) {
                                                       if (succeeded) {
                                                           [self.view makeToast:@"已发送，请注意查收！"];
                                                       }
                                                       else {
                                                           [self.view makeToast:error.localizedDescription];
                                                       }
                                                   }];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return [alertView textFieldAtIndex:0].text.isValidEmail;
}

@end
