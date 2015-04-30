//
//  MyViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyViewController.h"
#import "MyAvatarTableViewCell.h"
#import "MyNormalTableViewCell.h"

static NSString * const MY_AVATAR_CELL = @"myAvatarCell";
static NSString * const MY_NORMAL_CELL = @"myNormalCell";

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTV;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"My";
    // Do any additional setup after loading the view.
    [self setupMyStyle];
}

- (void) setupMyStyle {
    self.myTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTV.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_myTV];
    
    [_myTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_myTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_myTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_myTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _myTV.dataSource = self;
    _myTV.delegate = self;
    
    [self.myTV registerClass:[MyAvatarTableViewCell class] forCellReuseIdentifier:MY_AVATAR_CELL];
    [self.myTV registerClass:[MyNormalTableViewCell class] forCellReuseIdentifier:MY_NORMAL_CELL];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 40;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0 && indexPath.row == 0) {
        MyAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_AVATAR_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else {
        MyNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_NORMAL_CELL forIndexPath:indexPath];
        
        NSString *titleText = nil;
        NSString *imgPath = nil;
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                titleText = @"TEXT_CELL_BUY_LIST";
                imgPath = @"iconBuyList";
            }else if (indexPath.row == 1){
                titleText = @"TEXT_MY_WANT_GO";
                imgPath = @"iconLikeGo";
            }else if (indexPath.row == 2){
                titleText = @"TEXT_FAVORITES";
                imgPath = @"iconFavorites";
            }
        }
        
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                titleText = @"TEXT_ABOUT_US";
                imgPath = @"iconAboutUs";
            }else if (indexPath.row == 1){
                titleText = @"TEXT_FEEDBACK";
                imgPath = @"iconFeedBack";
            }
        }
        
        cell.titleLB.text = NSLocalizedString(titleText, nil);
        cell.iconImg.image = [UIImage imageNamed:imgPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 右侧箭头
        
        return cell;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
