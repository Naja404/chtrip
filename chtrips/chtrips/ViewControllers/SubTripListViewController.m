//
//  SubTripListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/12.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "SubTripListViewController.h"
#import "SubTripListTableViewCell.h"
#import "SubTripListNormalTableViewCell.h"
#import "AddSubTripViewController.h"
#import "EditSubTripViewController.h"
#import "BuyListViewController.h"

#import "NSDate+Fomatter.h"
#import "NSDate-Utilities.h"
#import "NSDate+DateTools.h"
#import "AwesomeMenu.h"
#import "ChtripCDManager.h"
#import "SubTrip.h"

static NSString * const SUB_TRIP_CELL = @"SubTripListCell";
static NSString * const SUB_TRIP_NORMAL_CELL = @"SubTripNormalCell";
static NSString * const SECTION_ADD_MARK = @"section";

@interface SubTripListViewController ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, AddSubTripViewControllerDelegate, EditSubTripViewControllerDelegate, AwesomeMenuDelegate>
{
    bool rightNavFlag;

}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *subTripTV;
@property (nonatomic, strong) NSNumber *lastDate;
@property (nonatomic, strong) SubTripListTableViewCell *subTripCell;
@property (nonatomic, strong) SubTripListNormalTableViewCell *subTripNormalCell;

@property (nonatomic, strong) UIImageView *rightMenuImg;
@property (nonatomic, strong) UIButton *addDayBTN;
@property (nonatomic, strong) UIButton *buyListBTN;
@property (nonatomic, strong) UIButton *navRightButton;

@end

@implementation SubTripListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubListTV];
    
//    rightNavFlag = NO;
    
//    [self setupRightNavMenu];
    
    [self setupAddMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置子行程列表
- (void) setupSubListTV
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.tripName;
//    UIBarButtonItem *addDayBTN = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewDay)];
//    UIBarButtonItem *addBuyBTN = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(addNewBuy)];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addBuyBTN, addDayBTN, nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRightNavBTN)];
    
//    self.navRightButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    [_navRightButton setFrame:CGRectMake(281, 7, 30, 30)];
//    [_navRightButton setBackgroundImage:[UIImage imageNamed:@"rightNav"] forState:UIControlStateNormal];
//    [_navRightButton addTarget:self action:@selector(clickRightNavBTN) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:_navRightButton];
    
    self.subTripTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_subTripTV];
    
    [_subTripTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_subTripTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_subTripTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_subTripTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _subTripTV.dataSource = self;
    _subTripTV.delegate = self;
    _subTripTV.separatorColor = UITableViewCellAccessoryNone;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [_subTripTV addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.subTripTV registerClass:[SubTripListTableViewCell class] forCellReuseIdentifier:SUB_TRIP_CELL];
    [self.subTripTV registerClass:[SubTripListNormalTableViewCell class] forCellReuseIdentifier:SUB_TRIP_NORMAL_CELL];
}

#pragma mark fetch subtrip数据
- (NSFetchedResultsController *) fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *subTripEntiry = [NSEntityDescription entityForName:@"SubTrip" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:subTripEntiry];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"keyID = %@", self.keyID];
    
    [fetchRequest setPredicate:predicate];
    //[fetchRequest setFetchBatchSize:10];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"subDate" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]
                                                                      sectionNameKeyPath:@"subDate"
                                                                               cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    NSError *error = NULL;
    
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark 更新fetch数据

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_subTripTV reloadData];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
}


