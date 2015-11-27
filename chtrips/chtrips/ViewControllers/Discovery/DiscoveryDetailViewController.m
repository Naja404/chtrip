//
//  DiscoveryDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/6/8.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "DiscoveryDetailViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SlideInViewManager.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@interface DiscoveryDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *popBTN;
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIView *slideV;
@property (nonatomic, strong) SlideInViewManager *slideVM;
@property (nonatomic, strong) NSString *slideShowState;

@end

@implementation DiscoveryDetailViewController

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

    [self setNavBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNavBar {
    
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
    
    
    
    self.slideV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    UIButton *wechat = [UIButton newAutoLayoutView];
    [_slideV addSubview:wechat];
    
    [wechat autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_slideV];
    [wechat autoAlignAxis:ALAxisVertical toSameAxisOfView:_slideV withOffset:-50];
    [wechat autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [wechat setBackgroundImage:[UIImage imageNamed:@"wechatBTN"] forState:UIControlStateNormal];
    [wechat addTarget:self action:@selector(wechatBTN) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wechatMoment = [UIButton newAutoLayoutView];
    [_slideV addSubview:wechatMoment];
    
    [wechatMoment autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_slideV];
    [wechatMoment autoAlignAxis:ALAxisVertical toSameAxisOfView:_slideV withOffset:50];
    [wechatMoment autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [wechatMoment setBackgroundImage:[UIImage imageNamed:@"wechatMomentBTN"] forState:UIControlStateNormal];
    [wechatMoment addTarget:self action:@selector(wechatMomentBTN) forControlEvents:UIControlEventTouchUpInside];
    
    _slideV.backgroundColor = GRAY_COLOR_CELL_LINE;
    
    self.slideVM = [[SlideInViewManager alloc] initWithSlideView:_slideV parentView:self.view];
    
    self.slideShowState = @"0";
    
//    UIImage *imgage=[UIImage imageNamed:@"share"];
//    UIButton *rightBTN=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgage.size.width + 5, imgage.size.height)];
//    [rightBTN setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [rightBTN setImage:imgage forState:UIControlStateNormal];
//    [rightBTN addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(showShareView)];
    self.navigationItem.rightBarButtonItem.tintColor = NAV_GRAY_COLOR;
    
    UILabel *titleLB = [UILabel newAutoLayoutView];
    [_slideV addSubview:titleLB];
    
    [titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_slideV withOffset:5];
    [titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:_slideV];
    [titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 20)];
    titleLB.text = @"分享到";
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.backgroundColor = [UIColor clearColor];
    titleLB.font = NORMAL_14FONT_SIZE;
    titleLB.textColor = COLOR_TEXT;
    
    UILabel *wechatLB = [UILabel newAutoLayoutView];
    [_slideV addSubview:wechatLB];
    
    [wechatLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:wechat withOffset:-10];
    [wechatLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:wechat];
    [wechatLB autoSetDimensionsToSize:CGSizeMake(50, 50)];
    wechatLB.text = @"微信好友";
    wechatLB.textAlignment = NSTextAlignmentCenter;
    wechatLB.backgroundColor = [UIColor clearColor];
    wechatLB.font = NORMAL_12FONT_SIZE;
    wechatLB.textColor = COLOR_TEXT;
    
    UILabel *wechatMLB = [UILabel newAutoLayoutView];
    [_slideV addSubview:wechatMLB];
    
    [wechatMLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:wechatMoment withOffset:-10];
    [wechatMLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:wechatMoment];
    [wechatMLB autoSetDimensionsToSize:CGSizeMake(50, 50)];
    wechatMLB.text = @"朋友圈";
    wechatMLB.textAlignment = NSTextAlignmentCenter;
    wechatMLB.backgroundColor = [UIColor clearColor];
    wechatMLB.font = NORMAL_12FONT_SIZE;
    wechatMLB.textColor = COLOR_TEXT;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBTN];
}

- (void) wechatBTN {
    
    [WXApiRequestHandler sendLinkURL:_webUrl
                             TagName:nil
                               Title:[_albumDic objectForKey:@"title"]
                         Description:nil
                          ThumbImage:[UIImage imageNamed:@"loginBg"]
                             InScene:WXSceneSession];
    [self showShareView];
}

- (void) wechatMomentBTN {
    
    [WXApiRequestHandler sendLinkURL:_webUrl
                             TagName:nil
                               Title:[_albumDic objectForKey:@"title"]
                         Description:nil
                          ThumbImage:[UIImage imageNamed:@"loginBg"]
                             InScene:WXSceneTimeline];
    [self showShareView];
    
}

- (void) showShareView {
    
    if ([_slideShowState isEqualToString:@"0"]) {
        _slideShowState = @"1";
        [_slideVM slideViewIn];
    }else{
        _slideShowState = @"0";
        [_slideVM slideViewOut];
    }
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
