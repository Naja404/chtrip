//
//  ShoppingDGDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/8/3.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDGDetailViewController.h"
#import "WebViewJavascriptBridge.h"
#import "UIBarButtonItem+Badge.h"
#import "MyCartViewController.h"

@interface ShoppingDGDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIView *addBuyListV;
@property (nonatomic, strong) UIButton *addBuyBTN;
@property (nonatomic, strong) UIButton *wantBuyBTN;
@property (nonatomic, strong) UIImageView *wantIconImg;
@property (nonatomic, strong) UILabel *wantLB;
@property (nonatomic, strong) UIImageView *cartIconImg;
@property (nonatomic, strong) UILabel *priceLB;
@property (nonatomic, assign) BOOL hasWantBuy;

@end

@implementation ShoppingDGDetailViewController

- (void) viewWillAppear:(BOOL)animated {

    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self getCartTotal];
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
    [self setupAddBuyList];
    [self getCartTotal];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupAddBuyList {
    
    UIButton *cartBTN = [self customizedRightButton];
    [cartBTN addTarget:self action:@selector(pushCart) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cartBTN];
    
    self.addBuyListV = [UIView newAutoLayoutView];
    [self.view addSubview:_addBuyListV];
    
    [_addBuyListV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_addBuyListV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_addBuyListV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_addBuyListV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    
    UIView *wantV = [UIView newAutoLayoutView];
    [_addBuyListV addSubview:wantV];
    
    [wantV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_addBuyListV];
    [wantV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_addBuyListV];
    [wantV autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 6, 50)];
    wantV.backgroundColor = [UIColor whiteColor];
    
    self.wantIconImg = [UIImageView newAutoLayoutView];
    [wantV addSubview:_wantIconImg];
    
    [_wantIconImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:wantV];
    [_wantIconImg autoAlignAxis:ALAxisVertical toSameAxisOfView:wantV];
    [_wantIconImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
    _wantIconImg.image = [UIImage imageNamed:@"iconWantBuy"];
    
    _wantLB = [UILabel newAutoLayoutView];
    [wantV addSubview:_wantLB];
    
    [_wantLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_wantIconImg];
    [_wantLB autoAlignAxis:ALAxisVertical toSameAxisOfView:wantV];
    [_wantLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 6, 20)];
    _wantLB.textAlignment = NSTextAlignmentCenter;
    _wantLB.font = FONT_SIZE_10;
    _wantLB.textColor = GRAY_COLOR_PLAY;
    _wantLB.text = @"我想买";
    
    UILabel *horizontalLine = [UILabel newAutoLayoutView];
    [wantV addSubview:horizontalLine];
    
    [horizontalLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:wantV];
    [horizontalLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:wantV withOffset:-0.5];
    [horizontalLine autoSetDimensionsToSize:CGSizeMake(0.5, 50)];
    horizontalLine.backgroundColor = GRAY_COLOR_PLAY;
    
    self.wantBuyBTN = [UIButton newAutoLayoutView];
    [wantV addSubview:_wantBuyBTN];
    
    [_wantBuyBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:wantV];
    [_wantBuyBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:wantV];
    [_wantBuyBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:wantV];
    [_wantBuyBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:wantV];
    [_wantBuyBTN setBackgroundColor:[UIColor clearColor]];
    [_wantBuyBTN addTarget:self action:@selector(addBuyListAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *priceV = [UIView newAutoLayoutView];
    [_addBuyListV addSubview:priceV];
    
    [priceV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_addBuyListV];
    [priceV autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:wantV];
    [priceV autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 3, 50)];
    priceV.backgroundColor = [UIColor whiteColor];
    
    self.cartIconImg = [UIImageView newAutoLayoutView];
    [priceV addSubview:_cartIconImg];
    
    [_cartIconImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:priceV];
    [_cartIconImg autoAlignAxis:ALAxisVertical toSameAxisOfView:priceV];
    [_cartIconImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
    _cartIconImg.image = [UIImage imageNamed:@"iconCartGray"];
    
    self.priceLB = [UILabel newAutoLayoutView];
    [priceV addSubview:_priceLB];
    
    [_priceLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_cartIconImg];
    [_priceLB autoAlignAxis:ALAxisVertical toSameAxisOfView:priceV];
    [_priceLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 3, 20)];
    _priceLB.textAlignment = NSTextAlignmentCenter;
    _priceLB.textColor = GRAY_COLOR_PLAY;
    _priceLB.attributedText = [self priceFormat:[NSString stringWithFormat:@"价格 %@", _zhPriceStr]];
    _priceLB.font = FONT_SIZE_10;

    UILabel *topLine = [UILabel newAutoLayoutView];
    [_addBuyListV addSubview:topLine];
    
    [topLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_addBuyListV];
    [topLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_addBuyListV];
    [topLine autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 2, 0.5)];
    topLine.backgroundColor = GRAY_COLOR_PLAY;
    
    
    self.addBuyBTN = [UIButton newAutoLayoutView];
    [self.addBuyListV addSubview:_addBuyBTN];
    
    [_addBuyBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.addBuyListV];
    [_addBuyBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.addBuyListV];
    [_addBuyBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 2, 50)];
    _addBuyBTN.backgroundColor = ORINGE_COLOR_BG;
    
    if (_stockLB == nil) _stockLB = NSLocalizedString(@"BTN_ADD_CART", nil);
    
    [_addBuyBTN setTitle:_stockLB forState:UIControlStateNormal];
    [_addBuyBTN addTarget:self action:@selector(addCart) forControlEvents:UIControlEventTouchDown];
    if ([_stock isEqualToString:@"0"]) {
        _addBuyBTN.enabled = NO;
        _addBuyBTN.backgroundColor = GRAY_COLOR_CELL_LINE;
    }
    
