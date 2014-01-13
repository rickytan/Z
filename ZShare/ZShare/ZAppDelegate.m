//
//  ZAppDelegate.m
//  ZShare
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import "ZAppDelegate.h"
#import "XQuquerService.h"
#import "ZShareViewController.h"

@interface ZAppDelegate ()
@property (nonatomic, assign) BOOL serverStarted;
@property (strong, nonatomic) MongooseDaemon *serverDaemon;
@end

@implementation ZAppDelegate

- (void)startServer
{
    if (self.serverStarted)
        return;

    self.serverStarted = YES;
    [self.serverDaemon startMongooseDaemon:@"7777"];
}

- (void)stopServer
{
    if (!self.serverStarted)
        return;

    self.serverStarted = NO;
    [self.serverDaemon stopMongooseDaemon];
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.serverDaemon = [[MongooseDaemon alloc] init];

    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [self application:application
                     openURL:url
           sourceApplication:nil
                  annotation:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if (url.isFileURL) {
        UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
        tab.selectedIndex = 0;
        ZShareViewController *share = (ZShareViewController *)(((UINavigationController *)tab.selectedViewController).childViewControllers.firstObject);
        [share sendFile:url.path];
        return YES;
    }
    else if ([url.scheme isEqualToString:@"zshare"]) {
        
    }
    return NO;
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
    [self.serverDaemon stopMongooseDaemon];
    self.serverDaemon = nil;
}

@end
