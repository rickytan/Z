//
//  ZNavigationViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-22.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZNavigationViewController.h"

@interface ZNavigationViewController ()

@end

@implementation ZNavigationViewController

- (BOOL)shouldAutorotate
{
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.visibleViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

@end
