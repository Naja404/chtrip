//
//  AddSubTripViewController.h
//  chtrips
//
//  Created by Hisoka on 15/3/13.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  AddSubTripViewControllerDelegate <NSObject>

- (void) refreshTableView;

@end

@interface AddSubTripViewController : UIViewController

@property (nonatomic, strong) NSString *keyID;
@property (nonatomic, strong) NSNumber *subDate;
@property (nonatomic, weak) id<AddSubTripViewControllerDelegate> addSubTripDelegate;

@end
