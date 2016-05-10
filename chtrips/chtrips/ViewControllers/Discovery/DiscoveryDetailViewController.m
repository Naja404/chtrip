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
#import "ShoppingDGDetailViewController.h"

@interface DiscoveryDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *popBTN;
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIView *slideV;
@property (nonatomic, strong) SlideInViewManager *slideVM;
@property (nonatomic, strong) NSString *slideShowState;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIBarButtonItem *collectBTN;
@property (nonatomic, strong) NSString *isCollect;
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
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [super viewDidLoad];
    
    [self isCollectAlbum];
    
    [self setupUrlPage];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

    [self setNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setNavBar {
    // 清除缓存
    [SVProgressHUD show];
    [self performSelector:@selector(dismissSVHUD) withObject:nil afterDelay:2.0f];
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
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    [_bridge registerHandler:@"toProductDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"toProductDetail called: %@", data);
        if (![[data objectForKey:@"pid"] isEqualToString:@"0"]) {
            
            ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];
            
            detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showProDetailNew?pid=%@", [data objectForKey:@"pid"]];
            detailVC.pid = [NSString stringWithFormat:@"%@", [data objectForKey:@"pid"]];
            detailVC.stock = [NSString stringWithFormat:@"%@", [data objectForKey:@"rest"]];
            detailVC.stockLB = [NSString stringWithFormat:@"%@", [data objectForKey:@"stock_label"]];
            detailVC.zhPriceStr = [NSString stringWithFormat:@"%@", [data objectForKey:@"price_zh"]];
            detailVC.navigationItem.title = [data objectForKey:@"title_zh"];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
//        responseCallback(@"Response from testObjcCallback");
    }];

//    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
//        responseCallback(@"Response from testObjcCallback");
//    }];
    
    self.bgView = [UIView newAutoLayoutView];
    [self.view addSubview:_bgView];
    
    [_bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [_bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];;
    _bgView.hidden = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)];
    
    [_bgView addGestureRecognizer:gestureRecognizer];
    
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
    
    self.slideVM = [[SlideInViewManager alloc] initWithSlideView:_slideV parentView:_bgView];
    
    self.slideShowState = @"0";
    
    UIBarButtonItem *shareBTN = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                             target:self
                                                                             action:@selector(showShareView)];
    
    self.collectBTN = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"albumCollect"] style:UIButtonTypeCustom target:self action:@selector(collectAlbum)];
    
//    self.collectBTN = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
//                                                                                target:self
//                                                                                action:@selector(collectAlbum)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
//                                                                                           target:self
//                                                                                           action:@selector(showShareView)];
    shareBTN.tintColor = NAV_GRAY_COLOR;
    _collectBTN.tintColor = NAV_GRAY_COLOR;
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareBTN, _collectBTN, nil];
    
//    self.navigationItem.rightBarButtonItem.tintColor = NAV_GRAY_COLOR;
    
    UILabel *titleLB = [UILabel newAutoLayoutView];
    [_slideV addSubview:titleLB];
    
    [titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_slideV withOffset:5];
    [titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:_slideV];
    [titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 20)];
    titleLB.text = NSLocalizedString(@"TEXT_SHARE_WITH", nil);
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.backgroundColor = [UIColor clearColor];
    titleLB.font = NORMAL_14FONT_SIZE;
    titleLB.textColor = COLOR_TEXT;
    
    UILabel *wechatLB = [UILabel newAutoLayoutView];
    [_slideV addSubview:wechatLB];
    
    [wechatLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:wechat withOffset:-10];
    [wechatLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:wechat];
    [wechatLB autoSetDimensionsToSize:CGSizeMake(50, 50)];
    wechatLB.text = NSLocalizedString(@"TEXT_WECHAT_FRIENDS", nil);
    wechatLB.textAlignment = NSTextAlignmentCenter;
    wechatLB.backgroundColor = [UIColor clearColor];
    wechatLB.font = NORMAL_12FONT_SIZE;
    wechatLB.textColor = COLOR_TEXT;
    
    UILabel *wechatMLB = [UILabel newAutoLayoutView];
    [_slideV addSubview:wechatMLB];
    
    [wechatMLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:wechatMoment withOffset:-10];
    [wechatMLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:wechatMoment];
    [wechatMLB autoSetDimensionsToSize:CGSizeMake(50, 50)];
    wechatMLB.text = NSLocalizedString(@"TEXT_WECHAT_MOMENT", nil);
    wechatMLB.textAlignment = NSTextAlignmentCenter;
    wechatMLB.backgroundColor = [UIColor clearColor];
    wechatMLB.font = NORMAL_12FONT_SIZE;
    wechatMLB.textColor = COLOR_TEXT;

}

- (void) dismissSVHUD {
    [SVProgressHUD dismiss];
}

- (void) wechatBTN {
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@?type=app", _webUrl];
    
    [WXApiRequestHandler sendLinkURL:shareUrl
                             TagName:nil
                               Title:[[_albumDic objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"*" withString:@""]
                         Description:nil
                          ThumbImage:[UIImage imageNamed:@"iconLogo100"]
                             InScene:WXSceneSession];
    [self showShareView];
}

- (void) wechatMomentBTN {
    NSString *shareUrl = [NSString stringWithFormat:@"%@?type=app", _webUrl];
    
    [WXApiRequestHandler sendLinkURL:shareUrl
                             TagName:nil
                               Title:[[_albumDic objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"*" withString:@""]
                         Description:nil
                          ThumbImage:[UIImage imageNamed:@"iconLogo100"]
                             InScene:WXSceneTimeline];
    [self showShareView];
    
}

#pragma mark - 收藏专辑按钮
- (void) collectAlbum {
    
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:[self.albumDic objectForKey:@"aid"] forKey:@"aid"];
    [paramter setObject:_isCollect forKey:@"type"];
    [paramter setObject:@"0" forKey:@"islist"];
    
    [[HttpManager instance] requestWithMethod:@"User/setAlbum"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {

                                          if ([_isCollect isEqualToString:@"1"]) {
                                              _isCollect = @"2";
                                              _collectBTN.tintColor = ORINGE_COLOR_BG;
                                          }else{
                                              _isCollect = @"1";
                                              _collectBTN.tintColor = NAV_GRAY_COLOR;
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

#pragma mark - 是否收藏该专辑
- (void) isCollectAlbum {
    
    if (self.albumDic.count <= 0) return;
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:[self.albumDic objectForKey:@"aid"] forKey:@"aid"];
    
    [[HttpManager instance] requestWithMethod:@"User/isCollectAlbum"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          if ([[[result objectForKey:@"data"] objectForKey:@"is_collect"] isEqualToString:@"1"]) {
                                              _collectBTN.tintColor = ORINGE_COLOR_BG;
                                              _isCollect = @"2";
                                          }else{
                                              _collectBTN.tintColor = NAV_GRAY_COLOR;
                                              _isCollect = @"1";
                                          }
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      }];
}

- (void) dismissShareView{
    _slideShowState = @"0";
    [_slideVM slideViewOut];
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
//    [SVProgressHUD show];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
//    [SVProgressHUD dismiss];
}

- (void) popToDiscovery {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
