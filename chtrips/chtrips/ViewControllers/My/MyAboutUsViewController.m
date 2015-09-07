//
//  MyAboutUsViewController.m
//  chtrips
//
//  Created by Hisoka on 15/5/15.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyAboutUsViewController.h"

@interface MyAboutUsViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation MyAboutUsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupStyle];
}

- (void) setupStyle {
    self.webView = [[UIWebView alloc] initForAutoLayout];
    [self.view addSubview:_webView];
    
    [_webView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [_webView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_webView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_webView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.caihongtown.com/index.php?r=CHome/about"]];
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
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
