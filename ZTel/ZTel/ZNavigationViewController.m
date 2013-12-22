//
//  ZNavigationViewController.m
//  ZTel
//
//  Created by ricky on 13-12-22.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZNavigationViewController.h"

@interface ZNavigationViewController ()

@end

@implementation ZNavigationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarItem = self.topViewController.tabBarItem;
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

@end
