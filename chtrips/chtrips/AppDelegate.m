//
//  AppDelegate.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "DiscoveryViewController.h"
//#import "ShoppingViewController.h"
#import "ShoppingDGViewController.h"
#import "PlayViewController.h"
#import "TripListViewController.h"
#import "MyViewController.h"

#import "ChtripCDManager.h"

#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize tabBarController;
@synthesize discoveryNav;
@synthesize shoppingNav;
@synthesize playNav;
@synthesize tripNav;
@synthesize myNav;
@synthesize deviceTokens;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:2.0];
    
    [self setupCoreDataManager];
    
    [self regDeviceToken];
    
    // 设置状态栏背景色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // 判断是否第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [self setupDefaultTripData];
        self.deviceTokens = @"first";
        NSLog(@"第一次启动");
    }else{
        NSLog(@"不是第一次启动");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
///////////////////////////////////
    // tab bar modify 2015.3.30
    DiscoveryViewController *discoveryVC = [[DiscoveryViewController alloc] init];
    discoveryVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_DISCOVERY", Nil) image:[UIImage imageNamed:@"discoveryGray"] tag:1];
    
    ShoppingDGViewController *shoppingVC = [[ShoppingDGViewController alloc] init];
    shoppingVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_SHOPPING", Nil) image:[UIImage imageNamed:@"buyGray"] tag:2];
    
    
    PlayViewController *playVC = [[PlayViewController alloc] init];
    playVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_PLAY", Nil) image:[UIImage imageNamed:@"worthGray"] tag:3];
//    
//    TripListViewController *tripVC = [[TripListViewController alloc] init];
//    tripVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_TRIP", Nil) image:[UIImage imageNamed:@"tripGray"] tag:4];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_MY", Nil) image:[UIImage imageNamed:@"myGray"] tag:5];
    
    discoveryNav = [[UINavigationController alloc] initWithRootViewController:discoveryVC];
    shoppingNav = [[UINavigationController alloc] initWithRootViewController:shoppingVC];
    playNav = [[UINavigationController alloc] initWithRootViewController:playVC];
//    tripNav = [[UINavigationController alloc] initWithRootViewController:tripVC];
    myNav = [[UINavigationController alloc] initWithRootViewController:myVC];
    
    NSArray *navArr = @[discoveryNav, shoppingNav, playNav, myNav];
    
    tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setSelectedImageTintColor:[UIColor redColor]];
    [tabBarController setViewControllers:navArr animated:YES];
    
//    tripNav.delegate = self;
   
    
    [self.window makeKeyAndVisible];
    
    [self.window setRootViewController:tabBarController];
///////////////////////////////////

    // tab bar modify 2015.4.13
//    TripListViewController *rootView = [[TripListViewController alloc] init];
//    
//    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootView];
//    
//    self.window.rootViewController = rootNav;
//    
//    rootNav.navigationBar.backgroundColor = [UIColor whiteColor];
//    rootNav.navigationBar.tintColor = [UIColor grayColor];
//    rootNav.navigationBar.barStyle = UIBarStyleDefault;
//    rootNav.delegate = self;
//
//    [self.window setRootViewController:rootNav];
    [WXApi registerApp:WXAppId];
    
    return YES;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"safepay %@", resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


- (void) setupCoreDataManager
{
    [CoreDataManager sharedManager].modelName = @"chtripCD";
}

- (void) setupDefaultTripData {
//    makeDefaultTripData
    ChtripCDManager *TripCD = [[ChtripCDManager alloc] init];
    
    [TripCD makeDefaultTripData];
}

#pragma mark - 注册divicetoken
- (void) regDeviceToken {
    if (IS_OS_8_OR_LATER) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    if ([self.deviceTokens isEqualToString:@"first"]) {
        self.deviceTokens = (NSString *) deviceToken;
        [self setupSSIDWithApi:self.deviceTokens success:^{
            NSLog(@"success setupSSIDWithApi");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure setupSSIDWithApi");
        }];
        NSLog(@"第一次token");
    }
    
    NSLog(@"divice token :%@", (NSString *)deviceToken);
    
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"device error:%@", error);
}

// 设置用户ssid
- (HttpManager *) setupSSIDWithApi:(NSString *)deviceToken
                           success:(void(^)())success
                           failure:(FailureBlock)failure {
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:deviceToken forKey:@"token"];
    
    NSLog(@"paramter is %@", paramter);
    
    HttpManager *manager = [[HttpManager instance] requestWithMethod:@"Util/setToken"
                                                        parameters:paramter
                                                           success:^(NSDictionary *result) {
                                                               success();
                                                               NSDictionary *data = [[NSDictionary alloc] initWithDictionary:[result objectForKey:@"data"]];
                                                               NSLog(@"result is %@", result);
                                                               [CHSSID setSSID:[data objectForKey:@"ssid"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    return manager;
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