//    UIView *priceV = [UIView newAutoLayoutView];
//    [self.addBuyListV addSubview:priceV];
//    
//    [priceV autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_addBuyBTN];
//    [priceV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_addBuyListV];
//    [priceV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_addBuyListV];
//    [priceV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_addBuyListV];
//    priceV.backgroundColor = GRAY_COLOR_CITY_CELL;
//    
//    UILabel *refLB = [UILabel newAutoLayoutView];
//    [priceV addSubview:refLB];
//    
//    [refLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:priceV withOffset:(ScreenWidth - 75 - 5- 30 - 5) / 3];
//    [refLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceV];
//    [refLB autoSetDimensionsToSize:CGSizeMake(75, 25)];
//    refLB.text = NSLocalizedString(@"TEXT_PRE_PRICE", nil);
//    
//    UIImageView *zhPriceImg = [UIImageView newAutoLayoutView];
//    [priceV addSubview:zhPriceImg];
//    
//    [zhPriceImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:refLB withOffset:5];
//    [zhPriceImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceV];
//    [zhPriceImg autoSetDimensionsToSize:CGSizeMake(30, 25)];
//    zhPriceImg.image =[UIImage imageNamed:@"zhImg"];
//    
//    UILabel *zhPriceLB = [UILabel newAutoLayoutView];
//    [priceV addSubview:zhPriceLB];
//    
//    [zhPriceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:zhPriceImg withOffset:5];
//    [zhPriceLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceV];
//    zhPriceLB.text = self.zhPriceStr;
}

#pragma mark - 设置价格样式
- (NSMutableAttributedString *) priceFormat:(NSString *)str {
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:str];
    
//    NSUInteger rangLength = str.length - 5;
    
    [price addAttribute:NSForegroundColorAttributeName value:GRAY_COLOR_PLAY range:NSMakeRange(0, 1)];
    [price addAttribute:NSForegroundColorAttributeName value:ORINGE_COLOR_BG range:NSMakeRange(3, str.length - 3)];
    
    return price;
}

#pragma mark - 加入购物车
- (void) addCart {
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.pid forKey:@"pid"];
    
    [[HttpManager instance] requestWithMethod:@"User/addCart"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_CART_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
                                          
                                          NSDictionary *tmp = [result objectForKey:@"data"];
                                          
                                          if ([[tmp objectForKey:@"cart_total"] isEqualToString:@"0"]) {
                                              self.navigationItem.rightBarButtonItem = nil;
                                          }else{
                                              self.navigationItem.rightBarButtonItem.badgeValue = [tmp objectForKey:@"cart_total"];
                                          }
                                          
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [_addBuyBTN setTitle:[error localizedDescription] forState:UIControlStateNormal];
                                          _addBuyBTN.enabled = NO;
                                          _addBuyBTN.backgroundColor = GRAY_COLOR_CELL_LINE;
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
    
}

#pragma mark 加入扫货清单事件
- (void) addBuyListAction {
    [SVProgressHUD show];
    
    NSString *hasWant = _hasWantBuy == YES ? @"0" : @"1";
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    //    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.pid forKey:@"pid"];
    [paramter setObject:hasWant forKey:@"type"];

    [[HttpManager instance] requestWithMethod:@"User/addBuyList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {

                                          NSDictionary *tmp = [result objectForKey:@"data"];
                                          
                                          if ([[tmp objectForKey:@"has_wantbuy"] isEqualToString:@"1"]) {
                                              _hasWantBuy = YES;
                                              _wantIconImg.image = [UIImage imageNamed:@"iconWantBuy"];
                                              [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_BUYLIST_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
                                          }else{
                                              _hasWantBuy = NO;
                                              _wantIconImg.image = [UIImage imageNamed:@"iconWantBuyGray"];
                                              [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_CANCEL_BUYLIST_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];

                                          }
                                          
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (void) setupUrlPage {
    self.webView = [[UIWebView alloc] initForAutoLayout];
    [self.view addSubview:_webView];
    
    //    [_webView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    
    [_webView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [_webView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_webView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_webView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-50];
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.webView loadRequest:request];
    
}

#pragma mark - 获取购物车数量
- (void) getCartTotal {
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:_pid forKey:@"pid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getCartTotal"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSDictionary *tmp = [result objectForKey:@"data"];
                                          
                                          if ([[tmp objectForKey:@"cart_total"] isEqualToString:@"0"]) {
                                              self.navigationItem.rightBarButtonItem.badgeValue = nil;
                                          }else{
                                              self.navigationItem.rightBarButtonItem.badgeValue = [tmp objectForKey:@"cart_total"];
                                          }
                                          
                                          if ([[tmp objectForKey:@"has_wantbuy"] isEqualToString:@"1"]) {
                                              _hasWantBuy = YES;
                                              _wantIconImg.image = [UIImage imageNamed:@"iconWantBuy"];
                                          }else{
                                              _hasWantBuy = NO;
                                              _wantIconImg.image = [UIImage imageNamed:@"iconWantBuyGray"];
                                          }
                                          
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      }];
}

- (void) pushCart {
    MyCartViewController *myCart = [[MyCartViewController alloc] init];
    [self.navigationController pushViewController:myCart animated:YES];
}

- (UIButton *)customizedRightButton {
    UIImage *imgage=[UIImage imageNamed:@"iconCartGray"];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgage.size.width + 0, imgage.size.height)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setImage:imgage forState:UIControlStateNormal];
    return button;
}

- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}


@end
