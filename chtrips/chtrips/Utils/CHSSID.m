//
//  SSID.m
//  chtrips
//
//  Created by Hisoka on 15/5/31.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CHSSID.h"
#import "TMCache.h"

static NSString * const USER_SSID = @"SSID";

@implementation CHSSID

+ (NSString *)pathForSSID {
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documents stringByAppendingPathComponent:@"ssid"];
}

+ (void) setSSID:(NSString *)ssid {
    NSError *error = nil;
    [ssid writeToFile:[CHSSID pathForSSID] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&error];
    
    if (!error) {
        [[TMCache sharedCache] setObject:ssid forKey:USER_SSID];
    }
}

+ (NSString *) SSID {
    NSString *ssid = [[TMCache sharedCache] objectForKey:USER_SSID];
    
    if (!ssid) {
        NSError *error = nil;
        ssid = [NSString stringWithContentsOfFile:[CHSSID pathForSSID] encoding:NSStringEncodingConversionAllowLossy error:&error];
        
        if (!error) {
            [[TMCache sharedCache] setObject:ssid forKey:USER_SSID];
        }
    }
    
    return ssid;
}

+ (void) removeSSID {
    [[TMCache sharedCache] removeObjectForKey:USER_SSID];
    
    [[NSFileManager defaultManager] removeItemAtPath:[CHSSID pathForSSID] error:nil];
}



@end
