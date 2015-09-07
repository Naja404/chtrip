//
//  MyWantListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/8/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyWantListViewController.h"
#import "PlayTableViewCell.h"
#import "UIImageView+AFNetworking.h"

static NSString * const WANTGO_CELL = @"wantGoCell";

@interface MyWantListViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *wantGoTV;
@property (nonatomic, strong) NSMutableArray *wantGoData;
@property (nonatomic, strong) UIRefreshControl *refreshTV;


@end

@implementation MyWantListViewController


- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWantGoTV];
    [self refresh:self.refreshTV];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupWantGoTV {
    self.view.backgroundColor = [UIColor whiteColor];
    self.wantGoTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_wantGoTV];
    
//    [_wantGoTV autoPinToTopLayoutGuideOfViewController:self withInset:44];
    [_wantGoTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:54];
    [_wantGoTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_wantGoTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_wantGoTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _wantGoTV.delegate = self;
    _wantGoTV.dataSource = self;
    _wantGoTV.separatorStyle = UITableViewCellAccessoryNone;
    
    self.refreshTV = [[UIRefreshControl alloc] init];
    [_wantGoTV addSubview:_refreshTV];
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.wantGoTV registerClass:[PlayTableViewCell class] forCellReuseIdentifier:WANTGO_CELL];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.wantGoData count] <= 0) {
        return 0;
    }else{
        return [self.wantGoData count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WANTGO_CELL];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.wantGoData objectAtIndex:indexPath.row]];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"pic_url"]];
    [cell.proImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPic.jpg"]];
    
    cell.bigTitleLB.text = [cellData objectForKey:@"name"];
    cell.avgLB.text = [cellData objectForKey:@"avg_price"];
    cell.areaLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"area"]];
    cell.cateLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"category"]];
    
    NSInteger starSize = [[cellData objectForKey:@"avg_rating"] intValue];
    
    UIImageView *grayStar = [UIImageView newAutoLayoutView];
    [cell.contentView addSubview:grayStar];
    
    [grayStar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.bigTitleLB withOffset:starSize];
    [grayStar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.bigTitleLB withOffset:5];
    [grayStar autoSetDimensionsToSize:CGSizeMake(85 - starSize, 18)];
    grayStar.backgroundColor = [UIColor whiteColor];
    //    grayStar.image = [UIImage imageNamed:@"starProRed"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark 获取商家列表
- (void) getWantGoList {
    [SVProgressHUD show];
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    //    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getWantList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"getWantList data is %@", result);
                                          self.wantGoData = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"data"]];
                                          [self.wantGoTV reloadData];
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD dismiss];
                                      }];
}

- (void) refresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    [self getWantGoList];
    [control endRefreshing];
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
