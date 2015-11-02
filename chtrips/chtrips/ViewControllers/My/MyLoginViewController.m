//
//  MyLoginViewController.m
//  chtrips
//
//  Created by Hisoka on 15/10/30.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyLoginViewController.h"
#import "RegisterViewController.h"

@interface MyLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *mobileTF;
@property (nonatomic, strong) UITextField *pwdTF;

@end

@implementation MyLoginViewController

- (void) viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setLoginStyle];
    
}

#pragma mark - 设置登陆界面
- (void) setLoginStyle {
    
//    UIBarButtonItem *rightBTN = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(getLoginStatus)];
//    rightBTN.title = NSLocalizedString(@"BTN_CONFIRM", nil);
//
//    self.navigationItem.rightBarButtonItem = rightBTN;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_CONFIRM", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(getLoginStatus)];
    
    self.navigationItem.title = NSLocalizedString(@"TEXT_LOGIN", nil);
    self.view.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    UILabel *mobileLB = [UILabel newAutoLayoutView];
    [self.view addSubview:mobileLB];
    
    [mobileLB autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [mobileLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [mobileLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    mobileLB.textAlignment = NSTextAlignmentLeft;
    mobileLB.text = NSLocalizedString(@"BTN_MOBILE", nil);
    mobileLB.backgroundColor = [UIColor whiteColor];
    mobileLB.textColor = BLACK_COLOR_CITY_NAME;
    
    UILabel *lineLB = [UILabel newAutoLayoutView];
    [self.view addSubview:lineLB];
    
    [lineLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:mobileLB];
    [lineLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:5];
    [lineLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 1)];
    lineLB.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    UILabel *pwdLB = [UILabel newAutoLayoutView];
    [self.view addSubview:pwdLB];
    
    [pwdLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineLB];
    [pwdLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:mobileLB];
    [pwdLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    pwdLB.backgroundColor = [UIColor whiteColor];
    pwdLB.text = NSLocalizedString(@"BTN_PASSWD", nil);
    pwdLB.textAlignment = NSTextAlignmentLeft;
    pwdLB.textColor = BLACK_COLOR_CITY_NAME;
    
    self.mobileTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_mobileTF];
    
    [_mobileTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:mobileLB];
    [_mobileTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:mobileLB withOffset:80];
    [_mobileTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 120, 40)];
    _mobileTF.placeholder = NSLocalizedString(@"TEXT_INPUT_MOBILE", nil);
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [_mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.pwdTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_pwdTF];
    
    [_pwdTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:pwdLB];
    [_pwdTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:pwdLB withOffset:80];
    [_pwdTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 120, 40)];
    _pwdTF.placeholder = NSLocalizedString(@"TEXT_INPUT_PASSWD", nil);
    [_pwdTF setSecureTextEntry:YES];
    
    UIButton *regBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:regBTN];
    
    [regBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pwdLB withOffset:3];
    [regBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-2];
    [regBTN autoSetDimensionsToSize:CGSizeMake(100, 13)];
    [regBTN setTitle:NSLocalizedString(@"TEXT_TO_REGISTER", nil) forState:UIControlStateNormal];
    [regBTN setTitleColor:GRAY_FONT_COLOR forState:UIControlStateNormal];
    regBTN.titleLabel.textAlignment = NSTextAlignmentRight;
    regBTN.titleLabel.font = [UIFont systemFontOfSize:12.f];
    regBTN.backgroundColor = [UIColor clearColor];
    [regBTN addTarget:self action:@selector(pushRegVC) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_mobileTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
}

- (void) pushRegVC {
    RegisterViewController *regVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}

#pragma mark - 提交登录信息
- (void) getLoginStatus {
    if (_mobileTF.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_MOBILE_ERROR", nil) maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (_pwdTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PASSWD_ERROR", nil) maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [parameters setObject:_mobileTF.text forKey:@"mobile"];
    [parameters setObject:_pwdTF.text forKey:@"pwd"];
    
    NSLog(@"post data %@", parameters);
    
    [[HttpManager instance] requestWithMethod:@"User/login"
                                   parameters:parameters
                                      success:^(NSDictionary *result) {
                                          NSLog(@"login data is %@", result);
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
    
}

- (void) textFieldDidChange:(UITextField *) textField {
    if (textField == _mobileTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
