//
//  UIViewController+BackItem.h
//  GJPersonal
//
//  Created by 周彬 on 15/7/22.
//  Copyright (c) 2015年 xinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Callback)();

@interface UIViewController (BackItem) <UIGestureRecognizerDelegate>

- (void)customizeBackItemWithCallBack:(Callback)callBack;
- (void)customizeBackItem;
- (void)customizeBackItemWithDismiss;
@end