#pragma mark 开始设置subtrip list
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    
    SubTrip *subTrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([subTrip.subTitle isEqualToString:SECTION_ADD_MARK]) {
        self.subTripCell = [tableView dequeueReusableCellWithIdentifier:SUB_TRIP_CELL forIndexPath:indexPath];
        _subTripCell.subTitleLB.text = NSLocalizedString(@"TEXT_ADD_SUBTRIP", Nil);
        
        cell = _subTripCell;
    }else{
        self.subTripNormalCell = [tableView dequeueReusableCellWithIdentifier:SUB_TRIP_NORMAL_CELL forIndexPath:indexPath];
        _subTripNormalCell.subTitleLB.text = subTrip.subTitle;
        
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[subTrip.subStartTime doubleValue]];
        _subTripNormalCell.subTimeLB.text = [startTime formattedDateWithFormat:@"HH:mm"];
        _subTripNormalCell.addressLB.text = subTrip.subAddress;
        
        CGSize textSize = [subTrip.subAddress sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13]}];
        
        if (textSize.width > 220) {
            textSize.width = 220;
        }else{
            textSize.width += 20;
        }
        
        [_subTripNormalCell.addressLB autoSetDimensionsToSize:CGSizeMake(textSize.width, 20)];
        
        cell = _subTripNormalCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"TEXT_DELETE", Nil);
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
    }
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UIView *autoSectionView = [UIView newAutoLayoutView];
    [sectionView addSubview:autoSectionView];

    [autoSectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:sectionView];
    [autoSectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:sectionView];
    [autoSectionView autoSetDimensionsToSize:CGSizeMake(200, 50)];
    
    UIImageView *dayIcon = [UIImageView newAutoLayoutView];
    [autoSectionView addSubview:dayIcon];
    
    [dayIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:autoSectionView];
    [dayIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:autoSectionView];
    [dayIcon autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    dayIcon.image = [UIImage imageNamed:@"day"];
    
    // day 图标上的数字
    UILabel *dayNumLB = [UILabel newAutoLayoutView];
    [autoSectionView addSubview:dayNumLB];
    
    [dayNumLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:autoSectionView withOffset:18.0];
    [dayNumLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:autoSectionView withOffset:-5.0];
    [dayNumLB autoSetDimensionsToSize:CGSizeMake(20, 20)];
    dayNumLB.text = [NSString stringWithFormat:@"%d", section + 1];
    dayNumLB.textColor = [UIColor redColor];
    dayNumLB.backgroundColor = [UIColor whiteColor];
    
    UILabel *dateLB = [UILabel newAutoLayoutView];
    [autoSectionView addSubview:dateLB];
    
//    [dateLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:autoSectionView];
    [dateLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:dayIcon withOffset:20.0];
    [dateLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:autoSectionView];
    [dateLB autoSetDimensionsToSize:CGSizeMake(200, 20)];
    
    NSArray *sections = [self.fetchedResultsController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
    
    sectionInfo = [sections objectAtIndex:section];
    SubTrip *subTripObj = [sectionInfo objects][0];
    
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[subTripObj.subDate doubleValue]];
    
//    dateLB.text = [NSString stringWithFormat:@"%@", subTripObj.subDate];
    
    dateLB.text = [dateTime formattedDateWithFormat:[NSString stringWithFormat:@"MM%@dd%@", NSLocalizedString(@"TEXT_MONTH", Nil), NSLocalizedString(@"TEXT_DAY", Nil)]];
    dateLB.textColor = [UIColor grayColor];

    return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubTrip *subTripObj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    

    

    
    if ([subTripObj.subTitle isEqualToString:SECTION_ADD_MARK]) {
        AddSubTripViewController *addSubTripVC = [[AddSubTripViewController alloc] init];
        
        addSubTripVC.keyID = subTripObj.keyID;
        addSubTripVC.subDate = subTripObj.subDate;
        addSubTripVC.addSubTripDelegate = self;
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addSubTripVC];
        addSubTripVC.navigationItem.title = NSLocalizedString(@"TEXT_ADD_SUBTRIP", Nil);
        
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
        
    }else{
        EditSubTripViewController *editSubTripVC = [[EditSubTripViewController alloc] init];
        
        editSubTripVC.keyID = subTripObj.keyID;
        editSubTripVC.subID = subTripObj.subID;
        editSubTripVC.subTripName = subTripObj.subTitle;
        editSubTripVC.subDate = subTripObj.subDate;
        editSubTripVC.subTime = [NSDate dateWithTimeIntervalSince1970:[subTripObj.subEndTime doubleValue]];;
        editSubTripVC.subAddressName = subTripObj.subAddress;
        editSubTripVC.lat = subTripObj.subLat;
        editSubTripVC.lng = subTripObj.subLng;
        editSubTripVC.editSubTripDelegate = self;
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:editSubTripVC];
        editSubTripVC.navigationItem.title = subTripObj.subTitle;
        
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    }
    

}

#pragma mark 新增一天
- (void) addNewDay
{
    ChtripCDManager *TripCD = [[ChtripCDManager alloc] init];
    
    NSArray *lastDateArr = [TripCD getSubTripLastDateByKeyID:self.keyID];
    
    for (SubTrip *ch in lastDateArr) {
         self.lastDate = ch.subDate;
    }
    
    int newLastTime = [self.lastDate doubleValue] + 3600 * 24;
    
    NSDictionary *subTripData = [[NSDictionary alloc] initWithObjectsAndKeys:self.keyID, @"keyID",
                                                                            [TripCD makeKeyID], @"subID",
                                                                            [NSNumber numberWithDouble:newLastTime], @"subDate",
                                                                            @"section", @"subTitle",
                                 nil];
    
    [TripCD addSubTripSections:subTripData];
    
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_ADD_NEW_DAY_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
    
}

#pragma mark 欲购清单
- (void) pushViewBuyList
{
    BuyListViewController *buyListVC = [[BuyListViewController alloc] init];
    buyListVC.keyID = self.keyID;
    
    [self.navigationController pushViewController:buyListVC animated:YES];
}

