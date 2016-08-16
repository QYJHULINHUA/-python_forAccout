//
//  AppDelegate.m
//  PythonServierDemo
//
//  Created by linhua hu on 16/7/29.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "IHFMDicViewController.h"
#define FRAMEWORK_BUNDLE [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"iChat_Resource" ofType:@"bundle"]]

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:FRAMEWORK_BUNDLE];
    UINavigationController *navgaController = [[UINavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController = navgaController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)nowWindow {
    
    //    是非支持横竖屏
    if (_allowRotation) {
        return UIInterfaceOrientationMaskLandscapeRight;
        
    } else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}





@end
