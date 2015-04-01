//
//  ChtripCDManager.h
//  chtrips
//
//  Created by Hisoka on 15/3/12.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChtripCDManager : NSObject

- (NSArray *) getAllTrip;
- (NSArray *) getSubTripLastDateByKeyID:(NSString *)keyID;
- (BOOL) addTrip:(NSDictionary *) tripData;
- (BOOL) addSubTripSections:(NSDictionary *) subTripData;
- (BOOL) updateSubTrip:(NSDictionary *)subTripData;
- (BOOL) addBuy:(NSDictionary *)buyData;
- (BOOL) updateBuy:(NSDictionary *)buyData;
- (void) deleteSubTrip:(NSString *)keyID subID:(NSString *)subID;
- (NSString *) deletesubTripWithDay:(NSString *)keyID subDate:(NSString *)subDate isAll:(BOOL)isAll;
- (void) deleteTrip:(NSString *)keyID;
- (NSString *) makeKeyID;

@end
