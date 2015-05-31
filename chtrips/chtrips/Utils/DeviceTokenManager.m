//
//  DeviceTokenManager.m
//  chtrips
//
//  Created by Hisoka on 15/5/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "DeviceTokenManager.h"

@implementation DeviceTokenManager

+ (instancetype) sharedManager {
    static id sharedInstancetype = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstancetype = [[self alloc] init];
    });
    
    return sharedInstancetype;
}

- (void) requestForDeviceToken {
    if ([self hasRegisteredOnServer]) {
        return;
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
}

- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) data {
    NSString *deviceTokenStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

- (void) registerTokenOnServer {
    
}

@end
