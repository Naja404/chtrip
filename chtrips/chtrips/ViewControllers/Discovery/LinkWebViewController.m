//
//  LinkWebViewController.m
//  chtrips
//
//  Created by Hisoka on 15/9/27.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "LinkWebViewController.h"
#import "UIViewController+BackItem.h"

@interface LinkWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *popBTN;


@end

@implementation LinkWebViewController


- (void) viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    //    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    //    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    [super viewDidLoad];
    [self setupUrlPage];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //    [self setupPopBTN];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupUrlPage{
    self.webView = [[UIWebView alloc] initForAutoLayout];
    [self.view addSubview:_webView];
    
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
    //            [self popToDiscovery];
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

- (void) setupPopBTN {
    self.popBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:_popBTN];
    
    [_popBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:20];
    [_popBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:20];
    [_popBTN autoSetDimensionsToSize:CGSizeMake(30, 30)];
    
    [_popBTN setBackgroundImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
    [_popBTN addTarget:self action:@selector(popToDiscovery) forControlEvents:UIControlEventTouchUpInside];
}

- (void) popToDiscovery {
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
