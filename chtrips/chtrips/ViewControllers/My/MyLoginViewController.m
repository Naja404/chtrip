//
//  MyLoginViewController.m
//  chtrips
//
//  Created by Hisoka on 15/10/30.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyLoginViewController.h"

@interface MyLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *mobielTF;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(getLoginStatus)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
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
    
    self.mobielTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_mobielTF];
    
    [_mobielTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:mobileLB];
    [_mobielTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:mobileLB withOffset:80];
    [_mobielTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 120, 40)];
    _mobielTF.placeholder = @"请输入手机号";
    _mobielTF.keyboardType = UIKeyboardTypeNumberPad;
    [_mobielTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.pwdTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_pwdTF];
    
    [_pwdTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:pwdLB];
    [_pwdTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:pwdLB withOffset:80];
    [_pwdTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 120, 40)];
    _pwdTF.placeholder = @"请输入密码";
    [_pwdTF setSecureTextEntry:YES];
    
    
}

#pragma mark - 提交登录信息
- (void) getLoginStatus {
    
}

- (void) textFieldDidChange:(UITextField *) textField {
    if (textField == _mobielTF) {
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

    if (textField == _mobielTF) {
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
