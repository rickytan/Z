//
//  ZAboutViewController.m
//  ZWork
//
//  Created by ricky on 14-3-23.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZAboutViewController.h"

@interface ZAboutViewController ()
- (IBAction)onBack:(id)sender;
- (IBAction)onAVOS:(id)sender;
@end

@implementation ZAboutViewController

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

- (IBAction)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

- (IBAction)onAVOS:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cn.avoscloud.com/"]];
}

@end
