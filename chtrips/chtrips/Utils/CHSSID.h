//
//  CHSSID.h
//  chtrips
//
//  Created by Hisoka on 15/5/31.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHSSID : NSObject

// 设置ssid
+ (void) setSSID:(NSString *)ssid;
// 获取本地ssid
+ (NSString *)SSID;
// 清除ssid
+ (void)removeSSID;

@end
