//
//  AddTripViewController.h
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTripViewControllerDelegate <NSObject>

- (void)gotoEditedController:(NSString *)saveStatus keyID:(NSString *)keyID tripName:(NSString *)tripName;

@end

@interface AddTripViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<AddTripViewControllerDelegate> delegate;

@end
