//
//  PlayInsideDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 16/2/26.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "PlayInsideDetailViewController.h"
#import "PlayInsideDetailTableViewCell.h"
#import "CHActionSheetMapApp.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SlideInViewManager.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "BookingWebViewController.h"



static NSString * const PLAY_CELL = @"playCell";
static NSString * const PLAY_TITLE_CELL = @"playTitleCell";
static NSString * const PLAY_NAV_CELL = @"playNavCell";
static NSString * const PLAY_DESCRIPTION_CELL = @"playDescriptionCell";

@interface PlayInsideDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CHActionSheetMapAppDelegate>

@property (nonatomic, strong) UITableView *detailTV;
@property (nonatomic, strong) NSDictionary *detailData;
@property (nonatomic, strong) CHActionSheetMapApp *mapApp;
@property (nonatomic, strong) UIView *slideV;
@property (nonatomic, strong) SlideInViewManager *slideVM;
@property (nonatomic, strong) NSString *slideShowState;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation PlayInsideDetailViewController

- (void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self getShopDetail];
}

- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.detailTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_detailTV];
    
    [_detailTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
//    [_detailTV autoPinToTopLayoutGuideOfViewController:self withInset:60];
    [_detailTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_detailTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_detailTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-50];
    
    _detailTV.delegate = self;
    _detailTV.dataSource = self;
    _detailTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTV.showsVerticalScrollIndicator = NO;
    
    [_detailTV registerClass:[PlayInsideDetailTableViewCell class] forCellReuseIdentifier:PLAY_CELL];
    [_detailTV registerClass:[PlayInsideDetailTableViewCell class] forCellReuseIdentifier:PLAY_TITLE_CELL];
    [_detailTV registerClass:[PlayInsideDetailTableViewCell class] forCellReuseIdentifier:PLAY_NAV_CELL];
    [_detailTV registerClass:[PlayInsideDetailTableViewCell class] forCellReuseIdentifier:PLAY_DESCRIPTION_CELL];
    
    UILabel *backBG = [UILabel newAutoLayoutView];
    [self.view addSubview:backBG];
    
    [backBG autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:25];
    [backBG autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:15];
    [backBG autoSetDimensionsToSize:CGSizeMake(35, 35)];
    backBG.backgroundColor = TRANSLATE_BLACK_BG;
    backBG.layer.cornerRadius = 17.5;
    backBG.layer.masksToBounds = YES;
    
    UIImageView *backIMG = [UIImageView newAutoLayoutView];
    [self.view addSubview:backIMG];
    
    [backIMG autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:30];
    [backIMG autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:20];
    [backIMG autoSetDimensionsToSize:CGSizeMake(25, 25)];
    backIMG.image = [UIImage imageNamed:@"shopBackBTN"];
    
    UIButton *backBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:backBTN];
    
    [backBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:10];
    [backBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10];
    [backBTN autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [backBTN addTarget:self action:@selector(backLastController) forControlEvents:UIControlEventTouchUpInside];
    [backBTN setBackgroundColor:[UIColor clearColor]];
    
    UIButton *addWantGoBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:addWantGoBTN];
    
    [addWantGoBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [addWantGoBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [addWantGoBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [addWantGoBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    
    [addWantGoBTN setTitle:@"我想去" forState:UIControlStateNormal];
    addWantGoBTN.backgroundColor = BLUE_COLOR_BG;
    [addWantGoBTN addTarget:self action:@selector(addWantGoAction) forControlEvents:UIControlEventTouchDown];
    
    UILabel *shareBG = [UILabel newAutoLayoutView];
    [self.view addSubview:shareBG];
    
    [shareBG autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backBG];
    [shareBG autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-15];
    [shareBG autoSetDimensionsToSize:CGSizeMake(35, 35)];
    shareBG.backgroundColor = TRANSLATE_BLACK_BG;
    shareBG.layer.cornerRadius = 17.5;
    shareBG.layer.masksToBounds = YES;
    
    UIButton *shareBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:shareBTN];
    
    [shareBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backIMG];
    [shareBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-20];
    [shareBTN autoSetDimensionsToSize:CGSizeMake(25, 25)];
    [shareBTN setBackgroundImage:[UIImage imageNamed:@"shopShareBTN"] forState:UIControlStateNormal];
    [shareBTN addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置分享
    [self setShareView];
}

#pragma mark - 设置分享
- (void) setShareView {
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

- (void) wechatBTN {
    
    [WXApiRequestHandler sendLinkURL:[_detailData objectForKey:@"share_url"]
                             TagName:nil
                               Title:[_detailData objectForKey:@"shop_name"]
                         Description:[_detailData objectForKey:@"address"]
                          ThumbImage:[UIImage imageNamed:@"iconLogo100"]
                             InScene:WXSceneSession];
    [self showShareView];
}

- (void) wechatMomentBTN {
    
    [WXApiRequestHandler sendLinkURL:[_detailData objectForKey:@"share_url"]
                             TagName:nil
                               Title:[_detailData objectForKey:@"shop_name"]
                         Description:nil
                          ThumbImage:[UIImage imageNamed:@"iconLogo100"]
                             InScene:WXSceneTimeline];
    [self showShareView];
    
}

#pragma mark - 获取网络图片
- (UIImage *) getImageFormUrl:(NSString *) imgUrl {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    
    if (data == nil) return [UIImage imageNamed:@"iconLogo100"];
    
    UIImage *res = [UIImage imageWithData:data];
    
    return res;
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

#pragma mark - 返回上级controller
- (void) backLastController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取商家详情
- (void) getShopDetail {
    
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:_sid forKey:@"sid"];
    
    [[HttpManager instance] requestWithMethod:@"Product/shopDetail"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          self.detailData = [result objectForKey:@"data"];
                                          
                                          [self setStyle];
                                          
                                          [_detailTV reloadData];
                                          
                                          [SVProgressHUD dismiss];
                                          
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }else if(section == 2){
        return 2;
    }else{
        return [[_detailData objectForKey:@"normal"] count] + 2;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return ScreenWidth * 0.66;
        }else{
            
            if (indexPath.row - 2 == 0 && [[[[_detailData objectForKey:@"normal"] objectAtIndex:0] objectForKey:@"icon"] isEqualToString:@"shopAddressICON"]) {
                return 74;
            }else if (indexPath.row - 2 == 2) {
                NSString *openTime = [[[_detailData objectForKey:@"normal"] objectAtIndex:2] objectForKey:@"content"];
                
                CGSize size = [openTime boundingRectWithSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_SIZE_14} context:nil].size;
                
                if (size.height > 20) {
                    return 88;
                }else{
                    return 54;
                }
            }else{
                return 54;
            }
        }
    }else if (indexPath.section == 1){
        NSString *description = [_detailData objectForKey:@"description"];
        
//        CGSize size = [description sizeWithAttributes:@{NSFontAttributeName:FONT_SIZE_14}];
        CGSize size = [description boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_SIZE_14} context:nil].size;
        
        return size.height + 20;
        
    }else if(indexPath.section == 2 && indexPath.row == 1){
        return ScreenWidth * 0.75;
    }else{
        return 42;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0;
    }else{
        return 10;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PlayInsideDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_CELL forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            // 商家图片
            [cell removeFromSuperview];
            
            PlayInsideDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_NAV_CELL forIndexPath:indexPath];
            
            NSURL *imageUrl = [NSURL URLWithString:[_detailData objectForKey:@"thumb"]];
            [cell.bgImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicHorizontal"]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        
        }else if(indexPath.row == 1){
            // 大标题
            [cell removeFromSuperview];
            
            PlayInsideDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_TITLE_CELL forIndexPath:indexPath];
            
            cell.shopNameLB.text = [_detailData objectForKey:@"shop_name"];
            cell.ratingImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"star_%@", [_detailData objectForKey:@"rating"]]];
            cell.categoryLB.text = [_detailData objectForKey:@"category"];
            
            if ([_isHotel isEqualToString:@"1"]) {
                cell.hLineLB.hidden = NO;
                cell.hotelLB.hidden = NO;
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            // 常规标题
            NSDictionary *tmp = [[_detailData objectForKey:@"normal"] objectAtIndex:indexPath.row - 2];
            cell.iconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [tmp objectForKey:@"icon"]]];
            
            cell.titleLB.text = [tmp objectForKey:@"title"];
            
            cell.contentLB.text = [tmp objectForKey:@"content"];
            
            if (![[tmp objectForKey:@"icon"] isEqualToString:@"shopAddressICON"]) {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.hLineLB.hidden = NO;
                cell.mapLB.hidden = NO;
            }
        }
    }else if (indexPath.section == 1){
        // 商户简介
        
        [cell removeFromSuperview];
        
        PlayInsideDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_DESCRIPTION_CELL forIndexPath:indexPath];
        
        cell.contentLB.text = [_detailData objectForKey:@"description"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            
            cell.iconImg.image = [UIImage imageNamed:@"shopNavICON"];
            cell.titleLB.text = @"进入导航";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            [cell removeFromSuperview];
            // 地图
            PlayInsideDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_NAV_CELL forIndexPath:indexPath];
            NSURL *imageUrl = [NSURL URLWithString:[_detailData objectForKey:@"map_thumb"]];
            [cell.bgImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicHorizontal"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            [_detailTV selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
        if (indexPath.row == 1) {
            [self pushBookVC];
        }
    }else if(indexPath.section == 2){
        [self showMapActionSheet];
    }
}

#pragma mark - 显示导航app
- (void) showMapActionSheet {
    self.mapApp = [[CHActionSheetMapApp alloc] initWithMap:self];
    _mapApp.address = [_detailData objectForKey:@"address"];
    _mapApp.googleMap = [_detailData objectForKey:@"googlemap"];
    [_mapApp.mapAS showInView:self.view];
}

#pragma mark 我想去事件
- (void) addWantGoAction {
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    //    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.sid forKey:@"sid"];
    
    [[HttpManager instance] requestWithMethod:@"User/addWantGo"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_WANT_GO", Nil) maskType:SVProgressHUDMaskTypeBlack];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

#pragma mark - 载入booking页面
- (void) pushBookVC {
    BookingWebViewController *bookVC = [[BookingWebViewController alloc] init];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:bookVC];
    
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
