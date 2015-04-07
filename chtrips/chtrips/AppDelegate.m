//
//  AppDelegate.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "DiscoveryViewController.h"
#import "ShoppingViewController.h"
#import "PlayViewController.h"
#import "TripListViewController.h"
#import "MyViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize tabBarController;
@synthesize discoveryNav;
@synthesize shoppingNav;
@synthesize playNav;
@synthesize tripNav;
@synthesize myNav;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // tab bar modify 2015.3.30
//    DiscoveryViewController *discoveryVC = [[DiscoveryViewController alloc] init];
//    discoveryVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_DISCOVERY", Nil) image:[UIImage imageNamed:@"tab_discovery"] tag:1];
//    
//    ShoppingViewController *shoppingVC = [[ShoppingViewController alloc] init];
//    shoppingVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_SHOPPING", Nil) image:[UIImage imageNamed:@"tab_shopping"] tag:2];
//    
//    
//    PlayViewController *playVC = [[PlayViewController alloc] init];
//    playVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_PLAY", Nil) image:[UIImage imageNamed:@"tab_play"] tag:3];
//    
//    TripListViewController *tripVC = [[TripListViewController alloc] init];
//    tripVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_TRIP", Nil) image:[UIImage imageNamed:@"tab_trip"] tag:4];
//    
//    MyViewController *myVC = [[MyViewController alloc] init];
//    myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_MY", Nil) image:[UIImage imageNamed:@"tab_my"] tag:5];
//    
//    discoveryNav = [[UINavigationController alloc] initWithRootViewController:discoveryVC];
//    shoppingNav = [[UINavigationController alloc] initWithRootViewController:shoppingVC];
//    playNav = [[UINavigationController alloc] initWithRootViewController:playVC];
//    tripNav = [[UINavigationController alloc] initWithRootViewController:tripVC];
//    myNav = [[UINavigationController alloc] initWithRootViewController:myVC];
//    
//    NSArray *navArr = @[discoveryNav, shoppingNav, playNav, tripNav, myNav];
//    
//    tabBarController = [[UITabBarController alloc] init];
//    [tabBarController.tabBar setSelectedImageTintColor:[UIColor redColor]];
//    [tabBarController setViewControllers:navArr animated:YES];

    
    TripListViewController *rootView = [[TripListViewController alloc] init];
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootView];
    
    self.window.rootViewController = rootNav;
    
    rootNav.navigationBar.backgroundColor = [UIColor whiteColor];
    rootNav.navigationBar.tintColor = [UIColor grayColor];
    rootNav.navigationBar.barStyle = UIBarStyleDefault;
    rootNav.delegate = self;
//    tripNav.delegate = self;
    
    [self setupCoreDataManager];
    
    [self.window makeKeyAndVisible];
    
//    [self.window setRootViewController:tabBarController];
    [self.window setRootViewController:rootNav];
    
    return YES;
}

- (void) setupCoreDataManager
{
    [CoreDataManager sharedManager].modelName = @"chtripCD";
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

@end
