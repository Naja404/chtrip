//
//  MyInfoNickNameViewController.m
//  chtrips
//
//  Created by Hisoka on 15/11/4.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoNickNameViewController.h"

@interface MyInfoNickNameViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nickTF;

@end

@implementation MyInfoNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setStyle];
}

- (void) setStyle {
    self.navigationItem.title = NSLocalizedString(@"TEXT_EDIT_NICKNAME", nil);
    self.view.backgroundColor = GRAY_COLOR_CITY_CELL;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_CONFIRM", nil) style:UIBarButtonItemStyleDone target:self action:@selector(setUserInfoAction)];
    
    UILabel *nickNameLB = [UILabel newAutoLayoutView];
    [self.view addSubview:nickNameLB];
    
    [nickNameLB autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [nickNameLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [nickNameLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    nickNameLB.textAlignment = NSTextAlignmentLeft;
    nickNameLB.text = [NSString stringWithFormat:@"   %@", NSLocalizedString(@"TEXT_NICKNAME", nil)];
    nickNameLB.backgroundColor = [UIColor whiteColor];
    nickNameLB.textColor = BLACK_COLOR_CITY_NAME;
    nickNameLB.font = [UIFont systemFontOfSize:16.0];
    
    self.nickTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_nickTF];
    
    [_nickTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:nickNameLB];
    [_nickTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nickNameLB withOffset:80];
    [_nickTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 120, 40)];
    _nickTF.font = [UIFont systemFontOfSize:16.0];
    _nickTF.text = _nickName;
    _nickTF.placeholder = NSLocalizedString(@"TEXT_INPUT_NICKNAME", nil);
    [_nickTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) setUserInfoAction {
    if (_nickTF.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_INPUT_NICKNAME", nil) maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [parameters setObject:_nickTF.text forKey:@"nickname"];
    
    [[HttpManager instance] requestWithMethod:@"User/setInfo"
                                   parameters:parameters
                                      success:^(NSDictionary *result) {
                                          NSArray *userInfoTmp = [[result objectForKey:@"data"] objectForKey:@"user_info"];
                                          NSString *alertText = [[result objectForKey:@"data"] objectForKey:@"info"];
                                          
                                          [[TMCache sharedCache] setObject:[[result objectForKey:@"data"] objectForKey:@"nickname"] forKey:@"userName"];
                                          
                                          [[TMCache sharedCache] setObject:userInfoTmp forKey:@"userInfo"];
                                          
                                          [SVProgressHUD showSuccessWithStatus:alertText maskType:SVProgressHUDMaskTypeBlack];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _nickTF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
}

- (void) textFieldDidChange:(UITextField *) textField {
    if (textField == _nickTF) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nickTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
