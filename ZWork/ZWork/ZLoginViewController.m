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

@interface ZLoginViewController ()
@property (nonatomic, assign) IBOutlet UIImageView * logo;
@property (nonatomic, assign) IBOutlet UITextField * username;
@property (nonatomic, assign) IBOutlet UITextField * password;
@property (nonatomic, assign) UIViewController     * loginController;
- (IBAction)onDismiss:(id)sender;
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onWeibo:(id)sender;
- (IBAction)onQQ:(id)sender;
- (IBAction)onLogin:(id)sender;
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

- (IBAction)onLogin:(id)sender
{
    if (self.username.text.length == 0) {
        [self.username becomeFirstResponder];
        return;
    }
    
    if (self.password.text.length < 6) {
        [self.password becomeFirstResponder];
        return;
    }
    
    NSString *regExp = @"[a-zA-Z0-9._%+-]+@([A-Za-z0-9-]+\\.)+[a-zA-Z]{2,4}";
    NSPredicate *match = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regExp];
    if (![match evaluateWithObject:self.username.text]) {
        [SVProgressHUD showErrorWithStatus:@"邮箱不合法！"];
        return;
    }
    
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
                                    [user setObject:object[@"avatar"]
                                             forKey:@"avatar"];
                                    [user saveEventually];
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

@end
