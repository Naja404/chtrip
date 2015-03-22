//
//  AddSubTripLocationViewController.h
//  chtrips
//
//  Created by Hisoka on 15/3/19.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddSubTripLocationViewControllerDelegate <NSObject>

- (void) setupSubLocationText:(NSString *)Address Lat:(NSString *)lat Lng:(NSString *)lng;

@end

@interface AddSubTripLocationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, weak) id<AddSubTripLocationViewControllerDelegate> AddSubLocationDelegate;

@end
