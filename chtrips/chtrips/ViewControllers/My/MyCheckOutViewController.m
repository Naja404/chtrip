//
//  MyCheckOutViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/11.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyCheckOutViewController.h"
#import "MyCheckOutTableViewCell.h"

static NSString * const MY_CHECKOUT_CELL = @"myCheckOutCell";

@interface MyCheckOutViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *checkoutTV;
@property (nonatomic, strong) UIButton *checkOutBTN;

@end

@implementation MyCheckOutViewController

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setStyle];
}

#pragma mark - 初始化样式
- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"TEXT_CONFIRM_ORDER", nil);
    
    self.checkoutTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_checkoutTV];
    
    [_checkoutTV autoPinToTopLayoutGuideOfViewController:self withInset:-64];
    [_checkoutTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_checkoutTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-50];
    [_checkoutTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    _checkoutTV.delegate = self;
    _checkoutTV.dataSource = self;
    
    [_checkoutTV registerClass:[MyCheckOutTableViewCell class] forCellReuseIdentifier:MY_CHECKOUT_CELL];
    
    self.checkOutBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:_checkOutBTN];
    
    [_checkOutBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_checkoutTV];
    [_checkOutBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_checkOutBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_checkOutBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    [_checkOutBTN setTitle:@"确认并支付" forState:UIControlStateNormal];
    [_checkOutBTN setBackgroundColor:RED_COLOR_BG];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }else{
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 60;
    }else{
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    titleV.backgroundColor = [UIColor blackColor];
    UILabel *titleLB = [UILabel newAutoLayoutView];
    [titleV addSubview:titleLB];
    
    [titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLB];
    [titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleV withOffset:20];
    [titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 30)];
    titleLB.font = FONT_SIZE_16;
    titleLB.textColor = BLACK_FONT_COLOR;
    titleLB.text = @"section标题";
    titleLB.backgroundColor = GRAY_FONT_COLOR;
    
    return titleV;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_CHECKOUT_CELL forIndexPath:indexPath];
    cell.titleLB.text = @"cell 内容";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
