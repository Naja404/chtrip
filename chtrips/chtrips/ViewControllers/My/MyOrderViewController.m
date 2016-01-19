//
//  MyOrderViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyOrderViewController.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
//    __weak typeof (self) weakSelf = self;
//    [self customizeBackItemWithCallBack:^{
//        if (_isAlert) {
//            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }];
//        }else{
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        }
//    }];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setStyle];
}

- (void) viewDidAppear:(BOOL)animated {
    if (_isAlert) {
        [self showInfo];
    }
}

#pragma mark - 初始化样式
- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    

}

- (void) showInfo {
    switch (_errCode) {
        case WXSuccess:
            // 支付成功
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PAY_SUCCESS", nil)];
            break;
        case WXErrCodeCommon:
            // 支付失败
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PAY_FAILD", nil)];
            break;
        case WXErrCodeUserCancel:
            // 用户取消支付
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_CANCEL_PAY", nil)];
            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"#Error App 00366"];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
