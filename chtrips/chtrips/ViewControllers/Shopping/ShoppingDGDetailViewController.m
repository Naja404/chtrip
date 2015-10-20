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
@property (nonatomic, strong) UIView *addBuyListV;


@end

@implementation ShoppingDGDetailViewController

- (void) viewWillAppear:(BOOL)animated {
    if ([self.hasNav isEqualToString:@"1"]) {
        self.navigationController.navigationBarHidden = NO;
    }else{
        
    }
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
    [self setupAddBuyList];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    // Do any additional setup after loading the view.
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
    
    
    UIButton *addBuyBTN = [UIButton newAutoLayoutView];
    [self.addBuyListV addSubview:addBuyBTN];
    
    [addBuyBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.addBuyListV];
    [addBuyBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.addBuyListV];
    [addBuyBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.addBuyListV];
    [addBuyBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    addBuyBTN.backgroundColor = ADD_BUY_LIST_COLOR;
    [addBuyBTN setTitle:NSLocalizedString(@"BTN_ADD_BUYLIST", nil) forState:UIControlStateNormal];
    [addBuyBTN addTarget:self action:@selector(addBuyListAction) forControlEvents:UIControlEventTouchDown];
    
    UIView *priceV = [UIView newAutoLayoutView];
    [self.addBuyListV addSubview:priceV];
    
    [priceV autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:addBuyBTN];
    [priceV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_addBuyListV];
    [priceV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_addBuyListV];
    [priceV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_addBuyListV];
    priceV.backgroundColor = GRAY_FONT_COLOR;
    
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

#pragma mark 加入扫货清单事件
- (void) addBuyListAction {
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    //    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.pid forKey:@"pid"];
    NSLog(@"paramter is %@", paramter);
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
