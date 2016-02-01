//
//  MyInfoMobileViewController.m
//  chtrips
//
//  Created by Hisoka on 15/11/6.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoMobileViewController.h"

@interface MyInfoMobileViewController ()

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) UITextField *mobileTF;

@end

@implementation MyInfoMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setStyle];
}

- (void) setStyle {
    self.navigationItem.title = NSLocalizedString(@"TEXT_BIND_MOBILE", nil);
    self.view.backgroundColor = GRAY_COLOR_CITY_CELL;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_CONFIRM", nil) style:UIBarButtonItemStyleDone target:self action:@selector(setUserInfoAction)];
    
    UILabel *mobileLB = [UILabel newAutoLayoutView];
    [self.view addSubview:mobileLB];
    
    [mobileLB autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [mobileLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [mobileLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    mobileLB.textAlignment = NSTextAlignmentLeft;
    mobileLB.text = [NSString stringWithFormat:@"   %@", NSLocalizedString(@"TEXT_MOBILE", nil)];
    mobileLB.backgroundColor = [UIColor whiteColor];
    mobileLB.textColor = BLACK_COLOR_CITY_NAME;
    mobileLB.font = [UIFont systemFontOfSize:16.0];
    
    self.mobileTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_mobileTF];
    
    [_mobileTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:mobileLB];
    [_mobileTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:mobileLB withOffset:80];
    [_mobileTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 120, 40)];
    _mobileTF.font = [UIFont systemFontOfSize:16.0];
    _mobileTF.text = _mobileNum;
    _mobileTF.placeholder = NSLocalizedString(@"TEXT_INPUT_MOBILE", nil);
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [_mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) setUserInfoAction {
    if (_mobileTF.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_INPUT_MOBILE", nil) maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [parameters setObject:_mobileTF.text forKey:@"mobile"];
    
    [[HttpManager instance] requestWithMethod:@"User/setInfo"
                                   parameters:parameters
                                      success:^(NSDictionary *result) {
                                          NSArray *userInfoTmp = [[result objectForKey:@"data"] objectForKey:@"user_info"];
                                          NSString *alertText = [[result objectForKey:@"data"] objectForKey:@"info"];
                                          NSString *hasBand = [[result objectForKey:@"data"] objectForKey:@"hasBand"];
                                          
                                          [[TMCache sharedCache] setObject:hasBand forKey:@"mobileHasBand"];
                                          
                                          [[TMCache sharedCache] setObject:userInfoTmp forKey:@"userInfo"];
                                          
                                          [SVProgressHUD showSuccessWithStatus:alertText maskType:SVProgressHUDMaskTypeBlack];
                                          [self.navigationController popViewControllerAnimated:YES];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _mobileTF) {
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
    if (textField == _mobileTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_mobileTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
