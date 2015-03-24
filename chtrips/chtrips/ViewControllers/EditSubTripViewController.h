//
//  EditSubTripViewController.h
//  chtrips
//
//  Created by Hisoka on 15/3/23.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  EditSubTripViewControllerDelegate <NSObject>

- (void) refreshTableView;

@end

@interface EditSubTripViewController : UIViewController

@property (nonatomic, strong) NSString *keyID;
@property (nonatomic, strong) NSString *subID;
@property (nonatomic, strong) NSNumber *subDate;
@property (nonatomic, strong) NSDate *subTime;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *subTripName;
@property (nonatomic, strong) NSString *subAddressName;
@property (nonatomic, weak) id<EditSubTripViewControllerDelegate> editSubTripDelegate;

@end
