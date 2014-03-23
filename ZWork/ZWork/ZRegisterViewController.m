//
//  ZRegisterViewController.m
//  ZWork
//
//  Created by ricky on 14-3-23.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZRegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface ZRegisterViewController ()
@property (nonatomic, assign) IBOutlet UITextField * username;
@property (nonatomic, assign) IBOutlet UITextField * password;
@property (nonatomic, assign) IBOutlet UITextField * confirmPass;
@property (nonatomic, assign) UIViewController     * loginController;
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onWeibo:(id)sender;
- (IBAction)onQQ:(id)sender;
- (IBAction)onReg:(id)sender;
@end

@implementation ZRegisterViewController

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

- (IBAction)onHideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)onReg:(id)sender
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
    
    if (![self.password.text isEqualToString:self.confirmPass.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致！"];
        [self.confirmPass becomeFirstResponder];
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
    AVUser *user = [AVUser user];
    user.email = self.username.text;
    user.password = self.password.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
            [self performSegueWithIdentifier:@"SetupUsername"
                                      sender:self];
        else
            [SVProgressHUD showErrorWithStatus:@"出错了..."];
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
