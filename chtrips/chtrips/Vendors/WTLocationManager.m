//
//  WTLocationManager.m
//  WithTrip
//
//  Created by Zhou Bin on 14-5-8.
//  Copyright (c) 2014年 Zhou Bin. All rights reserved.
//

#import "WTLocationManager.h"

@interface WTLocationManager () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) MKMapView *mapView;
@end

@implementation WTLocationManager
- (void)getCurrentLocationSuccess:(Success)success
                          failure:(Failure)failure {
    self.successBlock = success;
    self.failureBlock = failure;
    
    self.manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;

    if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_manager performSelector:@selector(requestWhenInUseAuthorization)];
    }else {
        [_manager startUpdatingLocation];
    }
}

#pragma makr - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _manager.distanceFilter = kCLLocationAccuracyBest;
        [_manager startUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    _successBlock(newLocation.coordinate);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    _failureBlock(error);
}

- (void)dealloc {

}

@end
