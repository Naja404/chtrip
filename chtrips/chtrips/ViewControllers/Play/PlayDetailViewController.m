//
//  PlayDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/7/19.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "PlayDetailViewController.h"
#import "UIViewController+BackItem.h"

@interface PlayDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *popBTN;

@end

@implementation PlayDetailViewController

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden = NO;
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUrlPage];
    [self customizeBackItem];
    [self setupAddWantGo];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 添加到我想去
- (void) setupAddWantGo {
    UIButton *addWantGoBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:addWantGoBTN];
    
    [addWantGoBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [addWantGoBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [addWantGoBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [addWantGoBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    
    [addWantGoBTN setTitle:@"我想去" forState:UIControlStateNormal];
    addWantGoBTN.backgroundColor = WANT_GO_COLOR;
    [addWantGoBTN addTarget:self action:@selector(addWantGoAction) forControlEvents:UIControlEventTouchDown];
    
}

#pragma mark 我想去事件
- (void) addWantGoAction {
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    //    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.sid forKey:@"sid"];
    NSLog(@"paramter is %@", paramter);
    [[HttpManager instance] requestWithMethod:@"User/addWantGo"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_WANT_GO", Nil) maskType:SVProgressHUDMaskTypeBlack];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (void) setupUrlPage {
    self.webView = [[UIWebView alloc] initForAutoLayout];
    [self.view addSubview:_webView];
    
    [_webView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [_webView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_webView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_webView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.webView loadRequest:request];
    
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
