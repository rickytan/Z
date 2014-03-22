//
//  ZAppDelegate.m
//  ZWork
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

@implementation ZAppDelegate

- (void)setupUI
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont: [UIFont systemFontOfSize:20],
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
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:1.0
                                                                     alpha:1.0]];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"UI7NavigationBarBackButton.png"]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: DEFAULT_COLOR_SCHEME,
                                                               UITextAttributeFont: [UIFont systemFontOfSize:16],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                                    forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithRed:0
                                                                                                         green:122.0/255
                                                                                                          blue:1.0
                                                                                                         alpha:0.6],
                                                               UITextAttributeFont: [UIFont systemFontOfSize:16],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                                    forState:UIControlStateHighlighted];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor grayColor],
                                                               UITextAttributeFont: [UIFont systemFontOfSize:16],
                                                               UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero]}
                                                    forState:UIControlStateDisabled];
        [[UIBarButtonItem appearance] setTintColor:DEFAULT_COLOR_SCHEME];
        [[UITabBar appearance] setTintColor:[UIColor colorWithWhite:0.94
                                                              alpha:1.0]];
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
    }
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupUI];
    
    [AVOSCloud setApplicationId:@"6ukj16pp78un0qjf7x04w3vr1swluyj6kljur7j4hisu2iys"
                      clientKey:@"91t0va30iry17r2b4ielpr970f1x16v8uaqm5csgx71ju5l4"];
    [AVOSCloud useAVCloudCN];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo
                     withAppKey:@"584509756"
                   andAppSecret:@"3cd48b3a1c43d629d9e56a74b468857a"
                 andRedirectURI:@"https://api.weibo.com/oauth2/default.html"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:launchOptions];
    
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
