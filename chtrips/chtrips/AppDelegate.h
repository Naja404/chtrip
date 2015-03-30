//
//  AppDelegate.h
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>{
     UITabBarController *tabBarController;
     UINavigationController *discoveryNav;
     UINavigationController *shoppingNav;
     UINavigationController *playNav;
     UINavigationController *tripNav;
     UINavigationController *myNav;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *discoveryNav;
@property (nonatomic, strong) UINavigationController *shoppingNav;
@property (nonatomic, strong) UINavigationController *playNav;
@property (nonatomic, strong) UINavigationController *tripNav;
@property (nonatomic, strong) UINavigationController *myNav;

@end

