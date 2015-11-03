//
//  MyInfoViewController.m
//  chtrips
//
//  Created by Hisoka on 15/11/3.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoNormalTableViewCell.h"
#import "MyInfoAvatarTableViewCell.h"

static NSString * const MY_INFO_CELL = @"myInfoCell";
static NSString * const MY_INFO_NORMAL_CELL = @"myNormalCell";

@interface MyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myInfoTV;
@property (nonatomic, strong) NSArray *cellTitle;
@property (nonatomic, strong) NSArray *cellVal;
@property (nonatomic, strong) UIButton *logoutBTN;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setStyle];
}

- (void) setStyle {
    self.navigationItem.title = NSLocalizedString(@"TEXT_MY_INFO", nil);
    self.view.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    self.cellTitle = @[@"", NSLocalizedString(@"TEXT_NICKNAME", nil), NSLocalizedString(@"TEXT_MOBILE", nil), NSLocalizedString(@"TEXT_SEX", nil)];
    self.cellVal = @[@"", @"JeffZhang", @"18616594619", @"男"];
    
    self.myInfoTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_myInfoTV];
    
    [_myInfoTV autoPinToTopLayoutGuideOfViewController:self withInset:-64.0];
    [_myInfoTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_myInfoTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_myInfoTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _myInfoTV.delegate = self;
    _myInfoTV.dataSource = self;
    _myInfoTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myInfoTV.backgroundColor = GRAY_COLOR_CITY_CELL;

    
    [_myInfoTV registerClass:[MyInfoNormalTableViewCell class] forCellReuseIdentifier:MY_INFO_NORMAL_CELL];
    [_myInfoTV registerClass:[MyInfoAvatarTableViewCell class] forCellReuseIdentifier:MY_INFO_CELL];
    
    self.logoutBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:_logoutBTN];
    
    [_logoutBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_logoutBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_logoutBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    [_logoutBTN setTitle:NSLocalizedString(@"BTN_LOGOUT", nil) forState:UIControlStateNormal];
    [_logoutBTN addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    _logoutBTN.titleLabel.textAlignment = NSTextAlignmentCenter;
    _logoutBTN.backgroundColor = ORINGE_COLOR_BG;
    
}

- (void) logoutAction {
    [[TMCache sharedCache] setObject:@"0" forKey:@"loginStatus"];
    [[TMCache sharedCache] setObject:@"" forKey:@"userAvatar"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return ScreenWidth / 2.3;
    }else{
        return 40;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        MyInfoAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_INFO_CELL];

        return cell;
    }else{
        MyInfoNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_INFO_NORMAL_CELL];
        
        if (indexPath.row != 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 右侧箭头
        }
        
        if (indexPath.row == 3) {
            cell.cutLineLB.hidden = YES;
        }else{
            cell.cutLineLB.hidden = NO;
        }
        
        cell.textLB.text = [_cellTitle objectAtIndex:indexPath.row];
        cell.valLB.text = [_cellVal objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
