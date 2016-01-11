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
#import "MyFeedBackViewController.h"
#import "MyAboutUsViewController.h"
#import "MyBuyListViewController.h"
#import "MyWantListViewController.h"
#import "MyLoginSelectViewController.h"
#import "MyInfoViewController.h"
#import "MyOrderTitleTableViewCell.h"
#import "MyOrderIconTableViewCell.h"
#import "MyCartViewController.h"
#import "MyOrderViewController.h"


static NSString * const MY_AVATAR_CELL = @"myAvatarCell";
static NSString * const MY_NORMAL_CELL = @"myNormalCell";
static NSString * const MY_ORDER_CELL = @"myOrderTitleCell";
static NSString * const MY_ORDER_ICON_CELL = @"myOrderIconCell";

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *myTV;
@property (nonatomic, strong) NSString *loginStatus;

@end

@implementation MyViewController

- (void) viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self setupUserInfo];
    
    [self.myTV reloadData];

    if([[TMCache sharedCache] objectForKey:@"weChatOpenId"]){
        [[TMCache sharedCache] removeObjectForKey:@"weChatOpenId"];
    }
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"My";
    [self setupMyStyle];
    [self setupUserInfo];
}

- (void) setupUserInfo {
    
    self.loginStatus = [[TMCache sharedCache] objectForKey:@"loginStatus"];
    
    if ([self.loginStatus isEqualToString:@"1"]) {
        self.loginStatus = @"1";
        [[TMCache sharedCache] setObject:@"1" forKey:@"loginStatus"];
    }else{
        self.loginStatus = @"0";
        [[TMCache sharedCache] setObject:@"0" forKey:@"loginStatus"];
    }
    
    
}

- (void) setupMyStyle {
    
    self.myTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTV.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_myTV];
    
    [_myTV autoPinToTopLayoutGuideOfViewController:self withInset:-70.0];
    [_myTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_myTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_myTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _myTV.dataSource = self;
    _myTV.delegate = self;
    
    [self.myTV registerClass:[MyAvatarTableViewCell class] forCellReuseIdentifier:MY_AVATAR_CELL];
    [self.myTV registerClass:[MyNormalTableViewCell class] forCellReuseIdentifier:MY_NORMAL_CELL];
    [self.myTV registerClass:[MyOrderTitleTableViewCell class] forCellReuseIdentifier:MY_ORDER_CELL];
    [self.myTV registerClass:[MyOrderIconTableViewCell class] forCellReuseIdentifier:MY_ORDER_ICON_CELL];
    
    _myTV.backgroundColor = GRAY_COLOR_CITY_CELL;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.loginStatus isEqualToString:@"1"]) {
            return 3;
        }else{
            return 1;
        }
    }else if(section == 1){
        return 2;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return ScreenWidth / 2.3;
        }else if (indexPath.row == 1){
            return 40;
        }else{
            return 60;
        }
    }else{
        return 40;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_AVATAR_CELL forIndexPath:indexPath];
            if ([self.loginStatus isEqualToString:@"1"]) {
                cell.nameLB.text = [[TMCache sharedCache] objectForKey:@"userName"];
                
                NSURL *imageUrl = [NSURL URLWithString:[[TMCache sharedCache] objectForKey:@"userAvatar"]];
                [cell.avatarImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicBig"]];
            }else{
                cell.nameLB.text = NSLocalizedString(@"TEXT_REG_LOGIN", nil);
                cell.avatarImg.image = [UIImage imageNamed:@"defaultPicBig"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if (indexPath.row == 1){
            MyOrderTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ORDER_CELL forIndexPath:indexPath];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }else{
            MyOrderIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ORDER_ICON_CELL forIndexPath:indexPath];
            __weak typeof (self) weakSelf = self;
            cell.tapAction = ^(NSInteger index){
                NSArray *titleArr = @[@"TEXT_UNPAY", @"TEXT_UNDELIVERED", @"TEXT_UNCONFIRM", @"TEXT_COMPLETE"];
                MyOrderViewController *orderV = [[MyOrderViewController alloc] init];
                orderV.hidesBottomBarWhenPushed = YES;
                orderV.navigationItem.title = NSLocalizedString([titleArr objectAtIndex:(index - 10)], nil);
                [weakSelf.navigationController pushViewController:orderV animated:YES];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }else {
        MyNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_NORMAL_CELL forIndexPath:indexPath];
        
        NSString *titleText = nil;
        NSString *imgPath = nil;
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
//                titleText = @"TEXT_CELL_BUY_LIST";
                titleText = @"TEXT_MY_CART";
//                imgPath = @"iconBuyList";
                imgPath = @"iconCart";
            }else if (indexPath.row == 1){
                titleText = @"TEXT_MY_WANT_GO";
//                imgPath = @"iconLikeGo";
                imgPath = @"iconFavorite";
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if ([self.loginStatus isEqualToString:@"0"]) {
            // 在主线程执行
            dispatch_async(dispatch_get_main_queue(), ^{
                MyLoginSelectViewController *loginSelect = [[MyLoginSelectViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginSelect];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            });
        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注销登陆" message:@"是否确认注销登陆？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil];
//            [alert show];
            MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] init];
            myInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            MyBuyListViewController *myBuyList = [[MyBuyListViewController alloc] init];
//            myBuyList.navigationItem.title = NSLocalizedString(@"TEXT_CELL_BUY_LIST", Nil);
//            myBuyList.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:myBuyList animated:YES];
            
            MyCartViewController *myCart = [[MyCartViewController alloc] init];
            myCart.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myCart animated:YES];
        }else if (indexPath.row == 1){
            MyWantListViewController *myWantList = [[MyWantListViewController alloc] init];
            myWantList.navigationItem.title = NSLocalizedString(@"TEXT_CELL_WANT_LIST", Nil);
            myWantList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myWantList animated:YES];
        }else{
            
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            MyAboutUsViewController *myAboutUs = [[MyAboutUsViewController alloc] init];
            myAboutUs.navigationItem.title = NSLocalizedString(@"TEXT_ABOUT_US", Nil);
            myAboutUs.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myAboutUs animated:YES];
        }else{
            MyFeedBackViewController *myFeedback = [[MyFeedBackViewController alloc] init];
            myFeedback.navigationItem.title = NSLocalizedString(@"TEXT_FEEDBACK", Nil);
            myFeedback.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myFeedback animated:YES];
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
       self.loginStatus = @"0";
        [[TMCache sharedCache] setObject:@"0" forKey:@"loginStatus"];
        [[TMCache sharedCache] setObject:@"" forKey:@"userAvatar"];
        [self.myTV reloadData];
    }else if (buttonIndex == 0){
        NSLog(@"button index is 0");
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
