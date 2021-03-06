//
//  MCAppDelegate.m
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#import "MCAppDelegate.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x2b87d6)];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
        [[UITabBar appearance] setTintColor:UIColorFromRGB(0x2b87d6)];
    }
    else {
        
        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x2b87d6)];
        [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0x2b87d6)];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor grayColor], UITextAttributeTextColor,
                                                           nil] forState:UIControlStateNormal];
        UIColor *titleHighlightedColor = UIColorFromRGB(0x2b87d6);
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           titleHighlightedColor, UITextAttributeTextColor,
                                                           nil] forState:UIControlStateSelected];
    }

    
    if ([self isLogged]) {
        //用户已登陆
        UIViewController *mainVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
        self.window.rootViewController = mainVC;
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)isLogged {
    //判断用户是否已登录
    NSUserDefaults *userInfo = [[NSUserDefaults alloc] init];
    NSString *strAccount = [userInfo stringForKey:@"user"];
    NSString *strPassword = [userInfo stringForKey:@"password"];
    
    return (strAccount.length >0 && strPassword.length >0);
}

@end