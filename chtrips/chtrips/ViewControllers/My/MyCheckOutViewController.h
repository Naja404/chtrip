//
//  MyCheckOutViewController.h
//  chtrips
//
//  Created by Hisoka on 16/1/11.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MyCheckOutViewControllerDelegate <NSObject>

- (void) popToRootVC;

@end

@interface MyCheckOutViewController : UIViewController

@property (nonatomic, strong) NSString *addressId;

@property (nonatomic, weak) id<MyCheckOutViewControllerDelegate> myCheckOutDelegate;

@end
