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

@interface ZRegisterViewController ()
- (IBAction)onHideKeyboard:(id)sender;
- (IBAction)onWeibo:(id)sender;
- (IBAction)onQQ:(id)sender;
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
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        [AVUser loginWithAuthData:object
                            block:^(AVUser *user, NSError *error) {
                                
                            }];
    }
                         toPlatform:type];
}
@end
