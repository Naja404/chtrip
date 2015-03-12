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
- (BOOL) addTrip:(NSDictionary *) tripData;
- (BOOL) addSubTripSections:(NSDictionary *) subTripData;
- (NSString *) makeKeyID;

@end
