//
//  ZLoginViewController.m
//  ZWork
//
//  Created by ricky on 14-3-22.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZLoginViewController.h"

@interface ZLoginViewController ()
@property (nonatomic, assign) IBOutlet UIImageView * logo;
- (IBAction)onDismiss:(id)sender;
- (IBAction)onHideKeyboard:(id)sender;
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

@end
