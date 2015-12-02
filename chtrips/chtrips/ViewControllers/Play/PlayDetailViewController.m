//
//  PlayDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/7/19.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "PlayDetailViewController.h"
#import "BookingWebViewController.h"

#import "CHActionSheetMapApp.h"

@interface PlayDetailViewController ()<UIWebViewDelegate, CHActionSheetMapAppDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *popBTN;
@property (nonatomic, strong) CHActionSheetMapApp *mapApp;

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
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
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
    addWantGoBTN.backgroundColor = BLUE_COLOR_BG;
    [addWantGoBTN addTarget:self action:@selector(addWantGoAction) forControlEvents:UIControlEventTouchDown];
    
    if ([self.isHotel isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预定酒店" style:UIBarButtonItemStyleDone target:self action:@selector(pushBookVC)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMapActionSheet)];
        self.navigationItem.rightBarButtonItem.tintColor = NAV_GRAY_COLOR;
    }
    
    [SVProgressHUD show];
    [self performSelector:@selector(dismissSVHUD) withObject:nil afterDelay:2.0f];
}

- (void) dismissSVHUD {
    [SVProgressHUD dismiss];
}

#pragma mark - 显示导航app
- (void) showMapActionSheet {
    self.mapApp = [[CHActionSheetMapApp alloc] initWithMap:self];
    _mapApp.address = _address;
    _mapApp.googleMap = _googleMapUrl;
    [_mapApp.mapAS showInView:self.view];
}

#pragma mark - 载入booking页面
- (void) pushBookVC {
    BookingWebViewController *bookVC = [[BookingWebViewController alloc] init];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:bookVC];
    
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

#pragma mark 我想去事件
- (void) addWantGoAction {
    [SVProgressHUD show];
    
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
