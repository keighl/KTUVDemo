//
//  KTAppDelegate.m
//  KTUVDemo
//
//  Created by Kyle Truscott on 7/11/14.
//  Copyright (c) 2014 keighl. All rights reserved.
//

#import "KTAppDelegate.h"

@implementation KTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
  
    UINavigationController *navController = [UINavigationController new];
    navController.viewControllers = @[[KTUVDemoController new]];
    self.window.rootViewController = navController;
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
