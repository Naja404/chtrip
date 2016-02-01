//
//  MyWebViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/5.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface MyWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation MyWebViewController

- (void) viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    [self customizeBackItemWithCallBack:^{
        if (_isRoot) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setStyle];
}

- (void) setStyle {
    self.webView = [UIWebView newAutoLayoutView];
    [self.view addSubview:_webView];
    
    [_webView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_webView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_webView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_webView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    
    [_webView loadRequest:request];
    
    [WebViewJavascriptBridge enableLogging];
    
    if ([_actionName isEqualToString:@"subAddress"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_SAVE", nil) style:UIBarButtonItemStyleDone target:self action:@selector(reqSubAddress)];
    }else if ([_actionName isEqualToString:@"editAddress"]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_SAVE", nil) style:UIBarButtonItemStyleDone target:self action:@selector(reqEditAddress)];
    }

    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"objc => Right back atcha");
    }];
    
    [SVProgressHUD show];
    [self performSelector:@selector(dismissSVHUD) withObject:nil afterDelay:1.0f];

}

- (void) reqSubAddress {
    [_bridge send:@"subAddress" responseCallback:^(id responseData) {

        if([[responseData objectForKey:@"status"] isEqualToString:@"0"]){
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_SUCCESS", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"TEXT_ENTER_ERR", nil)];
        }
    }];
}

- (void) reqEditAddress {
    [_bridge send:@"editAddress" responseCallback:^(id responseData) {

        if([[responseData objectForKey:@"status"] isEqualToString:@"0"]){
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_EDIT_SUCCESS", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"TEXT_ENTER_ERR", nil)];
        }
    }];
}

- (void) dismissSVHUD {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
