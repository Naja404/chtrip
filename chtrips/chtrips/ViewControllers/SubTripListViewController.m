//
//  SubTripListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/12.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "SubTripListViewController.h"
#import "SubTripListTableViewCell.h"
#import "AddSubTripViewController.h"

#import "NSDate+Fomatter.h"
#import "NSDate-Utilities.h"
#import "NSDate+DateTools.h"
#import "ChtripCDManager.h"
#import "SubTrip.h"

static NSString * const SUB_TRIP_CELL = @"SubTripListCell";
static NSString * const SECTION_ADD_MARK = @"section";

@interface SubTripListViewController ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, AddSubTripViewControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *subTripTV;
@property (nonatomic, strong) NSNumber *lastDate;

@end

@implementation SubTripListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupSubListTV];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewDay)];
    
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
    SubTripListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUB_TRIP_CELL forIndexPath:indexPath];
    
    SubTrip *subTrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([subTrip.subTitle isEqualToString:SECTION_ADD_MARK]) {
        cell.subTitleLB.text = NSLocalizedString(@"TEXT_ADD_SUBTRIP", Nil);

        UIImageView *addImg = [UIImageView newAutoLayoutView];
        [cell.contentView addSubview:addImg];
        [addImg autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cell.subTitleLB];
        [addImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cell.subTitleLB];
        [addImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
        addImg.image = [UIImage imageNamed:@"addIcon"];
    }else{
        cell.subTitleLB.text = subTrip.subTitle;
        
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[subTrip.subStartTime doubleValue]];
        cell.subTimeLB.text = [startTime formattedDateWithFormat:@"HH:mm"];
    }
    
    
    return cell;
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
    
    AddSubTripViewController *addSubTripVC = [[AddSubTripViewController alloc] init];
    
    addSubTripVC.keyID = subTripObj.keyID;
    addSubTripVC.subDate = subTripObj.subDate;
    addSubTripVC.addSubTripDelegate = self;
    
    if ([subTripObj.subTitle isEqualToString:SECTION_ADD_MARK]) {
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addSubTripVC];
        addSubTripVC.navigationItem.title = NSLocalizedString(@"TEXT_ADD_SUBTRIP", Nil);
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
    }else{
        addSubTripVC.navigationItem.title = subTripObj.subTitle;
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
                                 [NSNumber numberWithDouble:newLastTime], @"subDate",
                                 @"section", @"subTitle",
                                 nil];
    
    [TripCD addSubTripSections:subTripData];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
