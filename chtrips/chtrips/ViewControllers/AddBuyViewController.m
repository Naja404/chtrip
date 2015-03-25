//
//  AddBuyViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddBuyViewController.h"
#import "ChtripCDManager.h"

#import "NSDate+Fomatter.h"
#import "NSDate-Utilities.h"

@interface AddBuyViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *contentInput;

@end

@implementation AddBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupContentInput];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 设置输入框
- (void) setupContentInput
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNav)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBuy)];;
    
    self.contentInput = [UITextField newAutoLayoutView];
    [self.view addSubview:_contentInput];
    
    [_contentInput autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_contentInput autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_contentInput autoSetDimensionsToSize:CGSizeMake(self.view.frame.size.width - 40, 150)];
    _contentInput.placeholder = NSLocalizedString(@"INPUT_BUY_LIST", Nil);
    _contentInput.returnKeyType = UIReturnKeyDone;
}

#pragma mark 保存欲购清单
- (void) saveBuy
{
    ChtripCDManager *TripCD = [[ChtripCDManager alloc] init];
    
    NSDictionary *buyData = [[NSDictionary alloc] initWithObjectsAndKeys:self.keyID, @"keyID",
                                                                        [TripCD makeKeyID], @"buyID",
                                                                        _contentInput.text, @"content",
                                                                        [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]], @"createdTime",
                                                                        @"0", @"checkStatus",
                                                                        nil];
    
    if ([TripCD addBuy:buyData]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_TRIP_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_ADD_TRIP_FAILD", Nil) maskType:SVProgressHUDMaskTypeBlack];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 取消添加
- (void) cancelNav
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
