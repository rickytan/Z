//
//  ZAppDelegate.m
//  ZFreshman
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZAppDelegate.h"
#import "UIColor+RExtension.h"

@implementation ZAppDelegate

- (void)setupUI
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bar.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bar.png"]
                                       forBarMetrics:UIBarMetricsLandscapePhone];
    NSDictionary *textAttr = @{UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                               UITextAttributeTextColor: [UIColor iOS7DefaultBlueTint],
                               UITextAttributeTextShadowColor: [UIColor clearColor],
                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttr];

    if (!IS_IOS_7) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:1.0
                                                                     alpha:1.0]];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"UI7NavigationBarBackButton.png"]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor iOS7DefaultBlueTint],
                                                               UITextAttributeFont: [UIFont systemFontOfSize:16],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                                    forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor lightGrayColor],
                                                               UITextAttributeFont: [UIFont systemFontOfSize:16],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                                    forState:UIControlStateHighlighted];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupUI];
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
