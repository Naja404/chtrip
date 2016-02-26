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

static NSString * const PLAY_CELL = @"playCell";
static NSString * const PLAY_TITLE_CELL = @"playTitleCell";
static NSString * const PLAY_NAV_CELL = @"playNavCell";

@interface PlayInsideDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CHActionSheetMapAppDelegate>

@property (nonatomic, strong) UITableView *detailTV;
@property (nonatomic, strong) NSDictionary *detailData;
@property (nonatomic, strong) CHActionSheetMapApp *mapApp;

@end

@implementation PlayInsideDetailViewController

- (void) viewWillDisappear:(BOOL)animated{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[HttpManager instance] cancelAllOperations];
        [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self getShopDetail];
}

- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    
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
    
    UIButton *backBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:backBTN];
    
    [backBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:30];
    [backBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:20];
    [backBTN autoSetDimensionsToSize:CGSizeMake(15, 25)];
    [backBTN setBackgroundImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
    [backBTN addTarget:self action:@selector(backLastController) forControlEvents:UIControlEventTouchUpInside];
    [backBTN setBackgroundColor:[UIColor blackColor]];
    
    UIButton *addWantGoBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:addWantGoBTN];
    
    [addWantGoBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [addWantGoBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [addWantGoBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [addWantGoBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    
    [addWantGoBTN setTitle:@"我想去" forState:UIControlStateNormal];
    addWantGoBTN.backgroundColor = BLUE_COLOR_BG;
    [addWantGoBTN addTarget:self action:@selector(addWantGoAction) forControlEvents:UIControlEventTouchDown];
    
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
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
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
            return 54;
        }
    }else if(indexPath.section == 1 && indexPath.row == 1){
        return ScreenWidth * 0.75;
    }else{
        return 42;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
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
            
            return cell;
        
        }else if(indexPath.row == 1){
            // 大标题
            [cell removeFromSuperview];
            
            PlayInsideDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_TITLE_CELL forIndexPath:indexPath];
            
            cell.shopNameLB.text = [_detailData objectForKey:@"shop_name"];
            cell.ratingImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"star_%@", [_detailData objectForKey:@"rating"]]];
            cell.categoryLB.text = [_detailData objectForKey:@"category"];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            // 常规标题
            NSDictionary *tmp = [[_detailData objectForKey:@"normal"] objectAtIndex:indexPath.row - 2];
            cell.iconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [tmp objectForKey:@"icon"]]];
            
            cell.titleLB.text = [tmp objectForKey:@"title"];
            
            cell.contentLB.text = [tmp objectForKey:@"content"];
            
            if (![[tmp objectForKey:@"icon"] isEqualToString:@"shopAddressICON"]) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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
            [_detailTV selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
    }else{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
