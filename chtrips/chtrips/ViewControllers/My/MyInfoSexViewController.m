//
//  MyInfoSexViewController.m
//  chtrips
//
//  Created by Hisoka on 15/11/4.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoSexViewController.h"
#import "MyInfoSexTableViewCell.h"


static NSString * const MY_SEX_CELL = @"myInfoSexCell";

@interface MyInfoSexViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *sexTV;
@property (nonatomic, strong) NSArray *cellVal;

@end

@implementation MyInfoSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setStyle];
}

- (void) setStyle {
    self.navigationItem.title = NSLocalizedString(@"TEXT_EDIT_SEX", nil);
    self.view.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    self.sexTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_sexTV];
    
    [_sexTV autoPinToTopLayoutGuideOfViewController:self withInset:-64.0];
    [_sexTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_sexTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_sexTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _sexTV.delegate = self;
    _sexTV.dataSource = self;
    _sexTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sexTV.backgroundColor = GRAY_COLOR_CITY_CELL;

    [_sexTV registerClass:[MyInfoSexTableViewCell class] forCellReuseIdentifier:MY_SEX_CELL];
    self.cellVal = @[NSLocalizedString(@"TEXT_SEX_0", nil), NSLocalizedString(@"TEXT_SEX_1", nil), NSLocalizedString(@"TEXT_SEX_2", nil)];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInfoSexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_SEX_CELL];
    
    if ([_sex isEqualToString:[NSString stringWithFormat:@"%@", [_cellVal objectAtIndex:indexPath.row]]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.titleLB.text = [_cellVal objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setUserInfoAction:[NSString stringWithFormat:@"%lu", (long)indexPath.row]];
}

- (void) setUserInfoAction:(NSString *)sex {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [parameters setObject:sex forKey:@"sex"];
    
    [[HttpManager instance] requestWithMethod:@"User/setInfo"
                                   parameters:parameters
                                      success:^(NSDictionary *result) {
                                          NSArray *userInfoTmp = [[result objectForKey:@"data"] objectForKey:@"user_info"];
                                          
                                          [[TMCache sharedCache] setObject:userInfoTmp forKey:@"userInfo"];
                                          _sex = [userInfoTmp objectAtIndex:3];
                                          [_sexTV reloadData];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
