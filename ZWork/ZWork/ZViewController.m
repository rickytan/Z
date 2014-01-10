//
//  ZViewController.m
//  ZWork
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZViewController ()
@property (nonatomic, assign) IBOutlet UIButton *button1;
@property (nonatomic, assign) IBOutlet UIButton *button2;
@end

@implementation ZViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
