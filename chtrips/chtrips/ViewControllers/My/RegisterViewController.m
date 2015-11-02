//
//  RegisterViewController.m
//  chtrips
//
//  Created by Hisoka on 15/10/31.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserProtocolViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *mobileTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *rePwdTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self setRegStyle];
}

- (void) setRegStyle {
    self.navigationItem.title = NSLocalizedString(@"TEXT_REGISTER", nil);
    self.view.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_CONFIRM", nil) style:UIBarButtonItemStyleDone target:self action:@selector(userRegAction)];
    
    UILabel *mobileLB = [UILabel newAutoLayoutView];
    [self.view addSubview:mobileLB];
    
    [mobileLB autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [mobileLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [mobileLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    mobileLB.textAlignment = NSTextAlignmentLeft;
    mobileLB.text = NSLocalizedString(@"BTN_MOBILE", nil);
    mobileLB.backgroundColor = [UIColor whiteColor];
    mobileLB.textColor = BLACK_COLOR_CITY_NAME;
    
    UILabel *lineUpLB = [UILabel newAutoLayoutView];
    [self.view addSubview:lineUpLB];
    
    [lineUpLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:mobileLB];
    [lineUpLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:5];
    [lineUpLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 1)];
    lineUpLB.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    UILabel *pwdLB = [UILabel newAutoLayoutView];
    [self.view addSubview:pwdLB];
    
    [pwdLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineUpLB];
    [pwdLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:mobileLB];
    [pwdLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    pwdLB.backgroundColor = [UIColor whiteColor];
    pwdLB.text = NSLocalizedString(@"BTN_PASSWD", nil);
    pwdLB.textAlignment = NSTextAlignmentLeft;
    pwdLB.textColor = BLACK_COLOR_CITY_NAME;
    
    UILabel *lineDownLB = [UILabel newAutoLayoutView];
    [self.view addSubview:lineDownLB];
    
    [lineDownLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pwdLB];
    [lineDownLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:5];
    [lineDownLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 1)];
    lineDownLB.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    UILabel *rePwdLB = [UILabel newAutoLayoutView];
    [self.view addSubview:rePwdLB];
    
    [rePwdLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineDownLB];
    [rePwdLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:pwdLB];
    [rePwdLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 60)];
    rePwdLB.backgroundColor = [UIColor whiteColor];
    rePwdLB.text = NSLocalizedString(@"BTN_PASSWD_AGAIN", nil);
    rePwdLB.textAlignment = NSTextAlignmentLeft;
    rePwdLB.textColor = BLACK_COLOR_CITY_NAME;
    
    UILabel *noticLB = [UILabel newAutoLayoutView];
    [self.view addSubview:noticLB];
    
    [noticLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:rePwdLB withOffset:3];
    [noticLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:2];
    [noticLB autoSetDimensionsToSize:CGSizeMake(220, 13)];
    noticLB.font = [UIFont systemFontOfSize:12.0f];
    noticLB.textColor = GRAY_FONT_COLOR;
    noticLB.text = NSLocalizedString(@"TEXT_REGISTER_PROTOCOL", nil);
    noticLB.textAlignment = NSTextAlignmentLeft;
    
    UIButton *viewProBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:viewProBTN];
    
    [viewProBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:rePwdLB withOffset:3];
    [viewProBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:2];
    [viewProBTN autoSetDimensionsToSize:CGSizeMake(40, 13)];
    [viewProBTN setTitle:NSLocalizedString(@"TEXT_VIEW_REGISTER_PROTOCOL", nil) forState:UIControlStateNormal];
    [viewProBTN setTitleColor:GRAY_FONT_COLOR forState:UIControlStateNormal];
    viewProBTN.titleLabel.textAlignment = NSTextAlignmentRight;
    viewProBTN.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [viewProBTN addTarget:self action:@selector(viewProtocol) forControlEvents:UIControlEventTouchUpInside];

    
    self.mobileTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_mobileTF];
    
    [_mobileTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:mobileLB];
    [_mobileTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:mobileLB withOffset:100];
    [_mobileTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 140, 40)];
    _mobileTF.placeholder = NSLocalizedString(@"TEXT_INPUT_MOBILE", nil);
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [_mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.pwdTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_pwdTF];
    
    [_pwdTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:pwdLB];
    [_pwdTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:pwdLB withOffset:100];
    [_pwdTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 140, 40)];
    _pwdTF.placeholder = NSLocalizedString(@"TEXT_INPUT_PASSWD", nil);
    [_pwdTF setSecureTextEntry:YES];
    
    self.rePwdTF = [UITextField newAutoLayoutView];
    [self.view addSubview:_rePwdTF];
    
    [_rePwdTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:rePwdLB];
    [_rePwdTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:rePwdLB withOffset:100];
    [_rePwdTF autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 140, 40)];
    _rePwdTF.placeholder = NSLocalizedString(@"TEXT_INPUT_PASSWD_AGAIN", nil);
    [_rePwdTF setSecureTextEntry:YES];
    
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_mobileTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
    [_rePwdTF resignFirstResponder];
}

- (void) viewProtocol {
    UserProtocolViewController *userProVC = [[UserProtocolViewController alloc] init];
    [self.navigationController pushViewController:userProVC animated:YES];
}

- (void) userRegAction {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
