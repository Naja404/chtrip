//
//  MyLoginSelectViewController.m
//  chtrips
//
//  Created by Hisoka on 15/9/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyLoginSelectViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "MyLoginViewController.h"

@interface MyLoginSelectViewController ()<WXApiManagerDelegate>

@end

@implementation MyLoginSelectViewController

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupStyle];
    
    self.navigationController.navigationBarHidden = YES;
    
    [WXApiManager sharedManager].delegate = self;

}

- (void) setupStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:cancelBTN];
    
    [cancelBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:20];
    [cancelBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
    [cancelBTN autoSetDimensionsToSize:CGSizeMake(52, 52)];
    [cancelBTN setImage:[UIImage imageNamed:@"loginCancel"] forState:UIControlStateNormal];
    [cancelBTN addTarget:self action:@selector(backMyView) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgImg = [UIImageView newAutoLayoutView];
    [self.view addSubview:bgImg];
    
    [bgImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [bgImg autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [bgImg autoSetDimensionsToSize:CGSizeMake(159, 98)];
    bgImg.image = [UIImage imageNamed:@"loginBg"];
    
    
    
    UIButton *wechatBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:wechatBTN];
    
    [wechatBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.view withOffset:-100];
//    [wechatBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10];
//    [wechatBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [wechatBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:-75];
    [wechatBTN autoSetDimensionsToSize:CGSizeMake(138, 50)];
    [wechatBTN setImage:[UIImage imageNamed:@"loginWeChat"] forState:UIControlStateNormal];
    [wechatBTN addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *weiboBTN = [UIButton newAutoLayoutView];
//    [self.view addSubview:weiboBTN];
//    
//    [weiboBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:wechatBTN];
//    [weiboBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
//    [weiboBTN autoSetDimensionsToSize:CGSizeMake(138, 50)];
//    [weiboBTN setImage:[UIImage imageNamed:@"loginWeibo"] forState:UIControlStateNormal];
//    [weiboBTN addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:loginBTN];
    
    [loginBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:wechatBTN];
    [loginBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:75];
    [loginBTN autoSetDimensionsToSize:CGSizeMake(138, 50)];
    [loginBTN setImage:[UIImage imageNamed:@"loginBTN"] forState:UIControlStateNormal];
    [loginBTN addTarget:self action:@selector(pushLoginVC) forControlEvents:UIControlEventTouchUpInside];

}

- (void) pushLoginVC {
    
    MyLoginViewController *loginVC = [[MyLoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVC animated:YES];

}


- (void) backMyView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 微信登陆
- (void) sendAuthRequest {
    [WXApiRequestHandler sendAuthRequestScope:WXAuthScope
                                        State:WXAuthState
                                       OpenID:WXAppId
                             InViewController:self];
}
// wechat
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

// 微信返回
- (void) managerDidRecvAuthResponse:(SendAuthResp *)response {
    if (response.code != nil) {
        [self setupWeChat:response.code state:response.state errcode:response.errCode lang:response.lang country:response.country];
    }

}

- (void) setupWeChat:(NSString *)code state:(NSString *)state errcode:(int)errcode lang:(NSString *)lang country:(NSString *)country{
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    
    [SVProgressHUD show];
    
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:code forKey:@"code"];
    [paramter setObject:state forKey:@"state"];
    [paramter setObject:[NSString stringWithFormat:@"%d", errcode] forKey:@"errcode"];
    [paramter setObject:[NSString stringWithFormat:@"%@", lang] forKey:@"lang"];
    [paramter setObject:[NSString stringWithFormat:@"%@", country] forKey:@"country"];
    
    [[HttpManager instance] requestWithMethod:@"User/loginWeChat"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"wechat login return %@", result);
                                          [[TMCache sharedCache] setObject:[[result objectForKey:@"data"] objectForKey:@"nickname"] forKey:@"userName"];
                                          
                                          [[TMCache sharedCache] setObject:[[result objectForKey:@"data"] objectForKey:@"headimgurl"] forKey:@"userAvatar"];
                                          
                                          [[TMCache sharedCache] setObject:@"1" forKey:@"loginStatus"];
                                          
                                          [SVProgressHUD dismiss];
                                          
                                          [self backMyView];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error %@", error);
                                          [SVProgressHUD dismiss];
                                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
