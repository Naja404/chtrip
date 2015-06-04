//
//  ShoppingPopularityDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/4/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingPopularityDetailViewController.h"
#import "ShoppingDetailTitleTableViewCell.h"
#import "ShoppingDetailPictureTableViewCell.h"

#import <ShareSDK/shareSDK.h>

static NSString * const SHOP_DETAIL_TITLE_CELL = @"shopDetailTitleCell";
static NSString * const SHOP_DETAIL_IMAGE_CELL = @"shopDetailImageCell";

@interface ShoppingPopularityDetailViewController ()<UITableViewDataSource, UITableViewDelegate>{
    CALayer *_layer;
}

@property (nonatomic, strong) UITableView *populaDetailTV;
@property (nonatomic, strong) UIView *proimgView;
@property (nonatomic) double angle;

@end

@implementation ShoppingPopularityDetailViewController

- (void) viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDetailStyle];
    
//    [self drawControllerViewLayer];
    
    // Do any additional setup after loading the view.
}

- (void) setupDetailStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                                           target:self
                                                                                           action:@selector(navShareClick:)];
    [self setupDetailTV];
    [self setupBuyBar];
    
}

- (void) setupDetailTV {
    self.populaDetailTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_populaDetailTV];
    
    [_populaDetailTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_populaDetailTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_populaDetailTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_populaDetailTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _populaDetailTV.dataSource = self;
    _populaDetailTV.delegate = self;
    _populaDetailTV.separatorStyle = UITableViewCellAccessoryNone;
    _populaDetailTV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.TVheightDic = [[NSMutableDictionary alloc] init];
    
    [self.populaDetailTV registerClass:[ShoppingDetailTitleTableViewCell class] forCellReuseIdentifier:SHOP_DETAIL_TITLE_CELL];
    [self.populaDetailTV registerClass:[ShoppingDetailPictureTableViewCell class] forCellReuseIdentifier:SHOP_DETAIL_IMAGE_CELL];
}

