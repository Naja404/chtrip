//
//  TripListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "TripListViewController.h"
#import "TripListTableViewCell.h"
#import "AddTripViewController.h"
#import "SubTripListViewController.h"

#import "Trip.h"
#import "NSDate+DateTools.h"

static NSString * const TRIP_LIST_CELL = @"TripListCell";

@interface TripListViewController () <NSFetchedResultsControllerDelegate, AddTripViewControllerDelegate>

@property (nonatomic, retain) UITableView *tripListTV;
@property (nonatomic, retain) UIButton *addNewTripBTN;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TripListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTripTV];
    
    [self setupNavBTN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置行程列表
- (void) setupTripTV
{
    self.tripListTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_tripListTV];
    
    [_tripListTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_tripListTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_tripListTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_tripListTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _tripListTV.dataSource = self;
    _tripListTV.delegate = self;
    _tripListTV.separatorStyle = UITableViewCellAccessoryNone;
    _tripListTV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    [self.tripListTV registerClass:[TripListTableViewCell class] forCellReuseIdentifier:TRIP_LIST_CELL];
}

#pragma mark 设置导航栏
- (void) setupNavBTN
{
    UIBarButtonItem *rightBTN = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(pushAddTrip)];
    self.navigationItem.rightBarButtonItem = rightBTN;
    
    self.navigationItem.title = NSLocalizedString(@"TEXT_APP_TITLE", Nil);
}

#pragma mark
- (void) pushAddTrip
{
    AddTripViewController *addTrip = [[AddTripViewController alloc] init];
    addTrip.delegate = self;
    
    [self.navigationController pushViewController:addTrip animated:YES];
}


#pragma mark fetch数据
- (NSFetchedResultsController *) fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *tripEntiry = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    
    [fetchRequest setEntity:tripEntiry];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[CoreDataManager sharedManager].managedObjectContext
                                                                          sectionNameKeyPath:Nil
                                                                                   cacheName:@"tripFetchResultCache"];
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
    UITableView *tableView = self.tripListTV;
    
    if (type == NSFetchedResultsChangeInsert) {
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tripListTV reloadData];
    [self.tripListTV endUpdates];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tripListTV beginUpdates];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TRIP_LIST_CELL forIndexPath:indexPath];
    
    Trip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.nameLB.text = trip.tripName;
    cell.nameLB.font = [UIFont fontWithName:@"AppleGothic" size:16.0];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[trip.startDate doubleValue]];
    
    cell.dateLB.text = [startDate formattedDateWithFormat:@"YYYY.MM.dd"];
    
    if (trip.frontData == nil) {
        cell.frontImg.image = [UIImage imageNamed:@"defaultBackground.jpg"];
    }else{
        cell.frontImg.image = [UIImage imageWithData:trip.frontData];
    }
    

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubTripListViewController *subTripListVC = [[SubTripListViewController alloc] init];
    
    Trip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    subTripListVC.keyID = trip.keyID;
    subTripListVC.tripName = trip.tripName;
    
    [self.navigationController pushViewController:subTripListVC animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)gotoEditedController:(NSString *)saveStatus keyID:(NSString *)keyID tripName:(NSString *)tripName
{
    
    if ([saveStatus isEqualToString:@"0"]) {
        return;
    }
    
    
    
    SubTripListViewController *subTripVC = [[SubTripListViewController alloc] init];
    
    subTripVC.keyID = keyID;
    subTripVC.navigationController.title = tripName;
    
    [self.navigationController pushViewController:subTripVC animated:YES];
    
}

@end
