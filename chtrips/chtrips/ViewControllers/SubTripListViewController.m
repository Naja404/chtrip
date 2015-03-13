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
#import "SubTrip.h"

static NSString * const SUB_TRIP_CELL = @"SubTripListCell";
static NSString * const SECTION_ADD_MARK = @"section";

@interface SubTripListViewController ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *subTripTV;

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
    
    self.subTripTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_subTripTV];
    
    [_subTripTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_subTripTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_subTripTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_subTripTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _subTripTV.dataSource = self;
    _subTripTV.delegate = self;
    _subTripTV.separatorColor = UITableViewCellAccessoryNone;
    
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"keyID = %@", self.keyID]];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"subEndTime" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[CoreDataManager sharedManager].managedObjectContext
                                                                      sectionNameKeyPath:@"subDate"
                                                                               cacheName:@"subTripFetchResultCache"];
    
    _fetchedResultsController.delegate = self;
    
    NSError *error = NULL;
    
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark 更新fetch数据
- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = _subTripTV;
    
    if (type == NSFetchedResultsChangeInsert) {
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_subTripTV reloadData];
    [_subTripTV endUpdates];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_subTripTV beginUpdates];
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
    }else{
        cell.subTitleLB.text = subTrip.subTitle;
        cell.subTimeLB.text = @"05:00 - 06:00";
    }
    
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    sectionView.backgroundColor = [UIColor grayColor];
    
    UIView *autoSectionView = [UIView newAutoLayoutView];
    [sectionView addSubview:autoSectionView];

    [autoSectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:sectionView];
    [autoSectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:sectionView];
    [autoSectionView autoSetDimensionsToSize:CGSizeMake(200, 30)];
    
    UILabel *dateLB = [UILabel newAutoLayoutView];
    [autoSectionView addSubview:dateLB];
    
    [dateLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:autoSectionView];
    [dateLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:autoSectionView];
    [dateLB autoSetDimensionsToSize:CGSizeMake(200, 20)];
    dateLB.text = @"1";
    
    NSArray *sections = [_fetchedResultsController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
    
    sectionInfo = [sections objectAtIndex:section];
    SubTrip *subTripObj = [sectionInfo objects][0];
    
    dateLB.text = [NSString stringWithFormat:@"%@", subTripObj.subDate];

    return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubTrip *subTripObj = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    AddSubTripViewController *addSubTripVC = [[AddSubTripViewController alloc] init];
    
    addSubTripVC.keyID = subTripObj.keyID;
    addSubTripVC.subDate = subTripObj.subDate;
    
    if ([subTripObj.subTitle isEqualToString:SECTION_ADD_MARK]) {
        addSubTripVC.navigationItem.title = NSLocalizedString(@"TEXT_ADD_SUBTRIP", Nil);
    }else{
        addSubTripVC.navigationItem.title = subTripObj.subTitle;
    }
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addSubTripVC];
    
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
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