#pragma mark 刷新tableview
- (void) refreshTableView
{
    NSLog(@"refresh sub trip table view");
    [self.subTripTV reloadData];
}

- (void)refresh:(UIRefreshControl *)control {
    [control endRefreshing];
    [self.subTripTV reloadData];
}

#pragma mark 初始化右侧按钮展开内容
- (void) setupRightNavMenu
{
    self.rightMenuImg = [UIImageView newAutoLayoutView];
    [self.view addSubview:_rightMenuImg];

    [_rightMenuImg autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_rightMenuImg autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:10];
    [_rightMenuImg autoSetDimensionsToSize:CGSizeMake(100, 100)];
    _rightMenuImg.backgroundColor = [UIColor colorWithRed:56.0/255 green:92.0/255 blue:99.0/255 alpha:0.9];
    _rightMenuImg.hidden = YES;
    
    self.addDayBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightMenuImg addSubview:_addDayBTN];
    [_addDayBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_rightMenuImg withOffset:10.0];
    [_addDayBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:_rightMenuImg];
    [_addDayBTN autoSetDimensionsToSize:CGSizeMake(80, 20)];
    [_addDayBTN setTitle:NSLocalizedString(@"TEXT_ADD_NEWDAY", Nil) forState:UIControlStateNormal];
    _addDayBTN.alpha = 0;
    
    self.buyListBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightMenuImg addSubview:_buyListBTN];
    [_buyListBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_addDayBTN withOffset:10.0];
    [_buyListBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_rightMenuImg];
    [_buyListBTN autoSetDimensionsToSize:CGSizeMake(80, 20)];
    [_buyListBTN setTitle:NSLocalizedString(@"TEXT_BUY_LIST", Nil) forState:UIControlStateNormal];
    _buyListBTN.alpha = 0;

}

#pragma mark 点击导航右侧按钮
- (void) clickRightNavBTN
{
    if (rightNavFlag) {
        _rightMenuImg.hidden = NO;
        CGAffineTransform navRound =CGAffineTransformMakeRotation(M_PI/-3);//先顺时钟旋转90
        navRound =CGAffineTransformTranslate(navRound,0,0);
        
        [UIView animateWithDuration:0.35f
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction|
                                     UIViewAnimationOptionBeginFromCurrentState)
                         animations:^(void) {
                             
                             _addDayBTN.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0*-10,45*0);
                             _buyListBTN.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,1*-10,45*1);
                            _addDayBTN.alpha = 1;
                             _buyListBTN.alpha = 1;
                             
                             [_navRightButton setTransform:navRound];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                 
                                _addDayBTN.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0*-10,40.0*0);
                                _buyListBTN.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,1*-10,40.0*1);
                                 
                             } completion:NULL];
                         }];
        
    }else{
        _rightMenuImg.hidden = YES;
        CGAffineTransform navRound =CGAffineTransformMakeRotation(0);//先顺时钟旋转90
        navRound =CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.35f
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction|
                                     UIViewAnimationOptionBeginFromCurrentState)
                         animations:^(void) {
                             
                             _addDayBTN.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0*-10,45*0);
                             _buyListBTN.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,1*-10,45*1);

                             _addDayBTN.alpha = 1;
                             _buyListBTN.alpha = 1;

                             
                             [_navRightButton setTransform:navRound];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             
                         }];
    }
    
    rightNavFlag = !rightNavFlag;
}

#pragma mark 设置加号按钮
- (void) setupAddMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    NSArray *menuItems = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
//    UIView *menuView = [UIView newAutoLayoutView];
//    [self.view addSubview:menuView];
//    
//    [menuView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.subTripTV];
//    [menuView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
//    [menuView autoSetDimensionsToSize:CGSizeMake(100, 100)];
//    menuView.backgroundColor = [UIColor blackColor];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(0, 0, 100, 100) startItem:startItem menuItems:menuItems];
    menu.delegate = self;

    menu.rotateAngle = -45.0;
    menu.menuWholeAngle = M_SQRT1_2;
    CGFloat menuX = 280;
    CGFloat menuY = 500;
    if (IS_IPHONE4) {
        menuY = 380;
    }else if (IS_IPHONE6){
        menuX = 315;
        menuY = 550;
    }else if (IS_IPHONE6P){
        menuX = 415;
        menuY = 620;
    }
    
    menu.startPoint = CGPointMake(menuX, menuY);
    
    [self.view addSubview:menu];
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    
    switch (idx) {
        case 0:
            [self addNewDay];
            break;
        case 1:
            [self pushViewBuyList];
            break;
        case 2:
            [self deleteTrip];
        default:
            break;
    }
    
    
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}

#pragma mark 删除行程
- (void) deleteTrip
{
    NSLog(@"delete trip");
}

@end