- (void) setupBuyBar {
    UIView *buyBar = [UIView newAutoLayoutView];
    
    [self.view addSubview:buyBar];
    
//    [buyBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [buyBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [buyBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [buyBar autoSetDimensionsToSize:CGSizeMake(self.view.frame.size.width, 44)];
    buyBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *shopCartBTN = [UIButton newAutoLayoutView];
    [buyBar addSubview:shopCartBTN];
    [shopCartBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:buyBar withOffset:-10];
    [shopCartBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:5];
    [shopCartBTN autoSetDimensionsToSize:CGSizeMake(120, 30)];
    [shopCartBTN setTitle:@"加入扫货清单" forState:UIControlStateNormal];
    shopCartBTN.backgroundColor = [UIColor redColor];
    [shopCartBTN addTarget:self action:@selector(addBuyList) forControlEvents:UIControlEventTouchDown];

    UIImageView *priceJPImg = [UIImageView newAutoLayoutView];
    [buyBar addSubview:priceJPImg];
    [priceJPImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:buyBar withOffset:5];
    [priceJPImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:10];
    [priceJPImg autoSetDimensionsToSize:CGSizeMake(16, 16)];
    priceJPImg.image = [UIImage imageNamed:@"japanFlagIcon"];
    
    UILabel *priceJPLB = [UILabel newAutoLayoutView];
    [buyBar addSubview:priceJPLB];
    [priceJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:priceJPImg withOffset:2];
    [priceJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:8];
    [priceJPLB autoSetDimensionsToSize:CGSizeMake(70, 20)];
    priceJPLB.text = [self.dicData objectForKey:@"price_jp"];
    priceJPLB.font = [UIFont fontWithName:@"Georgia-Italic" size:15];

    
    UIImageView *priceZHImg = [UIImageView newAutoLayoutView];
    [buyBar addSubview:priceZHImg];
    [priceZHImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:priceJPLB withOffset:10];
    [priceZHImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:10];
    [priceZHImg autoSetDimensionsToSize:CGSizeMake(16, 16)];
    priceZHImg.image = [UIImage imageNamed:@"chinaFlagIcon"];
    
    UILabel *priceZHLB = [UILabel newAutoLayoutView];
    [buyBar addSubview:priceZHLB];
    [priceZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:priceZHImg withOffset:2];
    [priceZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:8];
    [priceZHLB autoSetDimensionsToSize:CGSizeMake(100, 20)];
    priceZHLB.text = [self.dicData objectForKey:@"price_zh"];
    priceZHLB.font = [UIFont fontWithName:@"Georgia-Italic" size:15];

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 200;
    NSString *height = [self.TVheightDic objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    return [height floatValue];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {

        ShoppingDetailPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_DETAIL_IMAGE_CELL forIndexPath:indexPath];
    
        cell.imgArr = [self.dicData objectForKey:@"path"];
        [cell setupImgScrollView];
        [self.TVheightDic setValue:@"200" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ShoppingDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_DETAIL_TITLE_CELL forIndexPath:indexPath];
//        cell.titleZHLB.text = [self.dicData objectForKey:@"title_zh"];
//        cell.titleJPLB.text = [self.dicData objectForKey:@"title_jp"];
//        cell.summaryLB.text = [self.dicData objectForKey:@"summary"];
//        cell.summaryLB.text = @"澳洲夜晚在高速公路开车务必当心，袋鼠的趋光性有时候会冲着开车灯的汽车冲过来，如果你撞死袋鼠，你当然不会受罚，但是你的车你是得赔钱的.两个国家有上限10公里的限速，比如限速110，你可以开120，但是并不建议这么做，这两个国家的罚单非常昂贵。";
        
        CGFloat cellHeight = [cell setTextWithHeight:[self.dicData objectForKey:@"title_zh"] titleJP:[self.dicData objectForKey:@"title_jp"] summary:[self.dicData objectForKey:@"description_zh"]];
        
        [self.TVheightDic setValue:[NSString stringWithFormat:@"%f", cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark 分享按钮
- (void) navShareClick:(id)sender {
    NSLog(@"share btn click");
    
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"要分享的内容"
                                       defaultContent:@"默认内容"
                                                image:nil
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条演示信息"
                                            mediaType:SSPublishContentMediaTypeText];
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithBarButtonItem:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }else if (state == SSResponseStateFail){
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) drawControllerViewLayer {
//    _layer = [[CALayer alloc] init];
//    _layer.bounds = CGRectMake(0, 60, 140, 140);
//    _layer.position = CGPointMake(50, 200);
//    _layer.contents = (id)[UIImage imageNamed:@"productDemo1"].CGImage;
//    [self.view.layer addSublayer:_layer];
//}
//
//- (void) translatonAnimation:(CGPoint)location {
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    basicAnimation.toValue = [NSValue valueWithCGPoint:location];
//    basicAnimation.duration = 0.5;
//    basicAnimation.delegate = self;
//    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"basicAnimation"];
//    [_layer addAnimation:basicAnimation forKey:@"basicAnimation_Translation"];
//}
//
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = touches.anyObject;
//    CGPoint location = [touch locationInView:self.view];
//    [self translatonAnimation:location];
//}
//
//- (void) rotationAnimation {
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI_2 * 3];
//    basicAnimation.duration = 6.0;
//    basicAnimation.autoreverses = YES;
//    
//    [_layer addAnimation:basicAnimation forKey:@"basicAnimation_Rotation"];
//}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void) addBuyList {
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[self.dicData objectForKey:@"pid"] forKey:@"pid"];
    NSLog(@"paramter is %@", paramter);
    [[HttpManager instance] requestWithMethod:@"User/addBuyList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_BUYLIST_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
    }];

//    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_BUYLIST_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
    
//    HttpManager *manager = [[HttpManager instance] ];
}

- (void) transformAction {
    _angle = _angle + 0.01;
    if (_angle > 6.28) {
        _angle = 0;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(_angle);
    self.proimgView.transform = transform;
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
