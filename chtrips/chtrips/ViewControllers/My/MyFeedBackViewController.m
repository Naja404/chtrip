//
//  MyFeedBackViewController.m
//  chtrips
//
//  Created by Hisoka on 15/5/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyFeedBackViewController.h"
#import "AFNetworking.h"

@interface MyFeedBackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation MyFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeBackItem];
    [self setupStyle];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupStyle {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.textView = [[UITextView alloc] initForAutoLayout];
    self.textView = [UITextView newAutoLayoutView];
    [self.view addSubview:self.textView];
    
    [self.textView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0];
    [self.textView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10];
//    [self.textView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
//    [self.textView autoSetDimension:ALDimensionHeight toSize:200.0];
    [self.textView autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 20, 200)];
    
    self.textView.backgroundColor = GRAY_COLOR_CELL_LINE;
    self.textView.delegate = self;
    
    self.textView.textColor = COLOR_TEXT;
    self.textView.font = FONT_TEXT;
    self.textView.text =  NSLocalizedString(@"TEXT_FEEDBACK_DEFAULT", Nil);
    self.textView.textColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_SUBMIT", Nil)
                                                                style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    rightBtn.enabled = NO;
    
    UILabel *qqLB = [UILabel newAutoLayoutView];
    
    [self.view addSubview:qqLB];
    
    [qqLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.textView withOffset:20];
    [qqLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.textView];
    [qqLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 20, 20)];
    qqLB.text = NSLocalizedString(@"TEXT_CONTACT_QQ", nil);
    
    UIButton *qqNumBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:qqNumBTN];
    
    [qqNumBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:qqLB withOffset:20];
    [qqNumBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:qqLB];
    [qqNumBTN autoSetDimensionsToSize:CGSizeMake(100, 20)];
    [qqNumBTN setTitle:NSLocalizedString(@"TEXT_CONTACT_QQNUM", nil) forState:UIControlStateNormal];
    [qqNumBTN addTarget:self action:@selector(copyQQNum) forControlEvents:UIControlEventTouchUpInside];
    [qqNumBTN setTitleColor:RED_COLOR_BG forState:UIControlStateNormal];
    
    UILabel *wechatLB = [UILabel newAutoLayoutView];
    [self.view addSubview:wechatLB];
    
    [wechatLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:qqNumBTN withOffset:20];
    [wechatLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:qqNumBTN];
    [wechatLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 20, 20)];
    wechatLB.text = NSLocalizedString(@"TEXT_CONTACT_WECHAT", nil);
    
    UIButton *wechatNumBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:wechatNumBTN];
    
    [wechatNumBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:wechatLB withOffset:20];
    [wechatNumBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:wechatLB];
    [wechatNumBTN autoSetDimensionsToSize:CGSizeMake(120, 20)];
    [wechatNumBTN setTitle:NSLocalizedString(@"TEXT_CONTACT_WECHATNUM", nil) forState:UIControlStateNormal];
    [wechatNumBTN addTarget:self action:@selector(copyWechatNum) forControlEvents:UIControlEventTouchUpInside];
    [wechatNumBTN setTitleColor:RED_COLOR_BG forState:UIControlStateNormal];

}

#pragma mark - 复制QQ
- (void) copyQQNum {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = NSLocalizedString(@"TEXT_CONTACT_QQNUM", nil);
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_COPY_SUCCESS", nil)];

}

#pragma mark - 复制微信 
- (void) copyWechatNum {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = NSLocalizedString(@"TEXT_CONTACT_WECHATNUM", nil);
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_COPY_SUCCESS", nil)];
}

- (void)submit {
    NSString *text = self.textView.text;
    NSString *trimedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (trimedText.length == 0) {
        return;
    }

    
    [SVProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:trimedText forKey:@"content"];
//    [parameters setObject:[CHSSID SSID] forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.nijigo.com/"]];
    [manager GET:@"Util/feedback" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_FEEDBACK_SEND_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
//    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_FEEDBACK_SEND_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - TextView Delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    _textView.textColor = COLOR_TEXT;
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
