//
//  ShoppingDGDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/8/3.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDGDetailViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ShoppingDGDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIView *addBuyListV;
@property (nonatomic, strong) UIButton *addBuyBTN;

@end

@implementation ShoppingDGDetailViewController

- (void) viewWillAppear:(BOOL)animated {

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
    [self setupAddBuyList];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupAddBuyList {
    self.addBuyListV = [UIView newAutoLayoutView];
    [self.view addSubview:_addBuyListV];
    
    [_addBuyListV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_addBuyListV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_addBuyListV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_addBuyListV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 80)];
    
    
    self.addBuyBTN = [UIButton newAutoLayoutView];
    [self.addBuyListV addSubview:_addBuyBTN];
    
    [_addBuyBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.addBuyListV];
    [_addBuyBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.addBuyListV];
    [_addBuyBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.addBuyListV];
    [_addBuyBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    _addBuyBTN.backgroundColor = ORINGE_COLOR_BG;
//    [addBuyBTN setTitle:NSLocalizedString(@"BTN_ADD_CART", nil) forState:UIControlStateNormal];
    
    if (_stockLB == nil) _stockLB = NSLocalizedString(@"BTN_ADD_CART", nil);
    
    [_addBuyBTN setTitle:_stockLB forState:UIControlStateNormal];
    [_addBuyBTN addTarget:self action:@selector(addCart) forControlEvents:UIControlEventTouchDown];
    if ([_stock isEqualToString:@"0"]) {
        _addBuyBTN.enabled = NO;
        _addBuyBTN.backgroundColor = GRAY_COLOR_CELL_LINE;
    }
    
    UIView *priceV = [UIView newAutoLayoutView];
    [self.addBuyListV addSubview:priceV];
    
    [priceV autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_addBuyBTN];
    [priceV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_addBuyListV];
    [priceV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_addBuyListV];
    [priceV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_addBuyListV];
    priceV.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    UILabel *refLB = [UILabel newAutoLayoutView];
    [priceV addSubview:refLB];
    
    [refLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:priceV withOffset:(ScreenWidth - 75 - 5- 30 - 5) / 3];
    [refLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceV];
    [refLB autoSetDimensionsToSize:CGSizeMake(75, 25)];
    refLB.text = NSLocalizedString(@"TEXT_PRE_PRICE", nil);
    
    UIImageView *zhPriceImg = [UIImageView newAutoLayoutView];
    [priceV addSubview:zhPriceImg];
    
    [zhPriceImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:refLB withOffset:5];
    [zhPriceImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceV];
    [zhPriceImg autoSetDimensionsToSize:CGSizeMake(30, 25)];
    zhPriceImg.image =[UIImage imageNamed:@"zhImg"];
    
    UILabel *zhPriceLB = [UILabel newAutoLayoutView];
    [priceV addSubview:zhPriceLB];
    
    [zhPriceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:zhPriceImg withOffset:5];
    [zhPriceLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceV];
    zhPriceLB.text = self.zhPriceStr;
    
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
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    //    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.pid forKey:@"pid"];

    [[HttpManager instance] requestWithMethod:@"User/addBuyList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_BUYLIST_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
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
