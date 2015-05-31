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

#import "ChtripCDManager.h"


#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import <FacebookConnection/ISSFacebookApp.h>
#import <TencentOpenAPI/TencentOAuth.h>

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
    
    [self setupCoreDataManager];
    [self setupShareSDK];
    
    [self regDeviceToken];
    
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
    discoveryVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_DISCOVERY", Nil) image:[UIImage imageNamed:@"tab_discovery"] tag:1];
    
    ShoppingViewController *shoppingVC = [[ShoppingViewController alloc] init];
    shoppingVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_SHOPPING", Nil) image:[UIImage imageNamed:@"tab_shopping"] tag:2];
    
    
    PlayViewController *playVC = [[PlayViewController alloc] init];
    playVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_PLAY", Nil) image:[UIImage imageNamed:@"tab_play"] tag:3];
    
    TripListViewController *tripVC = [[TripListViewController alloc] init];
    tripVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_TRIP", Nil) image:[UIImage imageNamed:@"tab_trip"] tag:4];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TEXT_MY", Nil) image:[UIImage imageNamed:@"tab_my"] tag:5];
    
    discoveryNav = [[UINavigationController alloc] initWithRootViewController:discoveryVC];
    shoppingNav = [[UINavigationController alloc] initWithRootViewController:shoppingVC];
    playNav = [[UINavigationController alloc] initWithRootViewController:playVC];
    tripNav = [[UINavigationController alloc] initWithRootViewController:tripVC];
    myNav = [[UINavigationController alloc] initWithRootViewController:myVC];
    
    NSArray *navArr = @[discoveryNav, shoppingNav, playNav, tripNav, myNav];
    
    tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setSelectedImageTintColor:[UIColor redColor]];
    [tabBarController setViewControllers:navArr animated:YES];
    
    tripNav.delegate = self;
   
    
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
    
    return YES;
}

- (void) setupShareSDK {
    [ShareSDK registerApp:@"6fea0b9aa314"];
        /**
         连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
         http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
         **/
        [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                                   appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                 redirectUri:@"http://www.sharesdk.cn"];
        
        /**
         连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
         http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
         
         如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
         **/
        [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                      appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                    redirectUri:@"http://www.sharesdk.cn"
                                       wbApiCls:[WeiboApi class]];
        
        //连接短信分享
        [ShareSDK connectSMS];
        
        /**
         连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
         http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
         
         如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
         **/
        [ShareSDK connectQZoneWithAppKey:@"100371282"
                               appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                       qqApiInterfaceCls:[QQApiInterface class]
                         tencentOAuthCls:[TencentOAuth class]];
        
        /**
         连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
         http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
         **/
        [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                               appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                               wechatCls:[WXApi class]];
        
        /**
         连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
         http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
         **/
        //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
        //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
        
        [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                         qqApiInterfaceCls:[QQApiInterface class]
                           tencentOAuthCls:[TencentOAuth class]];
        
        /**
         连接Facebook应用以使用相关功能，此应用需要引用FacebookConnection.framework
         https://developers.facebook.com上注册应用，并将相关信息填写到以下字段
         **/
        [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                                  appSecret:@"38053202e1a5fe26c80c753071f0b573"];
        
        /**
         连接Twitter应用以使用相关功能，此应用需要引用TwitterConnection.framework
         https://dev.twitter.com上注册应用，并将相关信息填写到以下字段
         **/
        [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                                 consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                    redirectUri:@"http://www.sharesdk.cn"];
        
        //连接邮件
        [ShareSDK connectMail];
        
        //连接打印
        [ShareSDK connectAirPrint];
        
        //连接拷贝
        [ShareSDK connectCopy];
    
    
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];

}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
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
