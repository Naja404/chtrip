//
//  DeviceTokenManager.h
//  chtrips
//
//  Created by Hisoka on 15/5/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceTokenManager : NSObject

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic) BOOL hasRegisteredOnServer;


@end
