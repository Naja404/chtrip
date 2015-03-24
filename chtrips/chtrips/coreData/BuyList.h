//
//  BuyList.h
//  chtrips
//
//  Created by Hisoka on 15/3/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BuyList : NSManagedObject

@property (nonatomic, retain) NSString * keyID;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * createdTime;
@property (nonatomic, retain) NSString * checkStatus;

@end
