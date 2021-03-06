//
//  ZAppDelegate.m
//  ZTel
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZAppDelegate.h"
#import "Telephone.h"
#import "Config.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZAppDelegate

- (void)setupUI
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont: [UIFont systemFontOfSize:18],
                                                           UITextAttributeTextColor: [UIColor blackColor],
                                                           UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor],
                                                        UITextAttributeFont: [UIFont systemFontOfSize:10],
                                                        UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithRed:0.25
                                                                                                  green:0.58
                                                                                                   blue:1.0
                                                                                                  alpha:1.0],
                                                        UITextAttributeFont: [UIFont systemFontOfSize:10],
                                                        UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                             forState:UIControlStateSelected];
    
    if (!IS_IOS_7) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.94
                                                                     alpha:1.0]];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"UI7NavigationBarBackButton.png"]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor],
                                                               UITextAttributeFont: [UIFont systemFontOfSize:16],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                                    forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor],
                                                               UITextAttributeFont: [UIFont systemFontOfSize:16],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                                    forState:UIControlStateHighlighted];
        [[UITabBar appearance] setTintColor:[UIColor colorWithWhite:0.94
                                                              alpha:1.0]];
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
    }
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupUI];
    
    UIViewController *view = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"coverView"];
    view.view.layer.anchorPoint = CGPointMake(0, 0.5);
    CGPoint p = view.view.center;
    p.x = 0;
    view.view.center = p;
    if (IS_IPHONE_5)
        ((UIImageView*)view.view).image = [UIImage imageNamed:@"Default-568h.png"];
    [self.window.rootViewController.view addSubview:view.view];

    [UIView animateWithDuration:1.2
                          delay:0.2
                        options:0
                     animations:^{
                         view.view.transform = CGAffineTransformMakeTranslation(0, -800);
                     }
                     completion:^(BOOL finished) {
                         [view.view removeFromSuperview];
                     }];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
