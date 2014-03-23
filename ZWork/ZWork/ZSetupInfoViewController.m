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

@interface ZSetupInfoViewController ()
@property (nonatomic, assign) IBOutlet UIButton * enterButton;
@property (nonatomic, assign) IBOutlet UITextField * username;
@property (nonatomic, assign) IBOutlet UIButton * headButton;
- (IBAction)onEnter:(id)sender;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEnter:(id)sender
{
    
}

@end
