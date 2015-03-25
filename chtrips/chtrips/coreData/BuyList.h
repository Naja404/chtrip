//
//  BuyList.h
//  Pods
//
//  Created by Hisoka on 15/3/25.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BuyList : NSManagedObject

@property (nonatomic, retain) NSString * checkStatus;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * createdTime;
@property (nonatomic, retain) NSString * keyID;
@property (nonatomic, retain) NSString * buyID;

@end
