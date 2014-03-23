//
//  ZViewController.m
//  ZWork
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIView+DL.h"
#import "RTSiderViewController.h"

@interface ZViewController ()
@property (nonatomic, assign) IBOutlet UIButton * button1;
@property (nonatomic, assign) IBOutlet UIButton * button2;
@end

@implementation ZViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    if ([identifier isEqualToString:@""]) {
        
    }
    else if ([identifier isEqualToString:@""]) {
        
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.button1 setBackgroundImage:[[UIImage imageNamed:@"blueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 17, 17)]
                            forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:[[UIImage imageNamed:@"blueButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 17, 17)]
                            forState:UIControlStateHighlighted];
    
    [self.button2 setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 17, 17)]
                            forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:[[UIImage imageNamed:@"greenButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 17, 17)]
                            forState:UIControlStateHighlighted];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![AVUser currentUser].isAuthenticated) {
        UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
        c.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:c
                           animated:YES
                         completion:^{
                             
                         }];
    }
    else if ([AVUser currentUser].isNew) {
        [self.siderViewController slideToLeftAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
