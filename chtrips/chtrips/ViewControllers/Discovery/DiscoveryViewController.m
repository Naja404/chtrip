//
//  DiscoveryViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryTableViewCell.h"
#import "DiscoveryDetailViewController.h"
#import "CHAutoSlideScrollView.h"
#import "UIImageView+AFNetworking.h"
#import "JHChainableAnimations.h"
#import "SearchViewController.h"

static NSString * const DISCOVERY_CELL = @"discoveryCell";

@interface DiscoveryViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *discoveryTV;
@property (nonatomic, strong) NSMutableDictionary *discoveryTVData;
@property (nonatomic, strong) UIView *discoveryHV;
@property (nonatomic, strong) UIScrollView *adScrollView;
@property (nonatomic, strong) UIPageControl *adPageControl;
@property (nonatomic, strong) CHAutoSlideScrollView *kvScrollView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchField;

@end

@implementation DiscoveryViewController

- (void) viewWillAppear:(BOOL)animated
{
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Discovery";
    self.navigationController.navigationBarHidden = YES;
    [self setupDiscoveryTV];
    [self setupSearchNav];
    [self setupLogo];
    

    // Do any additional setup after loading the view.
}

- (void) setupLogo {
    
    UIView *imgView = [UIView newAutoLayoutView];
    [self.searchView addSubview:imgView];
    
    [imgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_searchView withOffset:20];
    [imgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchView];
    [imgView autoSetDimensionsToSize:CGSizeMake(60, 40)];
    imgView.backgroundColor = [UIColor grayColor];
    imgView.clipsToBounds = YES;
    
    UIImageView *imgbg = [UIImageView newAutoLayoutView];
    [imgView addSubview:imgbg];
    
    [imgbg autoAlignAxis:ALAxisVertical toSameAxisOfView:imgView];
    [imgbg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imgView];
    [imgbg autoSetDimensionsToSize:CGSizeMake(80, 80)];
    imgbg.image = [UIImage imageNamed:@"11.pic.jpg"];
    imgbg.clipsToBounds = YES;
    imgbg.rotate(360).animate(20.0);
    
    UIImageView *imgLogo = [UIImageView newAutoLayoutView];
    [imgView addSubview:imgLogo];
    
    [imgLogo autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:imgView];
    [imgLogo autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imgView];
    [imgLogo autoSetDimensionsToSize:CGSizeMake(60, 40)];
    imgLogo.image = [UIImage imageNamed:@"goLogoEmpty"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupSearchNav {

    self.searchView = [UIView newAutoLayoutView];
    [self.view addSubview:_searchView];
    
    [_searchView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:20];
    [_searchView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_searchView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 44)];
    
    _searchView.backgroundColor = [UIColor whiteColor];

    UIImageView *bgView = [UIImageView newAutoLayoutView];
    [self.searchView addSubview:bgView];
    
    
    [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_searchView withOffset:-20];
    [bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchView];
    [bgView autoSetDimensionsToSize:CGSizeMake(180, 25)];
    bgView.image = [UIImage imageNamed:@"searchBarbg"];
    
    UIImageView *iconView = [UIImageView newAutoLayoutView];
    [self.searchView addSubview:iconView];
    
    [iconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:5];
    [iconView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:bgView];
    [iconView autoSetDimensionsToSize:CGSizeMake(15, 15)];
    iconView.image = [UIImage imageNamed:@"searchIcon"];
    
    self.searchField = [UITextField newAutoLayoutView];
    [self.searchView addSubview:_searchField];
    
    [_searchField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_searchView withOffset:-15];
    [_searchField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchView];
    [_searchField autoSetDimensionsToSize:CGSizeMake(150, 30)];
    _searchField.placeholder = @"彩虹Go!";
    
    
}

- (void) setupDiscoveryTV {
    self.discoveryTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_discoveryTV];
    
//    [_discoveryTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_discoveryTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:44];
    [_discoveryTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];

    
    _discoveryTV.delegate = self;
    _discoveryTV.dataSource = self;
    
    [self.discoveryTV registerClass:[DiscoveryTableViewCell class] forCellReuseIdentifier:DISCOVERY_CELL];
    
    [self setupKV];
    
}

- (void) setupKV {
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i = 0; i < 4; ++i) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, 142);
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad%d.jpg", i + 1]];
        [viewsArray addObject:imgView];
    }
    
    self.discoveryHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 142)];

    self.kvScrollView = [[CHAutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 142) animationDuration:5];
    
    [self.discoveryHV removeFromSuperview];
    
    self.kvScrollView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
    
    self.kvScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    self.kvScrollView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%d个kv", pageIndex);
    };
    
    [self.discoveryHV addSubview:self.kvScrollView];
    self.discoveryTV.tableHeaderView = _discoveryHV;
}

- (void) setupDiscoveryTVHeaderView {
//    self.discoveryHV = [[UIView alloc] initForAutoLayout];
    self.discoveryHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    self.adScrollView = [UIScrollView newAutoLayoutView];
    [self.discoveryHV addSubview:_adScrollView];
    
    [_adScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_discoveryHV];
    _adScrollView.contentSize = CGSizeMake(ScreenWidth * 3, _adScrollView.frame.size.height);
    _adScrollView.delegate = self;
    _adScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置分页
    _adScrollView.pagingEnabled = YES;
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, 200);
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad%d.jpg", i + 1]];
//        NSURL *imageUrl = [NSURL URLWithString:[self.imgArr objectAtIndex:i]];
//        [imgView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"productDemo3"]];
        
//                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.imgArr objectAtIndex:i]]];
        
        [_adScrollView addSubview:imgView];
    
    }
    
    self.adPageControl = [[UIPageControl alloc] init];
    
//    self.adPageControl = [UIPageControl newAutoLayoutView];
    
    _adPageControl.center = CGPointMake(ScreenWidth / 2, 180);
    _adPageControl.bounds = CGRectMake(0, 0, 16*(3-1)+16, 16);
    _adPageControl.numberOfPages = 3;
    _adPageControl.pageIndicatorTintColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
    _adPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _adPageControl.enabled = NO;
    
    [_discoveryHV addSubview:_adPageControl];

    _discoveryHV.backgroundColor = [UIColor clearColor];
    
    self.discoveryTV.tableHeaderView = _discoveryHV;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _adPageControl.currentPage = page;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 294;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DISCOVERY_CELL forIndexPath:indexPath];
    cell.titleLB.text = @"松本清特惠专场";
    cell.leftLB.text = @"剩余 20 天";
    cell.bgImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad0%d.jpg", indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DiscoveryDetailViewController *detail = [[DiscoveryDetailViewController alloc] init];
    
    if (indexPath.row == 1) {
        detail.webUrl = @"http://api.atniwo.com/web.php";
    }else{
        detail.webUrl = @"http://api.atniwo.com/product.html";
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.searchField resignFirstResponder];
}


@end
