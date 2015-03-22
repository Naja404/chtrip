//
//  WTLocationManager.h
//  WithTrip
//
//  Created by Zhou Bin on 14-5-8.
//  Copyright (c) 2014年 Zhou Bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^Success)(CLLocationCoordinate2D location);
typedef void (^Failure)(NSError *error);

@interface WTLocationManager : NSObject

@property (nonatomic, strong) Success successBlock;
@property (nonatomic, strong) Failure failureBlock;

- (void)getCurrentLocationSuccess:(Success)success
                          failure:(Failure)failure;
@end
