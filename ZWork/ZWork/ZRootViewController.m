//
//  ZRootViewController.m
//  ZWork
//
//  Created by ricky on 14-1-10.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZRootViewController.h"
#import "RTSiderViewController.h"

@interface ZRootViewController () <RTSiderViewControllerDatasource, RTSiderViewControllerDelegate>
@property (nonatomic, readonly) UIViewController *homeController;
@end

@implementation ZRootViewController
@synthesize homeController = _homeController;

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
    RTSiderViewController *sider = [[RTSiderViewController alloc] init];
    sider.delegate = self;
    sider.dataSource = self;
    sider.translationStyle = SlideTranslationStyleHalfPull;
    [sider setMiddleViewController:self.homeController];
    [sider setRightViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Settings"]];
    [self addChildViewController:sider];
    sider.view.frame = self.view.bounds;
    sider.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:sider.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)homeController
{
    if (!_homeController) {
        _homeController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNav"];
    }
    return _homeController;
}

- (BOOL)shouldAdjustWidthOfLeftViewController
{
    return YES;
}

- (BOOL)shouldAdjustWidthOfRightViewController
{
    return YES;
}

- (CGFloat)siderViewControllerMarginForSlidingToLeft:(RTSiderViewController *)controller
{
    return 120;
}

@end
