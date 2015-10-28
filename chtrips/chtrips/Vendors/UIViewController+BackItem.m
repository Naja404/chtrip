//
//  UIViewController+BackItem.m
//  GJPersonal
//
//  Created by 周彬 on 15/7/22.
//  Copyright (c) 2015年 xinyi. All rights reserved.
//

#import "UIViewController+BackItem.h"
#import <objc/runtime.h>

static void *CALL_BACK_KEY;

@implementation UIViewController (BackItem)

- (UIButton *)customizedButton {
    UIImage *imgage=[UIImage imageNamed:@"arrowLeft"];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgage.size.width + 5, imgage.size.height)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setImage:imgage forState:UIControlStateNormal];
    return button;
}

- (void)customizeBackItemWithCallBack:(Callback)callBack {
    objc_setAssociatedObject(self, &CALL_BACK_KEY, callBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIButton *button = [self customizedButton];
    [button addTarget:self action:@selector(backbuttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)customizeBackItem {
    UIButton *button = [self customizedButton];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void) customizeBackItemWithDismiss {
    UIButton *button = [self customizedButton];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    [button addTarget:self action:@selector(dismissBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void) dismissBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backbuttonAction {
    Callback callback = objc_getAssociatedObject(self, &CALL_BACK_KEY);
    callback();
}

@end
