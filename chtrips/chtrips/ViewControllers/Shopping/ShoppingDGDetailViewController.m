//
//  ShoppingDGDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/8/3.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDGDetailViewController.h"
#import "WebViewJavascriptBridge.h"
#import "UIViewController+BackItem.h"

@interface ShoppingDGDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge *bridge;

@end

@implementation ShoppingDGDetailViewController

- (void) viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUrlPage];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupUrlPage {
    self.webView = [[UIWebView alloc] initForAutoLayout];
    [self.view addSubview:_webView];
    
    //    [_webView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    
    [_webView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [_webView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_webView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_webView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.webView loadRequest:request];
    
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"what data is %@", data);
//        if ([data isEqualToString:@"backBTN"]) {
//            [self popToShoppingDG];
//        }
//        responseCallback(@"call back");
//    }];
    
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
- (void) popToShoppingDG {
    [self.navigationController popViewControllerAnimated:YES];
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
